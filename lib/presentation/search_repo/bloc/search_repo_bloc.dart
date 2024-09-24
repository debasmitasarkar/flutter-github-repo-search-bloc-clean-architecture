import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:git_repo_search/domain/usecases/fetch_respositories_by_search.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_event.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_state.dart';
import 'package:rxdart/rxdart.dart';

class SearchRepoBloc extends Bloc<SearchRepoEvent, SearchRepoState> {
  SearchRepoBloc({required this.fetchRepositoriesBySearch})
      : super(SearchRepoInitial()) {
    on<FetchRepositories>(
      _onFetchRepositories,
      transformer: _debounceSearchEvent(),
    );
  }
  final FetchRepositoriesBySearch fetchRepositoriesBySearch;

  String _currentQuery = '';
  bool _isFetching = false;
  bool _hasReachedMax = false;
  List<GithubRepository> _repositories = [];
  int _currentPage = 1;

  EventTransformer<FetchRepositories> _debounceSearchEvent() => (
        events,
        mapper,
      ) =>
          events
              .debounceTime(const Duration(milliseconds: 300))
              .switchMap(mapper);

  void _resetData() {
    _isFetching = false;
    _hasReachedMax = false;
    _currentPage = 1;
    _repositories.clear();
  }

  Future<void> _onFetchRepositories(
    FetchRepositories event,
    Emitter<SearchRepoState> emit,
  ) async {
    if (event.searchQuery.isEmpty) {
      _resetData();
      emit(SearchRepoInitial());
      return;
    }

    if (_currentQuery != event.searchQuery || event.isRefresh) {
      _resetData();
      _currentQuery = event.searchQuery;
    }

    if (_isFetching || _hasReachedMax) {
      return;
    }

    _isFetching = true;

    if (_currentPage == 1) {
      emit(SearchRepoLoading());
    } else {
      emit(SearchRepoLoadingMore(_repositories));
    }

    final Either<Failure, List<GithubRepository>> failureOrRepositories =
        await fetchRepositoriesBySearch(
      SearchParams(
        searchQuery: _currentQuery,
        page: _currentPage,
        sort: '',
      ),
    );

    failureOrRepositories.fold(
      (failure) {
        _isFetching = false;
        emit(SearchError(message: _mapFailureToMessage(failure)));
      },
      (repositories) {
        _isFetching = false;
        _currentPage++;

        if (repositories.isEmpty) {
          _hasReachedMax = true;
          emit(SearchRepoLoaded(repositories: _repositories));
        } else {
          final updatedRepositories = List<GithubRepository>.from(_repositories)
            ..addAll(repositories);

          updatedRepositories.sort(
            (a, b) =>
                a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()),
          );

          _repositories = updatedRepositories;
          emit(SearchRepoLoaded(repositories: _repositories));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure
        ? 'Server Failure'
        : 'Unexpected Error Occurred';
  }
}

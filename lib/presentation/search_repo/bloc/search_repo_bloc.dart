import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:git_repo_search/domain/usecases/fetch_respositories_by_search.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_event.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_state.dart';

class SearchRepoBloc extends Bloc<SearchRepoEvent, SearchRepoState> {
  final FetchRepositoriesBySearch fetchRepositoriesBySearch;

  String _currentQuery = '';
  final String _sort = 'full_name';
  bool _isFetching = false;
  bool _hasReachedMax = false;
  List<GithubRepository> _repositories = [];
  int _currentPage = 1;
  int get currentPage => _currentPage;

  SearchRepoBloc({required this.fetchRepositoriesBySearch})
      : super(SearchRepoInitial()) {
    on<FetchRepositories>(_onFetchRepositories,
        transformer: _debounceSearchEvent());
  }

  EventTransformer<FetchRepositories> _debounceSearchEvent() => (events,
          mapper) =>
      events.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper);

  Future<void> _onFetchRepositories(
    FetchRepositories event,
    Emitter<SearchRepoState> emit,
  ) async {
    _currentPage = event.currentPage;
    if (event.searchQuery.isEmpty) {
      _hasReachedMax = false;
      _repositories.clear();
      emit(SearchRepoInitial());
      return;
    }

    if (_currentQuery != event.searchQuery || event.isRefresh) {
      _hasReachedMax = false;
      _repositories.clear();
      _currentQuery = event.searchQuery;
      _isFetching = false;
    }

    if (_isFetching || _hasReachedMax) return;

    _isFetching = true;

    if (event.currentPage == 1) {
      emit(SearchRepoLoading());
    } else {
      emit(SearchRepoLoadingMore(_repositories));
    }

    final Either<Failure, List<GithubRepository>> failureOrRepositories =
        await fetchRepositoriesBySearch(
      SearchParams(
        searchQuery: _currentQuery,
        page: _currentPage,
        sort: _sort,
      ),
    );

    failureOrRepositories.fold(
      (failure) {
        _isFetching = false;
        emit(SearchError(message: _mapFailureToMessage(failure)));
      },
      (repositories) {
        _isFetching = false;

        if (repositories.isEmpty) {
          _hasReachedMax = true;
        } else {
          final updatedRepositories = List<GithubRepository>.from(_repositories)
            ..addAll(repositories);

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

  bool get isFetching => _isFetching;
  bool get hasReachedMax => _hasReachedMax;
}

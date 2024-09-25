import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/usecases/fetch_issues_by_repo.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_event.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_state.dart';

class SearchDetailBloc extends Bloc<SearchDetailEvent, SearchDetailState> {
  SearchDetailBloc({required this.fetchIssuesByRepo})
      : super(SearchDetailInitial()) {
    on<FetchIssuesEvent>(_onFetchIssues);
  }
  final FetchIssuesByRepo fetchIssuesByRepo;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isFetching = false;
  List<GithubIssue> _issues = [];

  void _resetData() {
    _isFetching = false;
    _hasReachedMax = false;
    _currentPage = 1;
    _issues.clear();
  }

  Future<void> _onFetchIssues(
    FetchIssuesEvent event,
    Emitter<SearchDetailState> emit,
  ) async {
    if (event.isRefresh) {
      _resetData();
    }

    if (_hasReachedMax || _isFetching) {
      return;
    }

    _isFetching = true;

    if (_currentPage != 1) {
      emit(SearchDetailLoadingMore(_issues));
    }

    final Either<Failure, List<GithubIssue>> failureOrIssues =
        await fetchIssuesByRepo(
      FetchIssuesByRepoParams(
        ownerName: event.ownerName,
        repoName: event.repoName,
        page: _currentPage,
      ),
    );

    failureOrIssues.fold(
      (failure) {
        _resetData();
        emit(SearchDetailError(message: _mapFailureToMessage(failure)));
      },
      (issues) {
        _isFetching = false;
        _currentPage++;

        final updatedIssues = List<GithubIssue>.from(_issues)..addAll(issues);
        _issues = updatedIssues;
        if (issues.isEmpty) {
          _hasReachedMax = true;
        }
        emit(SearchDetailLoaded(issues: _issues));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure ? 'Server Error' : 'Unexpected Error';
  }
}

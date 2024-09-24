import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/usecases/fetch_issues_by_repo.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_event.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_state.dart';

class SearchDetailBloc extends Bloc<SearchDetailEvent, SearchDetailState> {
  final FetchIssuesByRepo fetchIssuesByRepo;
  int _currentPage = 1;
  bool hasReachedMax = false;
  List<GithubIssue> _issues = [];

  int get currentPage => _currentPage;

  SearchDetailBloc({required this.fetchIssuesByRepo})
      : super(SearchDetailInitial()) {
    on<FetchIssuesEvent>(_onFetchIssues);
  }

  Future<void> _onFetchIssues(
      FetchIssuesEvent event, Emitter<SearchDetailState> emit) async {
    if (hasReachedMax) return;
    _currentPage = event.page;

    if (_currentPage == 1) {
      emit(SearchDetailLoading());
    } else {
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
      (failure) =>
          emit(SearchDetailError(message: _mapFailureToMessage(failure))),
      (issues) {
        final updatedIssues = List<GithubIssue>.from(_issues)..addAll(issues);
        _issues = updatedIssues;
        if (issues.isEmpty) {
          hasReachedMax = true;
        } else {
          _currentPage++;
        }
        emit(SearchDetailLoaded(issues: _issues));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure ? 'Server Error' : 'Unexpected Error';
  }
}

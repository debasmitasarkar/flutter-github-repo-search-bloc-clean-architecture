import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/usecases/fetch_issues_by_repo.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_bloc.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_event.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchIssuesByRepo extends Mock implements FetchIssuesByRepo {}

class FakeFetchIssuesByRepoParams extends Fake
    implements FetchIssuesByRepoParams {}

void main() {
  late SearchDetailBloc searchDetailBloc;
  late MockFetchIssuesByRepo mockFetchIssuesByRepo;

  const tOwnerName = 'owner';
  const tRepoName = 'repo';
  final tIssues = [
    GithubIssue(
      id: 1,
      title: 'Issue 1',
      number: 101,
      user: 'user1',
      comments: 10,
      createdAt: DateTime.now(),
    ),
    GithubIssue(
      id: 2,
      title: 'Issue 2',
      number: 102,
      user: 'user2',
      comments: 5,
      createdAt: DateTime.now(),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeFetchIssuesByRepoParams());
  });

  setUp(() {
    mockFetchIssuesByRepo = MockFetchIssuesByRepo();
    searchDetailBloc =
        SearchDetailBloc(fetchIssuesByRepo: mockFetchIssuesByRepo);
  });

  tearDown(() {
    searchDetailBloc.close();
  });

  group('SearchDetailBloc', () {
    blocTest<SearchDetailBloc, SearchDetailState>(
      'emits [SearchDetailLoading, SearchDetailLoaded] when data is fetched successfully',
      build: () {
        when(() => mockFetchIssuesByRepo(any()))
            .thenAnswer((_) async => Right(tIssues));
        return searchDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchIssuesEvent(ownerName: tOwnerName, repoName: tRepoName));
        await Future.delayed(const Duration(milliseconds: 500));
      },
      expect: () => [
        SearchDetailLoading(),
        SearchDetailLoaded(issues: tIssues),
      ],
      verify: (bloc) {
        verify(() => mockFetchIssuesByRepo(const FetchIssuesByRepoParams(
              ownerName: tOwnerName,
              repoName: tRepoName,
              page: 1,
            ))).called(1);
      },
    );

    blocTest<SearchDetailBloc, SearchDetailState>(
      'emits [SearchDetailLoading, SearchDetailError] when fetching data fails',
      build: () {
        when(() => mockFetchIssuesByRepo(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return searchDetailBloc;
      },
      act: (bloc) => bloc
          .add(FetchIssuesEvent(ownerName: tOwnerName, repoName: tRepoName)),
      expect: () => [
        SearchDetailLoading(),
        SearchDetailError(message: 'Server Error'),
      ],
      verify: (bloc) {
        verify(() => mockFetchIssuesByRepo(const FetchIssuesByRepoParams(
              ownerName: tOwnerName,
              repoName: tRepoName,
              page: 1,
            ))).called(1);
      },
    );

    blocTest<SearchDetailBloc, SearchDetailState>(
      'emits [SearchDetailLoadingMore, SearchDetailLoaded] when more data is fetched',
      build: () {
        when(() => mockFetchIssuesByRepo(any()))
            .thenAnswer((_) async => Right(tIssues));
        return searchDetailBloc;
      },
      seed: () => SearchDetailLoaded(issues: tIssues),
      act: (bloc) {
        bloc.add(FetchIssuesEvent(
            ownerName: tOwnerName, repoName: tRepoName, page: 1));
        bloc.add(FetchIssuesEvent(
            ownerName: tOwnerName, repoName: tRepoName, page: 2));
      },
      expect: () => [
        SearchDetailLoading(),
        SearchDetailLoaded(issues: tIssues),
        SearchDetailLoadingMore(tIssues),
        SearchDetailLoaded(issues: [...tIssues, ...tIssues]),
      ],
      verify: (bloc) {
        verify(() => mockFetchIssuesByRepo(const FetchIssuesByRepoParams(
              ownerName: tOwnerName,
              repoName: tRepoName,
              page: 2,
            ))).called(1);
      },
    );

    blocTest<SearchDetailBloc, SearchDetailState>(
      'does not emit new states when hasReachedMax is true',
      build: () {
        when(() => mockFetchIssuesByRepo(any()))
            .thenAnswer((_) async => Right(tIssues));
        return searchDetailBloc;
      },
      seed: () {
        searchDetailBloc.hasReachedMax = true;
        return SearchDetailLoaded(issues: tIssues);
      },
      act: (bloc) {
        bloc.add(FetchIssuesEvent(ownerName: tOwnerName, repoName: tRepoName));
      },
      expect: () => [],
    );
  });
}

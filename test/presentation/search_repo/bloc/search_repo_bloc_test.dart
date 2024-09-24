import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:git_repo_search/domain/usecases/fetch_respositories_by_search.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_bloc.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_event.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_state.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchRepositoriesBySearch extends Mock
    implements FetchRepositoriesBySearch {}

class FakeSearchParams extends Fake implements SearchParams {}

void main() {
  late SearchRepoBloc searchRepoBloc;
  late MockFetchRepositoriesBySearch mockFetchRepositoriesBySearch;

  setUpAll(() {
    registerFallbackValue(FakeSearchParams());
  });

  setUp(() {
    mockFetchRepositoriesBySearch = MockFetchRepositoriesBySearch();
    searchRepoBloc = SearchRepoBloc(
        fetchRepositoriesBySearch: mockFetchRepositoriesBySearch);
  });

  tearDown(() {
    searchRepoBloc.close();
  });

  const tSearchQuery = 'flutter';
  final tRepositories = [
    const GithubRepository(
      id: 1,
      name: 'flutter/flutter',
      fullName: 'flutter/flutter',
      ownerName: 'flutter',
      ownerAvatarUrl: 'https://example.com/avatar.png',
      description: 'A sample Flutter repository',
      stargazersCount: 1000,
      forksCount: 500,
      license: 'MIT',
      openIssuesCount: 20,
      size: 200,
    ),
  ];

  test('Initial state should be SearchRepoInitial', () {
    expect(searchRepoBloc.state, equals(SearchRepoInitial()));
  });

  blocTest<SearchRepoBloc, SearchRepoState>(
    'emits [SearchRepoLoading, SearchRepoLoaded] when data is fetched successfully for the first page',
    build: () {
      when(() => mockFetchRepositoriesBySearch(any()))
          .thenAnswer((_) async => Right(tRepositories));
      return searchRepoBloc;
    },
    act: (bloc) async {
      bloc.add(FetchRepositories(searchQuery: tSearchQuery));
      await Future.delayed(const Duration(milliseconds: 500));
    },
    expect: () => [
      SearchRepoLoading(),
      SearchRepoLoaded(repositories: tRepositories),
    ],
    verify: (bloc) {
      verify(() => mockFetchRepositoriesBySearch(const SearchParams(
            searchQuery: tSearchQuery,
            page: 1,
            sort: 'full_name',
          ))).called(1);
    },
  );

  blocTest<SearchRepoBloc, SearchRepoState>(
    'emits [SearchRepoLoadingMore, SearchRepoLoaded] when more data is fetched on the next page',
    build: () {
      when(() => mockFetchRepositoriesBySearch(any()))
          .thenAnswer((_) async => Right(tRepositories));
      return searchRepoBloc;
    },
    seed: () => SearchRepoLoaded(repositories: tRepositories),
    act: (bloc) async {
      searchRepoBloc
          .add(FetchRepositories(searchQuery: tSearchQuery, currentPage: 1));
      await Future.delayed(const Duration(milliseconds: 500));
      searchRepoBloc
          .add(FetchRepositories(searchQuery: tSearchQuery, currentPage: 2));
      await Future.delayed(const Duration(milliseconds: 500));
    },
    expect: () => [
      SearchRepoLoading(),
      SearchRepoLoaded(repositories: tRepositories),
      SearchRepoLoadingMore(tRepositories),
      SearchRepoLoaded(repositories: [...tRepositories, ...tRepositories]),
    ],
    verify: (bloc) {
      verify(() => mockFetchRepositoriesBySearch(const SearchParams(
            searchQuery: tSearchQuery,
            page: 2,
            sort: 'full_name',
          ))).called(1);
    },
  );

  blocTest<SearchRepoBloc, SearchRepoState>(
    'emits [SearchRepoLoading, SearchError] when fetching data fails',
    build: () {
      when(() => mockFetchRepositoriesBySearch(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      return searchRepoBloc;
    },
    act: (bloc) async {
      bloc.add(FetchRepositories(searchQuery: tSearchQuery));
      await Future.delayed(const Duration(milliseconds: 500));
    },
    expect: () => [
      SearchRepoLoading(),
      SearchError(message: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(() => mockFetchRepositoriesBySearch(const SearchParams(
            searchQuery: tSearchQuery,
            page: 1,
            sort: 'full_name',
          ))).called(1);
    },
  );

  blocTest<SearchRepoBloc, SearchRepoState>(
    'emits [SearchRepoInitial] when search query is empty',
    build: () {
      return searchRepoBloc;
    },
    act: (bloc) => bloc.add(FetchRepositories(searchQuery: '')),
    expect: () => [SearchRepoInitial()],
  );
}

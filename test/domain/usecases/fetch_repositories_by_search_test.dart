import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:git_repo_search/domain/repositories/github_repo_search_repository.dart';
import 'package:git_repo_search/domain/usecases/fetch_respositories_by_search.dart';
import 'package:mocktail/mocktail.dart';

class MockGithubRepoSearchRepository extends Mock
    implements GithubRepoSearchRepository {}

void main() {
  late FetchRepositoriesBySearch usecase;
  late MockGithubRepoSearchRepository mockRepository;

  const tSearchQuery = 'flutter';
  const tPage = 1;
  const tSort = 'stars';

  const tGithubRepository = GithubRepository(
    id: 1,
    name: 'flutter',
    fullName: 'flutter/flutter',
    ownerName: 'flutter',
    ownerAvatarUrl: 'https://avatars.githubusercontent.com/u/14101776?v=4',
    description: 'Flutter framework',
    size: 1000,
    stargazersCount: 150000,
    forksCount: 20000,
    license: 'BSD-3-Clause',
    openIssuesCount: 5000,
  );

  final List<GithubRepository> tGithubRepositories = [tGithubRepository];
  const tParams = SearchParams(
    searchQuery: tSearchQuery,
    page: tPage,
    sort: tSort,
  );

  setUp(() {
    mockRepository = MockGithubRepoSearchRepository();
    usecase = FetchRepositoriesBySearch(mockRepository);
  });

  test('should get list of GitHub repositories from the repository', () async {
    // Arrange
    when(() => mockRepository.getRepositoriesWithSearchQuery(
          searchQuery: tSearchQuery,
          page: tPage,
          sort: tSort,
        )).thenAnswer((_) async => Right(tGithubRepositories));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tGithubRepositories));
    verify(() => mockRepository.getRepositoriesWithSearchQuery(
          searchQuery: tSearchQuery,
          page: tPage,
          sort: tSort,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // Arrange
    when(() => mockRepository.getRepositoriesWithSearchQuery(
          searchQuery: tSearchQuery,
          page: tPage,
          sort: tSort,
        )).thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(ServerFailure()));
    verify(() => mockRepository.getRepositoriesWithSearchQuery(
          searchQuery: tSearchQuery,
          page: tPage,
          sort: tSort,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

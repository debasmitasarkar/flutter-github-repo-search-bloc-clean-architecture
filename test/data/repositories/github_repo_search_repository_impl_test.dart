import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/core/error/exceptions.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/data/datasources/remote_datasource/git_repo_remote_datasource.dart';
import 'package:git_repo_search/data/models/github_issue_model.dart';
import 'package:git_repo_search/data/models/github_repository_model.dart';
import 'package:git_repo_search/data/repositories/github_repo_search_repository_impl.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockGitHubRepoRemoteDataSource extends Mock
    implements GitHubRepoRemoteDataSource {}

void main() {
  late GithubRepoSearchRepositoryImpl repository;
  late MockGitHubRepoRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockGitHubRepoRemoteDataSource();
    repository = GithubRepoSearchRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('getRepositoriesWithSearchQuery', () {
    const tSearchQuery = 'flutter';
    const tPage = 1;
    const tSort = 'stars';
    final tRepositoriesModel = [
      GithubRepositoryModel(
        repoId: 1,
        repoName: 'flutter',
        repoFullName: 'flutter/flutter',
        owner: Owner(
          id: 1,
          avatarUrl: 'https://example.com/avatar.png',
          login: 'flutter',
        ),
        repoDescription: 'A UI toolkit for building natively compiled apps',
        repoSize: 1000,
        repoStargazersCount: 120000,
        repoForksCount: 15000,
        repoOpenIssuesCount: 1000,
        repoLicense: License(name: 'MIT'),
      ),
    ];
    final List<GithubRepository> tRepositories = tRepositoriesModel;

    test('should return a list of repositories when the call is successful',
        () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getRepositoriesWithSearchQuery(
          searchQuery: tSearchQuery,
          page: tPage,
          sort: tSort,
        ),
      ).thenAnswer((_) async => tRepositoriesModel);

      // Act
      final result = await repository.getRepositoriesWithSearchQuery(
        searchQuery: tSearchQuery,
        page: tPage,
        sort: tSort,
      );

      // Assert
      expect(result, equals(Right(tRepositories)));
      verify(
        () => mockRemoteDataSource.getRepositoriesWithSearchQuery(
          searchQuery: tSearchQuery,
          page: tPage,
          sort: tSort,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when the call throws a ServerException',
        () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getRepositoriesWithSearchQuery(
          searchQuery: tSearchQuery,
          page: tPage,
          sort: tSort,
        ),
      ).thenThrow(ServerException());

      // Act
      final result = await repository.getRepositoriesWithSearchQuery(
        searchQuery: tSearchQuery,
        page: tPage,
        sort: tSort,
      );

      // Assert
      expect(result, equals(Left(ServerFailure())));
      verify(
        () => mockRemoteDataSource.getRepositoriesWithSearchQuery(
          searchQuery: tSearchQuery,
          page: tPage,
          sort: tSort,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('getRepositoryOpenIssues', () {
    const tOwnerName = 'flutter';
    const tRepoName = 'flutter';
    const tSort = 'created';
    const tPage = 1;

    final tIssueModels = [
      GithubIssueModel(
        issueId: 1,
        issueTitle: 'Issue 1',
        issueNumber: 1,
        createdAtByUser: '2021-08-01T00:00:00Z',
        commentsCount: 10,
        createdByUser: User(login: 'user1'),
      ),
    ];
    final List<GithubIssue> tIssues = tIssueModels;

    test('should return a list of issues when the call is successful',
        () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getRepositoryOpenIssues(
          ownerName: tOwnerName,
          repositoryName: tRepoName,
          sort: tSort,
          page: tPage,
        ),
      ).thenAnswer((_) async => tIssueModels);

      // Act
      final result = await repository.getRepositoryOpenIssues(
        ownerName: tOwnerName,
        repositoryName: tRepoName,
        sort: tSort,
        page: tPage,
      );

      // Assert
      expect(result, equals(Right(tIssues)));
      verify(
        () => mockRemoteDataSource.getRepositoryOpenIssues(
          ownerName: tOwnerName,
          repositoryName: tRepoName,
          sort: tSort,
          page: tPage,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when the call throws a ServerException',
        () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getRepositoryOpenIssues(
          ownerName: tOwnerName,
          repositoryName: tRepoName,
          sort: tSort,
          page: tPage,
        ),
      ).thenThrow(ServerException());

      // Act
      final result = await repository.getRepositoryOpenIssues(
        ownerName: tOwnerName,
        repositoryName: tRepoName,
        sort: tSort,
        page: tPage,
      );

      // Assert
      expect(result, equals(Left(ServerFailure())));
      verify(
        () => mockRemoteDataSource.getRepositoryOpenIssues(
          ownerName: tOwnerName,
          repositoryName: tRepoName,
          sort: tSort,
          page: tPage,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}

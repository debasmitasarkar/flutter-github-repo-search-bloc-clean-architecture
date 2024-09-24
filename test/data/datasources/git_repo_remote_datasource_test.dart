import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/core/error/exceptions.dart';
import 'package:git_repo_search/data/datasources/remote_datasource/git_repo_remote_datasource.dart';
import 'package:git_repo_search/data/models/github_issue_model.dart';
import 'package:git_repo_search/data/models/github_repository_model.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late GitRepoRemoteDatasourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    registerFallbackValue(Uri());
    mockHttpClient = MockHttpClient();
    dataSource = GitRepoRemoteDatasourceImpl(client: mockHttpClient);
  });

  const tSearchQuery = 'flutter';
  const tOwnerName = 'flutter';
  const tRepoName = 'flutter';
  const tSort = 'stars';
  const tPage = 1;

  final tRepositoryModels = [
    GithubRepositoryModel(
      repoId: 1,
      repoName: 'Test Repo 1',
      repoFullName: 'flutter/Test Repo 1',
      owner: Owner(id: 1, avatarUrl: 'avatarUrl', login: 'owner'),
      repoDescription: 'A sample repository',
      repoSize: 100,
      repoStargazersCount: 150,
      repoForksCount: 50,
      repoLicense: License(name: 'MIT'),
      repoOpenIssuesCount: 10,
    ),
  ];

  final tIssueModels = [
    GithubIssueModel(
      issueId: 1,
      issueTitle: 'Test Issue 1',
      issueNumber: 101,
      commentsCount: 5,
      createdByUser: User(login: 'user1'),
      createdAtByUser: '2021-09-01T00:00:00Z',
    ),
  ];

  group('getRepositoriesWithSearchQuery', () {
    test(
        'should return list of repositories when the response is 200 (success)',
        () async {
      // Arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'items': tRepositoryModels.map((e) => e.toJson()).toList(),
          }),
          200,
        ),
      );

      // Act
      final result = await dataSource.getRepositoriesWithSearchQuery(
        searchQuery: tSearchQuery,
        page: tPage,
        sort: tSort,
      );

      // Assert
      expect(result, equals(tRepositoryModels));
      verify(
        () => mockHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).called(1);
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      // Arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );

      // Act
      final call = dataSource.getRepositoriesWithSearchQuery;

      // Assert
      expect(
        () => call(searchQuery: tSearchQuery, page: tPage, sort: tSort),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getRepositoryOpenIssues', () {
    test('should return list of issues when the response is 200 (success)',
        () async {
      // Arrange
      final tIssueModelsJson =
          jsonEncode(tIssueModels.map((e) => e.toJson()).toList());

      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(tIssueModelsJson, 200));

      // Act
      final result = await dataSource.getRepositoryOpenIssues(
        ownerName: tOwnerName,
        repositoryName: tRepoName,
        sort: tSort,
        page: tPage,
      );

      // Assert
      expect(result, equals(tIssueModels));
      verify(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .called(1);
    });

    test('should throw ServerException when the response code is not 200',
        () async {
      // Arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );

      // Act
      final call = dataSource.getRepositoryOpenIssues;

      // Assert
      expect(
        () => call(
          ownerName: tOwnerName,
          repositoryName: tRepoName,
          sort: tSort,
          page: tPage,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

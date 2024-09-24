import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:git_repo_search/core/utils/locator.dart';
import 'package:git_repo_search/data/datasources/remote_datasource/git_repo_remote_datasource.dart';
import 'package:git_repo_search/data/repositories/github_repo_search_repository_impl.dart';
import 'package:git_repo_search/domain/usecases/fetch_issues_by_repo.dart';
import 'package:git_repo_search/domain/usecases/fetch_respositories_by_search.dart';
import 'package:http/http.dart' as http;

void main() {
  final locator = GetIt.instance;

  setUp(() {
    locator.reset();
  });

  tearDown(() {
    locator.reset();
  });

  test('should register all dependencies', () {
    // Arrange
    setUpLocator(); 

    // Act & Assert
    expect(locator.isRegistered<GitRepoRemoteDatasourceImpl>(), true);
    expect(locator.isRegistered<GithubRepoSearchRepositoryImpl>(), true);
    expect(locator.isRegistered<FetchRepositoriesBySearch>(), true);
    expect(locator.isRegistered<FetchIssuesByRepo>(), true);
  });

  test('should resolve GitRepoRemoteDatasourceImpl correctly', () {
    // Arrange
    setUpLocator();

    // Act
    final remoteDataSource = locator<GitRepoRemoteDatasourceImpl>();

    // Assert
    expect(remoteDataSource, isA<GitRepoRemoteDatasourceImpl>());
    expect(remoteDataSource.client, isA<http.Client>());
  });

  test('should resolve GithubRepoSearchRepositoryImpl correctly', () {
    // Arrange
    setUpLocator();

    // Act
    final repository = locator<GithubRepoSearchRepositoryImpl>();

    // Assert
    expect(repository, isA<GithubRepoSearchRepositoryImpl>());
    expect(repository.remoteDataSource, isA<GitRepoRemoteDatasourceImpl>());
  });

  test('should resolve use cases correctly', () {
    // Arrange
    setUpLocator();

    // Act
    final fetchRepositoriesUseCase = locator<FetchRepositoriesBySearch>();
    final fetchIssuesUseCase = locator<FetchIssuesByRepo>();

    // Assert
    expect(fetchRepositoriesUseCase, isA<FetchRepositoriesBySearch>());
    expect(fetchIssuesUseCase, isA<FetchIssuesByRepo>());
  });
}

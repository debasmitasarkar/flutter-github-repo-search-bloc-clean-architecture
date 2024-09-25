import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/repositories/github_repo_search_repository.dart';
import 'package:git_repo_search/domain/usecases/fetch_issues_by_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockGithubRepoSearchRepository extends Mock
    implements GithubRepoSearchRepository {}

void main() {
  late FetchIssuesByRepo usecase;
  late MockGithubRepoSearchRepository mockRepository;

  const tOwnerName = 'testOwner';
  const tRepoName = 'testRepo';
  const tPage = 1;
  const tSort = 'created';

  final tGithubIssue = GithubIssue(
    id: 1,
    title: 'Test Issue',
    number: 101,
    user: 'testUser',
    comments: 2,
    createdAt: DateTime.parse('2023-01-01T12:34:56Z'),
  );

  final List<GithubIssue> tGithubIssues = [tGithubIssue];
  const tParams = FetchIssuesByRepoParams(
    ownerName: tOwnerName,
    repoName: tRepoName,
    page: tPage,
  );

  setUp(() {
    mockRepository = MockGithubRepoSearchRepository();
    usecase = FetchIssuesByRepo(mockRepository);
  });

  test('should get list of GitHub issues from the repository', () async {
    // Arrange
    when(
      () => mockRepository.getRepositoryOpenIssues(
        ownerName: tOwnerName,
        repositoryName: tRepoName,
        page: tPage,
        sort: tSort,
      ),
    ).thenAnswer((_) async => Right(tGithubIssues));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tGithubIssues));
    verify(
      () => mockRepository.getRepositoryOpenIssues(
        ownerName: tOwnerName,
        repositoryName: tRepoName,
        page: tPage,
        sort: tSort,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // Arrange
    when(
      () => mockRepository.getRepositoryOpenIssues(
        ownerName: tOwnerName,
        repositoryName: tRepoName,
        page: tPage,
        sort: tSort,
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Left(ServerFailure()));
    verify(
      () => mockRepository.getRepositoryOpenIssues(
        ownerName: tOwnerName,
        repositoryName: tRepoName,
        page: tPage,
        sort: tSort,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

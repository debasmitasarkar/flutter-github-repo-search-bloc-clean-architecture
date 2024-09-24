import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/data/models/github_repository_model.dart';

void main() {
  const tRepoId = 123;
  const tRepoName = 'Test Repo';
  const tRepoFullName = 'testuser/test_repo';
  const tRepoDescription = 'This is a test repository';
  const tRepoSize = 2048;
  const tRepoStargazersCount = 100;
  const tRepoForksCount = 50;
  const tRepoOpenIssuesCount = 10;
  const tOwnerAvatarUrl = 'https://example.com/avatar.png';
  const tOwnerLogin = 'testuser';
  const tLicenseName = 'MIT License';

  final tOwner = Owner(
    id: 1,
    avatarUrl: tOwnerAvatarUrl,
    login: tOwnerLogin,
  );

  final tLicense = License(name: tLicenseName);

  final tGithubRepositoryModel = GithubRepositoryModel(
    repoId: tRepoId,
    repoName: tRepoName,
    repoFullName: tRepoFullName,
    owner: tOwner,
    repoDescription: tRepoDescription,
    repoSize: tRepoSize,
    repoStargazersCount: tRepoStargazersCount,
    repoForksCount: tRepoForksCount,
    repoLicense: tLicense,
    repoOpenIssuesCount: tRepoOpenIssuesCount,
  );

  final tJson = {
    'id': tRepoId,
    'name': tRepoName,
    'full_name': tRepoFullName,
    'owner': {
      'avatar_url': tOwnerAvatarUrl,
      'id': 1,
      'login': tOwnerLogin,
    },
    'description': tRepoDescription,
    'size': tRepoSize,
    'stargazers_count': tRepoStargazersCount,
    'forks_count': tRepoForksCount,
    'license': {
      'name': tLicenseName,
    },
    'open_issues_count': tRepoOpenIssuesCount,
  };

  group('GithubRepositoryModel', () {
    test('should be a subclass of GithubRepository', () {
      expect(tGithubRepositoryModel, isA<GithubRepositoryModel>());
    });

    test('fromJson should return a valid model', () {
      // Act
      final result = GithubRepositoryModel.fromJson(tJson);

      // Assert
      expect(result, tGithubRepositoryModel);
    });
  });
}

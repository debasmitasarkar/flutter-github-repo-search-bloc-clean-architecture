import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/data/models/github_issue_model.dart';

void main() {
  const tIssueId = 123;
  const tIssueTitle = 'Test Issue';
  const tIssueNumber = 456;
  const tUserLogin = 'testuser';
  const tCommentsCount = 10;
  const tCreatedAt = '2023-01-01T00:00:00Z';

  final tUser = User(login: tUserLogin);

  final tGithubIssueModel = GithubIssueModel(
    issueId: tIssueId,
    issueTitle: tIssueTitle,
    issueNumber: tIssueNumber,
    createdByUser: tUser,
    commentsCount: tCommentsCount,
    createdAtByUser: tCreatedAt,
  );

  final tJson = {
    'id': tIssueId,
    'title': tIssueTitle,
    'number': tIssueNumber,
    'user': {
      'login': tUserLogin,
    },
    'comments': tCommentsCount,
    'created_at': tCreatedAt,
  };

  group('GithubIssueModel', () {
    test('should be a subclass of GithubIssue', () {
      expect(tGithubIssueModel, isA<GithubIssueModel>());
    });

    test('fromJson should return a valid model', () {
      // Act
      final result = GithubIssueModel.fromJson(tJson);

      // Assert
      expect(result, tGithubIssueModel);
    });
  });

  group('User Model', () {
    final tUserJson = {'login': tUserLogin};
    test('User toJson should return a valid JSON map containing proper data',
        () {
      // Act
      final result = tUser.toJson();

      // Assert
      expect(result, tUserJson);
    });
  });
}

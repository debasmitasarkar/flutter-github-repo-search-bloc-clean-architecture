import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github_issue_model.g.dart';

@JsonSerializable()
class GithubIssueModel extends GithubIssue {
  @JsonKey(name: 'id')
  final int issueId;
  @JsonKey(name: 'title')
  final String issueTitle;
  @JsonKey(name: 'number')
  final int issueNumber;
  @JsonKey(name: 'user')
  final User createdByUser;
  @JsonKey(name: 'comments')
  final int commentsCount;
  @JsonKey(name: 'created_at')
  final String createdAtByUser;

  GithubIssueModel({
    required this.issueId,
    required this.issueTitle,
    required this.issueNumber,
    required this.createdByUser,
    required this.commentsCount,
    required this.createdAtByUser,
  }) : super(
          id: issueId,
          title: issueTitle,
          number: issueNumber,
          user: createdByUser.login,
          comments: commentsCount,
          createdAt: DateTime.parse(createdAtByUser),
        );

  factory GithubIssueModel.fromJson(Map<String, dynamic> json) =>
      _$GithubIssueModelFromJson(json);
  Map<String, dynamic> toJson() => _$GithubIssueModelToJson(this);
}

@JsonSerializable()
class User {
  final String login;

  User({
    required this.login,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

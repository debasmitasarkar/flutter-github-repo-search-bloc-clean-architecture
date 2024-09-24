// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubIssueModel _$GithubIssueModelFromJson(Map<String, dynamic> json) =>
    GithubIssueModel(
      issueId: (json['id'] as num).toInt(),
      issueTitle: json['title'] as String,
      issueNumber: (json['number'] as num).toInt(),
      createdByUser: User.fromJson(json['user'] as Map<String, dynamic>),
      commentsCount: (json['comments'] as num).toInt(),
      createdAtByUser: json['created_at'] as String,
    );

Map<String, dynamic> _$GithubIssueModelToJson(GithubIssueModel instance) =>
    <String, dynamic>{
      'id': instance.issueId,
      'title': instance.issueTitle,
      'number': instance.issueNumber,
      'user': instance.createdByUser,
      'comments': instance.commentsCount,
      'created_at': instance.createdAtByUser,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      login: json['login'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'login': instance.login,
    };

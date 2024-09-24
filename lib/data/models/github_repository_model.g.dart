// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repository_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubRepositoryModel _$GithubRepositoryModelFromJson(
  Map<String, dynamic> json,
) =>
    GithubRepositoryModel(
      repoId: (json['id'] as num).toInt(),
      repoName: json['name'] as String,
      repoFullName: json['full_name'] as String,
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      repoDescription: json['description'] as String?,
      repoSize: (json['size'] as num).toInt(),
      repoStargazersCount: (json['stargazers_count'] as num).toInt(),
      repoForksCount: (json['forks_count'] as num).toInt(),
      repoLicense: json['license'] == null
          ? null
          : License.fromJson(json['license'] as Map<String, dynamic>),
      repoOpenIssuesCount: (json['open_issues_count'] as num).toInt(),
    );

Map<String, dynamic> _$GithubRepositoryModelToJson(
  GithubRepositoryModel instance,
) =>
    <String, dynamic>{
      'id': instance.repoId,
      'name': instance.repoName,
      'full_name': instance.repoFullName,
      'owner': instance.owner.toJson(),
      'description': instance.repoDescription,
      'size': instance.repoSize,
      'stargazers_count': instance.repoStargazersCount,
      'forks_count': instance.repoForksCount,
      'license': instance.repoLicense?.toJson(),
      'open_issues_count': instance.repoOpenIssuesCount,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      id: (json['id'] as num).toInt(),
      avatarUrl: json['avatar_url'] as String,
      login: json['login'] as String,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'avatar_url': instance.avatarUrl,
      'id': instance.id,
      'login': instance.login,
    };

License _$LicenseFromJson(Map<String, dynamic> json) => License(
      name: json['name'] as String,
    );

Map<String, dynamic> _$LicenseToJson(License instance) => <String, dynamic>{
      'name': instance.name,
    };

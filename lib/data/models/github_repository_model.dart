import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github_repository_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GithubRepositoryModel extends GithubRepository {
  GithubRepositoryModel({
    required this.repoId,
    required this.repoName,
    required this.repoFullName,
    required this.owner,
    this.repoDescription,
    required this.repoSize,
    required this.repoStargazersCount,
    required this.repoForksCount,
    this.repoLicense,
    required this.repoOpenIssuesCount,
  }) : super(
          id: repoId,
          name: repoName,
          fullName: repoFullName,
          ownerName: owner.login,
          ownerAvatarUrl: owner.avatarUrl,
          description: repoDescription,
          size: repoSize,
          stargazersCount: repoStargazersCount,
          forksCount: repoForksCount,
          license: repoLicense?.name,
          openIssuesCount: repoOpenIssuesCount,
        );

  factory GithubRepositoryModel.fromJson(Map<String, dynamic> json) =>
      _$GithubRepositoryModelFromJson(json);
  @JsonKey(name: 'id')
  final int repoId;
  @JsonKey(name: 'name')
  final String repoName;
  @JsonKey(name: 'full_name')
  final String repoFullName;
  final Owner owner;
  @JsonKey(name: 'description')
  final String? repoDescription;
  @JsonKey(name: 'size')
  final int repoSize;
  @JsonKey(name: 'stargazers_count')
  final int repoStargazersCount;
  @JsonKey(name: 'forks_count')
  final int repoForksCount;
  @JsonKey(name: 'license')
  final License? repoLicense;
  @JsonKey(name: 'open_issues_count')
  final int repoOpenIssuesCount;
  Map<String, dynamic> toJson() => _$GithubRepositoryModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Owner {
  Owner({
    required this.id,
    required this.avatarUrl,
    required this.login,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  final int id;
  final String login;
  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}

@JsonSerializable(explicitToJson: true)
class License {
  License({
    required this.name,
  });

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);
  final String name;
  Map<String, dynamic> toJson() => _$LicenseToJson(this);
}

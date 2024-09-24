import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:git_repo_search/core/base_usecase.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/repositories/github_repo_search_repository.dart';

class FetchIssuesByRepo
    extends BaseUsecase<List<GithubIssue>, FetchIssuesByRepoParams> {
  final GithubRepoSearchRepository repository;

  FetchIssuesByRepo(this.repository);

  @override
  Future<Either<Failure, List<GithubIssue>>> call(
      FetchIssuesByRepoParams params) async {
    return await repository.getRepositoryOpenIssues(
      ownerName: params.ownerName,
      page: params.page,
      sort: 'created',
      repositoryName: params.repoName,
    );
  }
}

class FetchIssuesByRepoParams extends Equatable {
  final String ownerName;
  final String repoName;
  final int page;

  const FetchIssuesByRepoParams({
    required this.ownerName,
    required this.repoName,
    required this.page,
  });

  @override
  List<Object?> get props => [ownerName, repoName, page];
}

import 'package:dartz/dartz.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';

abstract class GithubRepoSearchRepository {
  Future<Either<Failure, List<GithubRepository>>>
      getRepositoriesWithSearchQuery({
    required String searchQuery,
    required int page,
    required String sort,
  });

  Future<Either<Failure, List<GithubIssue>>> getRepositoryOpenIssues({
    required String ownerName,
    required String repositoryName,
    required String sort,
    required int page,
  });
}

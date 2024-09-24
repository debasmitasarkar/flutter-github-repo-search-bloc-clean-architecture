import 'package:dartz/dartz.dart';
import 'package:git_repo_search/core/error/exceptions.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/data/datasources/remote_datasource/git_repo_remote_datasource.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:git_repo_search/domain/repositories/github_repo_search_repository.dart';

class GithubRepoSearchRepositoryImpl implements GithubRepoSearchRepository {
  GithubRepoSearchRepositoryImpl({
    required this.remoteDataSource,
  });
  final GitHubRepoRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<GithubRepository>>>
      getRepositoriesWithSearchQuery({
    required String searchQuery,
    required int page,
    required String sort,
  }) async {
    try {
      final result = await remoteDataSource.getRepositoriesWithSearchQuery(
        searchQuery: searchQuery,
        page: page,
        sort: sort,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<GithubIssue>>> getRepositoryOpenIssues({
    required String ownerName,
    required String repositoryName,
    required String sort,
    required int page,
  }) async {
    try {
      final result = await remoteDataSource.getRepositoryOpenIssues(
        ownerName: ownerName,
        repositoryName: repositoryName,
        sort: sort,
        page: page,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

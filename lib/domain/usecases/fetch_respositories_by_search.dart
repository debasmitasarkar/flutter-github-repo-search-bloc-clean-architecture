import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:git_repo_search/core/base_usecase.dart';
import 'package:git_repo_search/core/error/failures.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:git_repo_search/domain/repositories/github_repo_search_repository.dart';

class FetchRepositoriesBySearch
    implements BaseUsecase<List<GithubRepository>, SearchParams> {
  FetchRepositoriesBySearch(this.repository);
  final GithubRepoSearchRepository repository;

  @override
  Future<Either<Failure, List<GithubRepository>>> call(
    SearchParams params,
  ) async {
    return repository.getRepositoriesWithSearchQuery(
      searchQuery: params.searchQuery,
      page: params.page,
      sort: params.sort,
    );
  }
}

class SearchParams extends Equatable {
  const SearchParams({
    required this.searchQuery,
    required this.page,
    required this.sort,
  });
  final String searchQuery;
  final int page;
  final String sort;

  @override
  List<Object> get props => [searchQuery, page, sort];
}

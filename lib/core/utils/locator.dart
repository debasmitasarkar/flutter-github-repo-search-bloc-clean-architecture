import 'package:get_it/get_it.dart';
import 'package:git_repo_search/domain/usecases/fetch_issues_by_repo.dart';
import 'package:http/http.dart' as http;
import 'package:git_repo_search/data/datasources/remote_datasource/git_repo_remote_datasource.dart';
import 'package:git_repo_search/data/repositories/github_repo_search_repository_impl.dart';
import 'package:git_repo_search/domain/usecases/fetch_respositories_by_search.dart';

final locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => GitRepoRemoteDatasourceImpl(
        client: http.Client(),
      ));
  locator.registerLazySingleton(() => GithubRepoSearchRepositoryImpl(
      remoteDataSource: locator<GitRepoRemoteDatasourceImpl>()));
  locator.registerLazySingleton(() =>
      FetchRepositoriesBySearch(locator<GithubRepoSearchRepositoryImpl>()));
  locator.registerLazySingleton(
      () => FetchIssuesByRepo(locator<GithubRepoSearchRepositoryImpl>()));
}

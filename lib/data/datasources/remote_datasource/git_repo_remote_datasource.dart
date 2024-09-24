import 'dart:convert';

import 'package:git_repo_search/core/error/exceptions.dart';
import 'package:git_repo_search/data/models/github_issue_model.dart';
import 'package:git_repo_search/data/models/github_repository_model.dart';
import 'package:http/http.dart' as http;

abstract class GitHubRepoRemoteDataSource {
  Future<List<GithubRepositoryModel>> getRepositoriesWithSearchQuery({
    required String searchQuery,
    required int page,
    required String sort,
  });

  Future<List<GithubIssueModel>> getRepositoryOpenIssues({
    required String ownerName,
    required String repositoryName,
    required String sort,
    required int page,
  });
}

class GitRepoRemoteDatasourceImpl implements GitHubRepoRemoteDataSource {
  final http.Client client;

  GitRepoRemoteDatasourceImpl({required this.client});

  @override
  Future<List<GithubRepositoryModel>> getRepositoriesWithSearchQuery({
    required String searchQuery,
    required int page,
    required String sort,
  }) async {
    final response = await client.get(
      Uri.parse(
          'https://api.github.com/search/repositories?q=$searchQuery+in:name&sort=$sort&page=$page&per_page=20&order=asc'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['items'];
      return data.map((e) => GithubRepositoryModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<GithubIssueModel>> getRepositoryOpenIssues({
    required String ownerName,
    required String repositoryName,
    required String sort,
    required int page,
  }) async {
    final response = await client.get(
      Uri.parse(
          'https://api.github.com/repos/$ownerName/$repositoryName/issues?state=open&sort=$sort&per_page=20&page=$page'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => GithubIssueModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }
}

import 'dart:convert';

import 'package:git_repo_search/core/constants/api_constants.dart';
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
  GitRepoRemoteDatasourceImpl({required this.client});
  final http.Client client;
  final int perPageQuantity = 30;

  @override
  Future<List<GithubRepositoryModel>> getRepositoriesWithSearchQuery({
    required String searchQuery,
    required int page,
    required String sort,
  }) async {
    final Map<String, String> queryMap = {
      'q': '$searchQuery in:name',
      'sort': sort,
      'page': page.toString(),
      'per_page': perPageQuantity.toString(),
      'order': 'asc',
    };
    final response = await client.get(
      Uri.https(
        ApiConstants.baseUrl,
        ApiConstants.searchEndPoint,
        queryMap,
      ),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      // ignore: avoid_dynamic_calls
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
    final Map<String, dynamic> queryMap = {
      'sort': sort,
      'page': page.toString(),
      'per_page': perPageQuantity.toString(),
      'order': 'asc',
    };
    final response = await client.get(
      Uri.https(
        ApiConstants.baseUrl,
        ApiConstants.getIssuesEndPoint(ownerName, repositoryName),
        queryMap,
      ),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => GithubIssueModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }
}

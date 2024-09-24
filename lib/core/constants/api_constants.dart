class ApiConstants {
  static const String baseUrl = 'api.github.com';
  static const String searchEndPoint = '/search/repositories';
  static String getIssuesEndPoint(String owner, String repo) {
    return '/repos/$owner/$repo/issues';
  }

  static Map<String, String> headers = {
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  };
}

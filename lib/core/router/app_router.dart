import 'package:auto_route/auto_route.dart';
import 'package:git_repo_search/core/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: RepoSearchRoute.page,
          initial: true,
          path: '/searchRepositories',
        ),
        AutoRoute(page: SearchDetailRoute.page, path: '/repoDetails'),
      ];
}

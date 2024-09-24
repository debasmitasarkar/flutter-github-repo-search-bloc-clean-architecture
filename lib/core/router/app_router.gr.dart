// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;
import 'package:git_repo_search/presentation/search_repo/repo_search_page.dart'
    as _i1;
import 'package:git_repo_search/presentation/search_repo_detail/search_detail_page.dart'
    as _i2;

/// generated route for
/// [_i1.RepoSearchPage]
class RepoSearchRoute extends _i3.PageRouteInfo<void> {
  const RepoSearchRoute({List<_i3.PageRouteInfo>? children})
      : super(
          RepoSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'RepoSearchRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return _i3.WrappedRoute(child: const _i1.RepoSearchPage());
    },
  );
}

/// generated route for
/// [_i2.SearchDetailPage]
class SearchDetailRoute extends _i3.PageRouteInfo<SearchDetailRouteArgs> {
  SearchDetailRoute({
    required String ownerName,
    required String repoName,
    _i4.Key? key,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          SearchDetailRoute.name,
          args: SearchDetailRouteArgs(
            ownerName: ownerName,
            repoName: repoName,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchDetailRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchDetailRouteArgs>();
      return _i3.WrappedRoute(
          child: _i2.SearchDetailPage(
        ownerName: args.ownerName,
        repoName: args.repoName,
        key: args.key,
      ));
    },
  );
}

class SearchDetailRouteArgs {
  const SearchDetailRouteArgs({
    required this.ownerName,
    required this.repoName,
    this.key,
  });

  final String ownerName;

  final String repoName;

  final _i4.Key? key;

  @override
  String toString() {
    return 'SearchDetailRouteArgs{ownerName: $ownerName, repoName: $repoName, key: $key}';
  }
}

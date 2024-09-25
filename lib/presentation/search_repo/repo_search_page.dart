import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_repo_search/core/constants/style_constants.dart';
import 'package:git_repo_search/core/router/app_router.gr.dart';
import 'package:git_repo_search/core/utils/extensions.dart';
import 'package:git_repo_search/core/utils/locator.dart';
import 'package:git_repo_search/domain/usecases/fetch_respositories_by_search.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_bloc.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_event.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_state.dart';
import 'package:git_repo_search/presentation/search_repo/widgets/search_bar.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class RepoSearchPage extends StatefulWidget implements AutoRouteWrapper {
  const RepoSearchPage({super.key});

  @override
  RepoSearchPageState createState() => RepoSearchPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchRepoBloc(
        fetchRepositoriesBySearch: locator<FetchRepositoriesBySearch>(),
      ),
      child: this,
    );
  }
}

class RepoSearchPageState extends State<RepoSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.shouldFetch) {
      final bloc = context.read<SearchRepoBloc>();
      bloc.add(
        FetchRepositories(
          searchQuery: _searchController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SearchRepoBloc>().add(
              FetchRepositories(
                searchQuery: _searchController.text,
                isRefresh: true,
              ),
            );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'GitHub Repo Search',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarWidget(
                searchController: _searchController,
                onSearch: (query) {
                  context.read<SearchRepoBloc>().add(
                        FetchRepositories(
                          searchQuery: query,
                        ),
                      );
                },
                onClear: () {
                  context.read<SearchRepoBloc>().add(
                        FetchRepositories(
                          searchQuery: '',
                        ),
                      );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchRepoBloc, SearchRepoState>(
                builder: (buildContext, state) {
                  switch (state) {
                    case SearchRepoInitial _:
                      return const SizedBox();
                    case SearchRepoLoading _:
                      return ListView.builder(
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return const ShimmerRepoCard();
                        },
                      );
                    case SearchRepoLoaded _:
                      final isLoadingMore = state is SearchRepoLoadingMore;
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: state.repositories.length +
                            (isLoadingMore ? 20 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.repositories.length) {
                            return const ShimmerRepoCard();
                          }
                          final repo = state.repositories[index];
                          return RepoCard(
                            onTap: () {
                              if (repo.openIssuesCount == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('No open issues for this repo'),
                                  ),
                                );
                              } else {
                                context.router.push(
                                  SearchDetailRoute(
                                    ownerName: repo.ownerName,
                                    repoName: repo.name,
                                  ),
                                );
                              }
                            },
                            key: ValueKey(repo.id),
                            id: index,
                            name: repo.name,
                            fullName: repo.fullName,
                            ownerName: repo.ownerName,
                            ownerAvatarUrl: repo.ownerAvatarUrl,
                            description: repo.description,
                            size: repo.size,
                            stargazersCount: repo.stargazersCount,
                            forksCount: repo.forksCount,
                            license: repo.license,
                            openIssuesCount: repo.openIssuesCount,
                          );
                        },
                      );
                    case SearchError _:
                      return Center(
                        child: Text(state.message),
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RepoCard extends StatelessWidget {
  const RepoCard({
    required Key super.key,
    required this.id,
    required this.name,
    required this.fullName,
    required this.ownerName,
    required this.ownerAvatarUrl,
    this.description,
    required this.size,
    required this.stargazersCount,
    required this.forksCount,
    this.license,
    required this.openIssuesCount,
    required this.onTap,
  });
  final int id;
  final String name;
  final String fullName;
  final String ownerName;
  final String ownerAvatarUrl;
  final String? description;
  final int size;
  final int stargazersCount;
  final int forksCount;
  final String? license;
  final int openIssuesCount;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: ColorConstants.grey900,
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(ownerAvatarUrl),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            fullName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleConstants.bodyMedium,
                          ),
                        ),
                        Text(
                          'By $ownerName',
                          style: TextStyleConstants.bodyNormal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (description != null && description!.isNotEmpty) ...[
                Text(
                  description!,
                  style: TextStyleConstants.bodyNormal,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _InfoRow(
                      icon: Icons.star,
                      value: stargazersCount.toString(),
                      color: ColorConstants.yellow600,
                    ),
                  ),
                  Flexible(
                    child: _InfoRow(
                      mainAxisAlignment: MainAxisAlignment.center,
                      icon: Icons.fork_right,
                      value: forksCount.toString(),
                      color: ColorConstants.blue600,
                    ),
                  ),
                  Flexible(
                    child: _InfoRow(
                      mainAxisAlignment: MainAxisAlignment.end,
                      icon: Icons.bug_report,
                      value: openIssuesCount.toString(),
                      color: ColorConstants.red600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: _InfoRow(
                        icon: Icons.memory,
                        value: size.toFileSizeFromKB(),
                      ),
                    ),
                    Flexible(
                      child: _InfoRow(
                        mainAxisAlignment: MainAxisAlignment.end,
                        icon: Icons.balance,
                        value: license ?? 'No License',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.value,
    this.color = ColorConstants.grey100,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });
  final IconData icon;
  final String value;
  final Color color;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyleConstants.bodyNormal.copyWith(
              color: ColorConstants.grey100,
            ),
          ),
        ),
      ],
    );
  }
}

class ShimmerRepoCard extends StatelessWidget {
  const ShimmerRepoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConstants.grey900,
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: ColorConstants.grey800,
        highlightColor: ColorConstants.grey700,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: ColorConstants.grey800,
                    radius: 25,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: ColorConstants.grey800,
                        width: 150,
                        height: 20,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        color: ColorConstants.grey800,
                        width: 100,
                        height: 15,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                color: ColorConstants.grey800,
                width: double.infinity,
                height: 20,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ShimmerInfoRow(),
                  _ShimmerInfoRow(),
                  _ShimmerInfoRow(),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ShimmerInfoRow(),
                  _ShimmerInfoRow(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: ColorConstants.grey800,
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 5),
        Container(
          color: ColorConstants.grey800,
          width: 50,
          height: 15,
        ),
      ],
    );
  }
}

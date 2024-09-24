import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_repo_search/core/constants/style_constants.dart';
import 'package:git_repo_search/core/utils/extensions.dart';
import 'package:git_repo_search/core/utils/locator.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/domain/usecases/fetch_issues_by_repo.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_bloc.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_event.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_state.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class SearchDetailPage extends StatefulWidget implements AutoRouteWrapper {
  const SearchDetailPage({
    required this.ownerName,
    required this.repoName,
    super.key,
  });
  final String ownerName;
  final String repoName;

  @override
  // ignore: library_private_types_in_public_api
  _SearchDetailPageState createState() => _SearchDetailPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchDetailBloc(
        fetchIssuesByRepo: locator<FetchIssuesByRepo>(),
      ),
      child: this,
    );
  }
}

class _SearchDetailPageState extends State<SearchDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchDetailBloc>().add(
            FetchIssuesEvent(
              ownerName: widget.ownerName,
              repoName: widget.repoName,
            ),
          );
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bloc = context.read<SearchDetailBloc>();
    if (_scrollController.shouldFetch) {
      bloc.add(
        FetchIssuesEvent(
          ownerName: widget.ownerName,
          repoName: widget.repoName,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SearchDetailBloc>().add(
              FetchIssuesEvent(
                ownerName: widget.ownerName,
                repoName: widget.repoName,
                isRefresh: true,
              ),
            );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Open Issues',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: BlocBuilder<SearchDetailBloc, SearchDetailState>(
          builder: (context, state) {
            switch (state) {
              case SearchDetailInitial _:
                return ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return const ShimmerIssueCard();
                  },
                );
              case SearchDetailLoaded _:
                final isLoadingMore = state is SearchDetailLoadingMore;
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: state.issues.length + (isLoadingMore ? 20 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.issues.length) {
                      return const ShimmerIssueCard();
                    }
                    final issue = state.issues[index];
                    return IssueCard(issue: issue);
                  },
                );
              case SearchDetailError _:
                return Center(
                  child: Text(state.message),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  const IssueCard({super.key, required this.issue});
  final GithubIssue issue;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${issue.number} - ${issue.title}',
              style: TextStyleConstants.largeBold,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
            const SizedBox(height: 8.0),
            Text(
              DateFormat.yMMMd().format(issue.createdAt),
              style: TextStyleConstants.smNormal,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opened by ${issue.user}',
                  style: TextStyleConstants.bodyNormal.copyWith(
                    color: ColorConstants.grey100,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.comment,
                      size: 16,
                      color: ColorConstants.grey100,
                    ),
                    const SizedBox(width: 4),
                    Text('${issue.comments}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerIssueCard extends StatelessWidget {
  const ShimmerIssueCard({super.key});

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
              Container(
                width: double.infinity,
                height: 20.0,
                color: ColorConstants.grey800,
              ),
              const SizedBox(height: 10),
              Container(
                width: 150,
                height: 18.0,
                color: ColorConstants.grey800,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 120,
                    height: 16.0,
                    color: ColorConstants.grey800,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 16.0,
                        height: 16.0,
                        color: ColorConstants.grey800,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 30.0,
                        height: 16.0,
                        color: ColorConstants.grey800,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

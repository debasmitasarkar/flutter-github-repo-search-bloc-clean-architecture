import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/core/router/app_router.gr.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_bloc.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_event.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_state.dart';
import 'package:git_repo_search/presentation/search_repo/repo_search_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockSearchRepoBloc extends MockBloc<SearchRepoEvent, SearchRepoState>
    implements SearchRepoBloc {}

class FakeSearchRepoEvent extends Fake implements SearchRepoEvent {}

class FakeSearchRepoState extends Fake implements SearchRepoState {}

class FakePageRouteInfo extends Fake implements PageRouteInfo {}

class MockStackRouter extends Mock implements StackRouter {}

void main() {
  late MockSearchRepoBloc mockSearchRepoBloc;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeSearchRepoEvent());
    registerFallbackValue(FakeSearchRepoState());
    registerFallbackValue(FakePageRouteInfo());
  });

  setUp(() {
    mockSearchRepoBloc = MockSearchRepoBloc();
  });

  tearDown(() {
    mockSearchRepoBloc.close();
  });

  final testRepositories = [
    const GithubRepository(
      id: 1,
      name: 'Test Repo 1',
      fullName: 'Test/Repo1',
      ownerName: 'TestUser',
      ownerAvatarUrl: 'https://example.com/avatar.png',
      description: 'Test repository description',
      size: 1000,
      stargazersCount: 100,
      forksCount: 10,
      license: 'MIT',
      openIssuesCount: 5,
    ),
  ];

  Future<void> buildTestableWidget(WidgetTester tester, Widget child) async {
    return mockNetworkImagesFor(
      () => tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SearchRepoBloc>(
            create: (context) => mockSearchRepoBloc,
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('displays loading shimmer when in SearchRepoLoading state',
      (WidgetTester tester) async {
    when(() => mockSearchRepoBloc.state).thenReturn(SearchRepoLoading());

    await buildTestableWidget(tester, const RepoSearchPage());

    expect(find.byType(ShimmerRepoCard), findsWidgets);
  });

  testWidgets('displays repository list when in SearchRepoLoaded state',
      (WidgetTester tester) async {
    when(() => mockSearchRepoBloc.state)
        .thenReturn(SearchRepoLoaded(repositories: testRepositories));

    await buildTestableWidget(tester, const RepoSearchPage());

    await tester.pumpAndSettle();

    expect(find.byType(RepoCard), findsOneWidget);
  });

  testWidgets('displays error message when in SearchError state',
      (WidgetTester tester) async {
    when(() => mockSearchRepoBloc.state)
        .thenReturn(SearchError(message: 'Something went wrong'));

    await buildTestableWidget(tester, const RepoSearchPage());

    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('calls onSearch when search query is entered',
      (WidgetTester tester) async {
    when(() => mockSearchRepoBloc.state).thenReturn(SearchRepoInitial());

    await buildTestableWidget(tester, const RepoSearchPage());

    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pump();

    verify(
      () => mockSearchRepoBloc.add(FetchRepositories(searchQuery: 'flutter')),
    ).called(1);
  });

  testWidgets('calls onRefresh when pull to refresh is triggered',
      (WidgetTester tester) async {
    when(() => mockSearchRepoBloc.state)
        .thenReturn(SearchRepoLoaded(repositories: testRepositories));

    when(() => mockSearchRepoBloc.add(any())).thenReturn(null);

    await buildTestableWidget(tester, const RepoSearchPage());

    // Simulate pull to refresh
    await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
    await tester.pumpAndSettle();

    verify(
      () => mockSearchRepoBloc.add(
        FetchRepositories(searchQuery: '', isRefresh: true),
      ),
    ).called(1);
  });

  testWidgets('fetches more repositories when scrolled to the bottom',
      (WidgetTester tester) async {
    final testRepositories = List.generate(
      20,
      (index) => GithubRepository(
        id: index,
        name: 'Repo $index',
        fullName: 'Full/Repo$index',
        ownerName: 'Owner $index',
        ownerAvatarUrl: 'https://example.com/avatar$index.png',
        description: 'Description of Repo $index',
        size: 1000,
        stargazersCount: 100,
        forksCount: 10,
        license: 'MIT',
        openIssuesCount: 5,
      ),
    );

    when(() => mockSearchRepoBloc.state)
        .thenReturn(SearchRepoLoaded(repositories: testRepositories));

    await buildTestableWidget(tester, const RepoSearchPage());

    await tester.drag(find.byType(ListView), const Offset(0, -2400));
    await tester.pumpAndSettle();

    verify(
      () => mockSearchRepoBloc.add(
        FetchRepositories(searchQuery: ''),
      ),
    ).called(1);
  });

  testWidgets('navigates to detail page when repo with open issues is tapped',
      (WidgetTester tester) async {
    final appRouter = MockStackRouter();

    final testRepositories = [
      const GithubRepository(
        id: 1,
        name: 'Test Repo 1',
        fullName: 'Test/Repo1',
        ownerName: 'TestUser',
        ownerAvatarUrl: 'https://example.com/avatar.png',
        description: 'Test repository description',
        size: 1000,
        stargazersCount: 100,
        forksCount: 10,
        license: 'MIT',
        openIssuesCount: 5,
      ),
    ];

    when(() => mockSearchRepoBloc.state)
        .thenReturn(SearchRepoLoaded(repositories: testRepositories));
    when(() => appRouter.push(any())).thenAnswer((_) async => true);

    await buildTestableWidget(
      tester,
      StackRouterScope(
        controller: appRouter,
        stateHash: 0,
        child: const RepoSearchPage(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(RepoCard).first);
    await tester.pumpAndSettle();

    verify(
      () => appRouter.push(
        SearchDetailRoute(
          ownerName: 'TestUser',
          repoName: 'Test Repo 1',
        ),
      ),
    ).called(1);
  });

  testWidgets('clears search query when clear button is pressed',
      (WidgetTester tester) async {
    when(() => mockSearchRepoBloc.state).thenReturn(SearchRepoInitial());

    await buildTestableWidget(tester, const RepoSearchPage());

    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pump();

    expect(find.text('flutter'), findsOneWidget);

    // Simulate clearing the search query
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    // Verify the search query is cleared
    expect(find.text('flutter'), findsNothing);
    verify(
      () => mockSearchRepoBloc.add(FetchRepositories(searchQuery: '')),
    ).called(1);
  });

  testWidgets('shows error snackbar when no open issues',
      (WidgetTester tester) async {
    final testRepositories = [
      const GithubRepository(
        id: 1,
        name: 'Test Repo 1',
        fullName: 'Test/Repo1',
        ownerName: 'TestUser',
        ownerAvatarUrl: 'https://example.com/avatar.png',
        description: 'Test repository description',
        size: 10000000,
        stargazersCount: 100,
        forksCount: 10,
        license: 'MIT',
        openIssuesCount: 0, // No open issues
      ),
    ];

    when(() => mockSearchRepoBloc.state)
        .thenReturn(SearchRepoLoaded(repositories: testRepositories));

    await buildTestableWidget(tester, const RepoSearchPage());

    await tester.pumpAndSettle();

    // Tap the repo card
    await tester.tap(find.byType(RepoCard).first);
    await tester.pumpAndSettle();

    // Check if the snackbar is displayed
    expect(find.text('No open issues for this repo'), findsOneWidget);
  });
}

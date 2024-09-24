import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:git_repo_search/domain/entities/github_repository.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_bloc.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_event.dart';
import 'package:git_repo_search/presentation/search_repo/bloc/search_repo_state.dart';
import 'package:git_repo_search/presentation/search_repo/repo_search_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_image_mock/network_image_mock.dart';

class MockSearchRepoBloc extends MockBloc<SearchRepoEvent, SearchRepoState>
    implements SearchRepoBloc {}

class FakeSearchRepoEvent extends Fake implements SearchRepoEvent {}

class FakeSearchRepoState extends Fake implements SearchRepoState {}

void main() {
  late MockSearchRepoBloc mockSearchRepoBloc;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(FakeSearchRepoEvent());
    registerFallbackValue(FakeSearchRepoState());
  });

  setUp(() {
    mockSearchRepoBloc = MockSearchRepoBloc();
  });

  tearDown(() {
    mockSearchRepoBloc.close();
  });

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

    verify(() =>
            mockSearchRepoBloc.add(FetchRepositories(searchQuery: 'flutter')))
        .called(1);
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_repo_search/domain/entities/github_issue.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_bloc.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_event.dart';
import 'package:git_repo_search/presentation/search_repo_detail/bloc/search_detail_state.dart';
import 'package:git_repo_search/presentation/search_repo_detail/search_detail_page.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchDetailBloc
    extends MockBloc<SearchDetailEvent, SearchDetailState>
    implements SearchDetailBloc {}

class FakeSearchDetailEvent extends Fake implements SearchDetailEvent {}

class FakeSearchDetailState extends Fake implements SearchDetailState {}

void main() {
  late SearchDetailBloc mockSearchDetailBloc;

  final tIssues = [
    GithubIssue(
      id: 1,
      title: 'Test Issue 1',
      number: 101,
      user: 'user1',
      comments: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    GithubIssue(
      id: 2,
      title: 'Test Issue 2',
      number: 102,
      user: 'user2',
      comments: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeSearchDetailEvent());
    registerFallbackValue(FakeSearchDetailState());
  });

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockSearchDetailBloc = MockSearchDetailBloc();
  });

  tearDown(() {
    mockSearchDetailBloc.close();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => mockSearchDetailBloc,
        child: const SearchDetailPage(
          ownerName: 'testOwner',
          repoName: 'testRepo',
        ),
      ),
    );
  }

  testWidgets('shows loading indicator while loading',
      (WidgetTester tester) async {
    when(() => mockSearchDetailBloc.state).thenReturn(SearchDetailInitial());
    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(ShimmerIssueCard), findsWidgets);
  });

  testWidgets('displays issues when data is loaded',
      (WidgetTester tester) async {
    when(() => mockSearchDetailBloc.state)
        .thenReturn(SearchDetailLoaded(issues: tIssues));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(IssueCard), findsNWidgets(2));
  });

  testWidgets('shows error message when there is an error',
      (WidgetTester tester) async {
    when(() => mockSearchDetailBloc.state)
        .thenReturn(SearchDetailError(message: 'Server Error'));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Server Error'), findsOneWidget);
  });

  testWidgets('fetches more repositories when scrolled to the bottom',
      (WidgetTester tester) async {
    final tIssues = List.generate(
      20,
      (index) => GithubIssue(
        id: index,
        title: 'Test Issue $index',
        number: index,
        comments: index,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        user: 'user$index',
      ),
    );

    when(() => mockSearchDetailBloc.state)
        .thenReturn(SearchDetailLoaded(issues: tIssues));

    await tester.pumpWidget(buildTestableWidget());

    await tester.drag(find.byType(ListView), const Offset(0, -2400));
    await tester.pumpAndSettle();

    verify(
      () => mockSearchDetailBloc.add(
        FetchIssuesEvent(
          ownerName: 'testOwner',
          repoName: 'testRepo',
        ),
      ),
    ).called(2);
  });

  testWidgets('calls onRefresh when pull to refresh is triggered',
      (WidgetTester tester) async {
    final tIssues = List.generate(
      20,
      (index) => GithubIssue(
        id: index,
        title: 'Test Issue $index',
        number: index,
        comments: index,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        user: 'user$index',
      ),
    );

    when(() => mockSearchDetailBloc.state)
        .thenReturn(SearchDetailLoaded(issues: tIssues));

    await tester.pumpWidget(buildTestableWidget());

    await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
    await tester.pumpAndSettle();

    verify(
      () => mockSearchDetailBloc.add(
        FetchIssuesEvent(
          ownerName: 'testOwner',
          repoName: 'testRepo',
          isRefresh: true,
        ),
      ),
    ).called(1);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_repo_search/core/constants/style_constants.dart';
import 'package:git_repo_search/core/router/app_router.dart';
import 'package:git_repo_search/core/utils/locator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    setUpLocator();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Github Repo Search',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorConstants.black100,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: ColorConstants.black100,
          ),
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: ColorConstants.blue800,
        highlightColor: ColorConstants.blue600,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      routerConfig: _appRouter.config(),
    );
  }
}

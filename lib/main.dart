import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
        )),
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.blue[800],
        highlightColor: Colors.blue[600],
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headlineMedium:
              TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      routerConfig: _appRouter.config(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_news/ui/screens/feed_content_screen.dart';
import 'package:web_news/ui/screens/home_screen.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Web News',
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 3, 66, 31),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
    );
  }

  final _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: HomeScreen.routeName,
        path: '/',
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            name: FeedContentScreen.routeName,
            path: 'feed_content/:feedTitle/:feedUrl/:feedLength',
            builder: (context, state) {
              final String? feedTitle = state.pathParameters['feedTitle'];
              final String? feedUrl = state.pathParameters['feedUrl'];
              final String? feedLength = state.pathParameters['feedLength'];
              return FeedContentScreen(
                feedTitle: feedTitle!,
                feedUrl: feedUrl!,
                feedLength: feedLength!,
              );
            },
          ),
        ],
      ),
    ],
  );
}

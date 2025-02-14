import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:web_news/ui/screens/feed_content_screen.dart';
import 'package:web_news/ui/screens/home_screen.dart';
import 'package:web_news/utils/constants.dart';

void main() {
  if (Platform.isLinux) {
    WidgetsFlutterBinding.ensureInitialized();

    // set window size to (0, 0) initially, to hide any flickering
    appWindow.size = const Size(0, 0);

    // initialize application
    Display? primaryDisplay;
    Offset? primaryDisplayPosition;
    double primaryDisplayWidth;
    double primaryDisplayHeight;
    Offset windowOffset;
    
    void initializeApplication() async {
      // get primary display details
      primaryDisplay = await screenRetriever.getPrimaryDisplay();
      primaryDisplayPosition = primaryDisplay?.visiblePosition;
      primaryDisplayWidth = primaryDisplay!.size.width;
      primaryDisplayHeight = primaryDisplay!.size.height;

      // calculate window position
      windowOffset = Offset(
        primaryDisplayPosition!.dx + ((primaryDisplayWidth - windowWidth) / 2),
        primaryDisplayPosition!.dy + ((primaryDisplayHeight - windowHeight) / 2)
      );

      // run the app
      runApp(TheApp());

      // do window management
      doWhenWindowReady(() {
        const initialSize = Size(windowWidth, windowHeight);
        appWindow.minSize = initialSize;
        appWindow.position = windowOffset;
        appWindow.size = initialSize;
        appWindow.title = appName;
        appWindow.show();
      });
    }
    initializeApplication();
  } else {
    runApp(TheApp());
  }
}

class TheApp extends StatelessWidget {
  TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          // old color below (using tertiaryContainer / onTertiaryContainer was best)
          // seedColor: const Color.fromARGB(255, 3, 66, 31),
          seedColor: const Color.fromARGB(255, 9, 127, 115),
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
            path: 'feed_content/:feedTitle/:feedUrl',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: FeedContentScreen(
                  feedTitle: state.pathParameters['feedTitle']!,
                  feedUrl: state.pathParameters['feedUrl']!,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // Slide from right
                  const end = Offset.zero;
                  const curve = Curves.fastOutSlowIn;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
  );
}

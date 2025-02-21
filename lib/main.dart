import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:web_news/providers/global_state_provider.dart';
import 'package:web_news/providers/theme_provider.dart';
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
      runApp(
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: TheApp(),
        ),
      );

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
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GlobalStateProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: TheApp(),
      ),
    );
  }
}

class TheApp extends StatelessWidget {
  TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: appName,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 9, 127, 115), // turquiose
          // seedColor: const Color.fromARGB(255, 44, 19, 88), // purple 1
          // seedColor: const Color.fromARGB(255, 5, 0, 12), // purple 2
          // seedColor: const Color.fromARGB(255, 231, 137, 30), // orange
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 9, 127, 115), // turquiose
          // seedColor: const Color.fromARGB(255, 44, 19, 88), // purple 1
          // seedColor: const Color.fromARGB(255, 5, 0, 12), // purple 2
          // seedColor: const Color.fromARGB(255, 231, 137, 30), // orange
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
            path: 'feed_content/:feedTitle/:feedUrl/:feedContentElement',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: FeedContentScreen(
                  feedTitle: state.pathParameters['feedTitle']!,
                  feedUrl: state.pathParameters['feedUrl']!,
                  feedContentElement: state.pathParameters['feedContentElement']!,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
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
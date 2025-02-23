import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:web_news/providers/global_state_provider.dart';
import 'package:web_news/providers/theme_provider.dart';
import 'package:web_news/ui/screens/home_screen.dart';
import 'package:web_news/ui/screens/pageview_screen.dart';
import 'package:web_news/ui/theme/colors.dart';
import 'package:web_news/ui/theme/typography.dart';
import 'package:web_news/utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) {
    initializeLinuxApplication();
  } else {
    runRunApp();
  }
}

void initializeLinuxApplication() async {
  // Set initial window size to (0, 0) to avoid flickering
  appWindow.size = const Size(0, 0);

  // Get primary display details
  Display? primaryDisplay = await screenRetriever.getPrimaryDisplay();
  Offset? primaryDisplayPosition = primaryDisplay.visiblePosition;
  double primaryDisplayWidth = primaryDisplay.size.width;
  double primaryDisplayHeight = primaryDisplay.size.height;

  // Calculate window position
  Offset windowOffset = Offset(
    primaryDisplayPosition!.dx + ((primaryDisplayWidth - windowWidth) / 2),
    primaryDisplayPosition.dy + ((primaryDisplayHeight - windowHeight) / 2),
    // 5500, 200 // for testing
  );

  // initialize the app
  runRunApp(windowOffset);
}

void runRunApp([Offset? windowOffset]) {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalStateProvider()),
        ChangeNotifierProvider(
          create: (context) {
            TextTheme textTheme = createTextTheme(context, 'Source Sans 3', 'Source Sans 3');
            MaterialTheme materialTheme = MaterialTheme(textTheme);
            ThemeProvider themeProvider = ThemeProvider(materialTheme);
            return themeProvider;
          },
        ),
      ],
      child: TheApp(),
    ),
  );

  if (windowOffset != null) {
    doWhenWindowReady(() {
      const initialSize = Size(windowWidth, windowHeight);
      appWindow.minSize = initialSize;
      appWindow.position = windowOffset;
      appWindow.size = initialSize;
      appWindow.title = appName;
      appWindow.show();
    });
  }
}

class TheApp extends StatelessWidget {
  TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final materialTheme = themeProvider.materialTheme;
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: appName,
      theme: themeProvider.themeMode == ThemeMode.light
        ? materialTheme.light()
        : materialTheme.dark(),
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
            name: PageViewScreen.routeName,
            path: 'pageview/:feedIndex',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: PageViewScreen(
                  feedIndex: state.pathParameters['feedIndex']!,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, -1.0);
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
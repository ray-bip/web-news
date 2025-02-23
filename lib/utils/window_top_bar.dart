import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_news/providers/global_state_provider.dart';
import 'package:web_news/providers/theme_provider.dart';
import 'package:web_news/utils/helper_functions.dart';

class WindowTopBar extends StatelessWidget {
  final String currentRoute;
  final String windowTitle;
  
  const WindowTopBar({
    super.key,
    required this.currentRoute,
    required this.windowTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Container(
        color: isDarkMode(context)
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.surface,
        child: WindowTitleBarBox(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Text(
                  windowTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                children: [
                  if (currentRoute != 'home')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          context.read<GlobalStateProvider>().updateActiveTileIndex(null);
                          if (context.read<GlobalStateProvider>().isScrollingAllowed == false) {
                            context.read<GlobalStateProvider>().toggleIsScrollingAllowed();
                          }
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.home, size: 24,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        hoverColor:
                          Theme.of(context).colorScheme.onSurface.withAlpha(32),
                      ),
                    ],
                  ),
                  Expanded(
                    child: MoveWindow(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          context.read<ThemeProvider>().themeMode == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        ),
                        onPressed: () {
                          context.read<ThemeProvider>().toggleTheme();
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          appWindow.close();
                        },
                        hoverColor: Colors.transparent,
                        icon: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: InkWell(
                            onTap: () {
                              appWindow.close();
                            },
                            borderRadius: BorderRadius.circular(0),
                            hoverColor: const Color.fromARGB(255, 201, 7, 7),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
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
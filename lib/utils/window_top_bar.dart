import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:web_news/utils/constants.dart';

class WindowTopBar extends StatelessWidget {
  final String currentRoute;
  
  const WindowTopBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: WindowTitleBarBox(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Text(
                  appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(175),
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
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, size: 24)
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
                        onPressed: appWindow.close,
                        icon: const Icon(Icons.close),
                        hoverColor: const Color.fromARGB(255, 201, 7, 7),
                      ),
                      // CloseWindowButton(
                      //   colors: WindowButtonColors(
                      //     iconNormal: Theme.of(context).colorScheme.onSurface.withAlpha(175),
                      //     mouseOver: const Color.fromARGB(255, 201, 7, 7)
                      //   ),
                      // ),
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
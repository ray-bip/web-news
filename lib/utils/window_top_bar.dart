import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowTopBar extends StatelessWidget {
  final String currentRoute;
  final String windowTitle;
  final VoidCallback? refreshPage;
  
  const WindowTopBar({
    super.key,
    required this.currentRoute,
    required this.windowTitle,
    this.refreshPage,
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
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back, size: 24,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        hoverColor:
                          Theme.of(context).colorScheme.onSurface.withAlpha(32),
                      ),
                      IconButton(
                        onPressed: refreshPage,
                        icon: Icon(
                          Icons.refresh, size: 24,
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
                              print('click!');
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
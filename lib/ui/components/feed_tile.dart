import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_news/ui/screens/feed_content_screen.dart';
import 'package:web_news/utils/helper_functions.dart';

class FeedTile extends StatefulWidget {
  final String feedTitle;
  final String feedUrl;
  final String feedContentElement;

  const FeedTile({
    super.key,
    required this.feedTitle,
    required this.feedUrl,
    required this.feedContentElement,
  });

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  bool _tileIsActive = false;
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    router = GoRouter.of(context);
    router.routerDelegate.addListener(_onRouteChange);
  }

  @override
  void dispose() {
    router.routerDelegate.removeListener(_onRouteChange);
    super.dispose();
  }

  void _onRouteChange() {
    final currentRoute = router.routerDelegate.currentConfiguration.uri.toString();
    if (currentRoute == '/') {
      setState(() {
        _tileIsActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void goToFeedContentScreen() {
      setState(() {
        _tileIsActive = true;
      });

      context.goNamed(
        FeedContentScreen.routeName,
        pathParameters: {
          'feedTitle': widget.feedTitle,
          'feedUrl': widget.feedUrl,
          'feedContentElement': widget.feedContentElement,
        },
      );
    }
    
    return Material(
      child: AnimatedContainer(
        duration: _tileIsActive
          ? const Duration(milliseconds: 0)
          : const Duration(milliseconds: 2400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode(context)
              ? [
                _tileIsActive
                  ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(128)
                  : Theme.of(context).colorScheme.primaryContainer.withAlpha(192),
                _tileIsActive
                  ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(192)
                  : Theme.of(context).colorScheme.primaryContainer,
              ]
              : [
                _tileIsActive
                  ? Theme.of(context).colorScheme.tertiaryContainer
                  : Theme.of(context).colorScheme.primaryContainer.withAlpha(64),
                _tileIsActive
                  ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(160)
                  : Theme.of(context).colorScheme.primaryContainer.withAlpha(96),
              ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: goToFeedContentScreen,
          splashColor: Colors.transparent,
          hoverColor: isDarkMode(context)
            ? Colors.white.withAlpha(64)
            : Colors.black.withAlpha(16),
          leading: Platform.isLinux
          ? IconButton(
            onPressed: () {
              openBrowser(widget.feedUrl);
            },
            icon: Icon(
              Icons.rss_feed,
              color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
            ),
          )
          : Icon(
            Icons.rss_feed,
            color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
          ),
          title: Text(
            widget.feedTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}

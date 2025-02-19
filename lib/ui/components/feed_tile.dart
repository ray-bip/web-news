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

  @override
  Widget build(BuildContext context) {
    void goToFeedContentScreen() {
      setState(() {
        _tileIsActive = !_tileIsActive;
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
          : const Duration(milliseconds: 1600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode(context)
            ? [
              Theme.of(context).colorScheme.primaryContainer.withAlpha(160),
              Theme.of(context).colorScheme.primaryContainer.withAlpha(255),
            ]
            : [
              Theme.of(context).colorScheme.primaryContainer.withAlpha(80),
              Theme.of(context).colorScheme.primaryContainer.withAlpha(64),
            ],
            // colors: isDarkMode(context)
            //   ? [
            //     _tileIsActive
            //     ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(128)
            //     : Theme.of(context).colorScheme.primaryContainer.withAlpha(160),
            //     _tileIsActive
            //     ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(192)
            //     : Theme.of(context).colorScheme.primaryContainer,
            //   ]
            //   : [
            //     _tileIsActive
            //     ? Theme.of(context).colorScheme.secondaryContainer
            //     : Theme.of(context).colorScheme.surfaceTint.withAlpha(96),
            //     _tileIsActive
            //     ? Theme.of(context).colorScheme.secondaryContainer.withAlpha(192)
            //     : Theme.of(context).colorScheme.surfaceTint.withAlpha(80),
            //   ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: goToFeedContentScreen,
          splashColor: Colors.transparent,
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

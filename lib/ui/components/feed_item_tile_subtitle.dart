import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:web_news/ui/screens/full_article_screen.dart';
import 'package:web_news/utils/helper_functions.dart';

class FeedItemTileSubtitle extends StatelessWidget {
  final String feedItemDate;
  final String feedItemLink;
  final bool tileIsActive;

  const FeedItemTileSubtitle({
    super.key,
    required this.feedItemDate,
    required this.feedItemLink,
    required this.tileIsActive,
  });

  @override
  Widget build(BuildContext context) {
    void goToFullArticleScreen() {
      final String feedTitle = GoRouterState.of(context).pathParameters['feedTitle'].toString();
      final String feedUrl = GoRouterState.of(context).pathParameters['feedUrl'].toString();
      final String feedContentElement = GoRouterState.of(context).pathParameters['feedContentElement'].toString();

      context.goNamed(
        FullArticleScreen.routeName,
        // it only works when all pathParameters are provided
        // but this might not be necessary, since we're only extending the route
        // TODO: find out if existing path parameters can be left out
        pathParameters: {
          'pageUrl': feedItemLink,
          'feedTitle': feedTitle,
          'feedUrl': feedUrl,
          'feedContentElement': feedContentElement,
        },
      );
    }

    return Padding(
      padding: Platform.isLinux
        ? const EdgeInsets.fromLTRB(8, 12, 0 ,0) : const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              feedItemDate,
              softWrap: false,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: tileIsActive
                  ? Theme.of(context).colorScheme.onTertiaryContainer.withAlpha(128)
                  : Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
                fontSize: Platform.isLinux ? 12 : 11,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Share.share(feedItemLink);
                },
                icon: Icon(
                  Icons.share,
                  size: Platform.isLinux ? 24 : 18,
                  color: tileIsActive
                    ? Theme.of(context).colorScheme.onTertiaryContainer.withAlpha(128)
                    : Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
                ),
                visualDensity: Platform.isLinux
                  ? VisualDensity.comfortable
                  : VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  openBrowser(feedItemLink);
                },
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: feedItemLink));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied!')),
                  );
                },
                icon: Icon(
                  Icons.open_in_new,
                  size: Platform.isLinux ? 24 : 18,
                  color: tileIsActive
                    ? Theme.of(context).colorScheme.onTertiaryContainer.withAlpha(128)
                    : Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
                ),
                visualDensity: Platform.isLinux
                  ? VisualDensity.comfortable
                  : VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: goToFullArticleScreen,
                icon: Icon(
                  Icons.read_more,
                  size: Platform.isLinux ? 32 : 24,
                  color: tileIsActive
                    ? Theme.of(context).colorScheme.onTertiaryContainer.withAlpha(128)
                    : Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
                ),
                visualDensity: Platform.isLinux
                  ? VisualDensity.comfortable
                  : VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
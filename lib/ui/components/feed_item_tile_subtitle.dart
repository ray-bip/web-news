import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
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
            ],
          ),
        ],
      ),
    );
  }
}
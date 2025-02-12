import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_news/ui/screens/feed_content_screen.dart';

class FeedTile extends StatelessWidget {
  final String feedUrl;
  final String feedTitle;

  const FeedTile({
    super.key,
    required this.feedUrl,
    required this.feedTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        onTap: () {
          context.goNamed(
            FeedContentScreen.routeName,
            pathParameters: {
              'feedTitle': feedTitle,
              'feedUrl': feedUrl,
            },
          );
        },
        title: Text(feedTitle),
        trailing: const Icon(Icons.arrow_forward),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
    );
  }
}
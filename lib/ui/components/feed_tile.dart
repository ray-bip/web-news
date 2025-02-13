import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_news/ui/screens/feed_content_screen.dart';

class FeedTile extends StatelessWidget {
  final String feedTitle;
  final String feedUrl;
  final String feedLength;

  const FeedTile({
    super.key,
    required this.feedTitle,
    required this.feedUrl,
    required this.feedLength,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondaryContainer.withAlpha(160),
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            context.goNamed(
              FeedContentScreen.routeName,
              pathParameters: {
                'feedTitle': feedTitle,
                'feedUrl': feedUrl,
                'feedLength': feedLength,
              },
            );
          },
          title: Text(
            feedTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: const Icon(Icons.arrow_forward),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
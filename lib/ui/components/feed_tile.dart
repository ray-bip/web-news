import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_news/ui/screens/feed_content_screen.dart';

class FeedTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    void goToFeedContentScreen() {
      context.goNamed(
        FeedContentScreen.routeName,
        pathParameters: {
          'feedTitle': feedTitle,
          'feedUrl': feedUrl,
          'feedContentElement': feedContentElement,
        },
      );
    }
    
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withAlpha(160),
              Theme.of(context).colorScheme.primaryContainer.withAlpha(255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: goToFeedContentScreen,
          splashColor: Colors.transparent,
          leading: Icon(
            Icons.rss_feed,
            color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
          ),
          title: Text(
            feedTitle,
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_news/ui/screens/feed_content_screen.dart';

class FeedTile extends StatelessWidget {
  final String feedTitle;
  final String feedUrl;

  const FeedTile({
    super.key,
    required this.feedTitle,
    required this.feedUrl,
  });

  @override
  Widget build(BuildContext context) {
    void goToFeedContentScreen() {
      context.goNamed(
        FeedContentScreen.routeName,
        pathParameters: {
          'feedTitle': feedTitle,
          'feedUrl': feedUrl,
        },
      );
    }
    
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiaryContainer.withAlpha(96),
              Theme.of(context).colorScheme.tertiaryContainer.withAlpha(160),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: goToFeedContentScreen,
          title: Text(
            feedTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
          trailing: IconButton(
            onPressed: goToFeedContentScreen,
            icon: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}

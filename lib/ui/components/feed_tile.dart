import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_news/providers/global_state_provider.dart';
import 'package:web_news/ui/components/feed_tile_leading.dart';
import 'package:web_news/ui/screens/pageview_screen.dart';
import 'package:web_news/utils/helper_functions.dart';

class FeedTile extends StatefulWidget {
  final String feedTitle;
  final String feedUrl;
  final String feedContentElement;
  final int feedIndex;

  const FeedTile({
    super.key,
    required this.feedTitle,
    required this.feedUrl,
    required this.feedContentElement,
    required this.feedIndex,
  });

  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  @override
  Widget build(BuildContext context) {
    bool tileIsActive = false;
    if (widget.feedIndex == context.watch<GlobalStateProvider>().activeTileIndex) {
      tileIsActive = true;
    }

    void goToFeedContentScreen() {
      context.goNamed(
        PageViewScreen.routeName,
        pathParameters: {
          'feedIndex': widget.feedIndex.toString(),
        },
      );
    }
    
    return Material(
      child: AnimatedContainer(
        duration: tileIsActive
          ? const Duration(milliseconds: 0)
          : const Duration(milliseconds: 2400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode(context)
              ? [
                tileIsActive
                  ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(128)
                  : Theme.of(context).colorScheme.primaryContainer.withAlpha(192),
                tileIsActive
                  ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(192)
                  : Theme.of(context).colorScheme.primaryContainer,
              ]
              : [
                tileIsActive
                  ? Theme.of(context).colorScheme.tertiaryContainer
                  : Theme.of(context).colorScheme.primaryContainer.withAlpha(64),
                tileIsActive
                  ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(160)
                  : Theme.of(context).colorScheme.primaryContainer.withAlpha(96),
              ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            goToFeedContentScreen();
            context.read<GlobalStateProvider>().updateActiveTileIndex(widget.feedIndex);
          },
          splashColor: Colors.transparent,
          hoverColor: isDarkMode(context)
            ? Colors.white.withAlpha(64)
            : Colors.black.withAlpha(16),
          leading: FeedTileLeading(
            feedUrl: widget.feedUrl,
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.feedTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
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

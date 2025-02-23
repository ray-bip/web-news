import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_news/data/feed.dart';
import 'package:web_news/providers/global_state_provider.dart';
import 'package:web_news/ui/screens/feed_content_screen.dart';
import 'package:web_news/utils/window_top_bar.dart';

class PageViewScreen extends StatefulWidget {
  static const String routeName = 'pageview';
  final String feedIndex;
  
  const PageViewScreen({
    super.key,
    required this.feedIndex,
  });

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late FocusNode _focusNode;
  late int _currentPageIndex = int.parse(widget.feedIndex);
  final List<Feed> feeds = Feed.feeds;
  int get infiniteLength => feeds.length * 100;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(
      initialPage: _currentPageIndex + feeds.length * 50,
    );
    
    _pageViewController.addListener(() {
      int newIndex = _pageViewController.page!.round() % feeds.length;
      if (newIndex != _currentPageIndex) {
        setState(() {
          _currentPageIndex = newIndex;
        });
      }
    });

    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _focusNode.dispose();
  }

  KeyEventResult _onKeyEvent(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent) {
      final logicalKey = keyEvent.logicalKey;
      
      if (logicalKey == LogicalKeyboardKey.escape) {
        Navigator.pop(context);
        return KeyEventResult.handled;
      } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowLeft ||
        logicalKey == LogicalKeyboardKey.keyZ) {
        _pageViewController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return KeyEventResult.handled;
      } else if (logicalKey == LogicalKeyboardKey.arrowRight ||
        logicalKey == LogicalKeyboardKey.keyX) {
        _pageViewController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<GlobalStateProvider>().updateActiveTileIndex(null);
      },
      child: Scaffold(
        appBar: Platform.isAndroid ? AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(feeds[_currentPageIndex].title),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.home),
          ),
        ) : null,
        body: KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          onKeyEvent: _onKeyEvent,
          child: Container(
            decoration: Platform.isLinux ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceBright,
                width: 1.6,
              ),
            ) : null,
            child: Column(
              children: [
                if (Platform.isLinux) WindowTopBar(
                  currentRoute: FeedContentScreen.routeName,
                  windowTitle: feeds[_currentPageIndex].title,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageViewController,
                    physics: Platform.isLinux
                      ? const AlwaysScrollableScrollPhysics()
                      : null,
                    itemCount: infiniteLength,
                    onPageChanged: (index) {
                      final normalizedIndex = index % feeds.length;
                      context.read<GlobalStateProvider>()
                        .updateActiveTileIndex(normalizedIndex);
                      if (Platform.isLinux) {
                        if (context.read<GlobalStateProvider>().isScrollingAllowed == false) {
                          context.read<GlobalStateProvider>().toggleIsScrollingAllowed();
                        }
                      }
                    },
                    itemBuilder: (context, index) {
                      final loopedIndex = index % feeds.length;
                      final feed = feeds[loopedIndex];
                      return FeedContentScreen(
                        feedTitle: feed.title,
                        feedUrl: feed.url,
                        feedContentElement: feed.contentElement,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
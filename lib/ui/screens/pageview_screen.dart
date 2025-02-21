import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_news/data/feed.dart';
import 'package:web_news/ui/screens/feed_content_screen_alt.dart';

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
  late final int _currentPageIndex = int.parse(widget.feedIndex);
  final List<Feed> feeds = Feed.feeds;
  int get infiniteLength => feeds.length * 100;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(
      initialPage: _currentPageIndex + feeds.length * 50,
    );
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
    return Scaffold(
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: _onKeyEvent,
        child: PageView.builder(
          controller: _pageViewController,
          physics: Platform.isLinux
            ? const AlwaysScrollableScrollPhysics()
            : null,
          itemCount: infiniteLength,
          itemBuilder: (context, index) {
            final loopedIndex = index % feeds.length;
            final feed = feeds[loopedIndex];
            return FeedContentScreenAlt(
              feedTitle: feed.title,
              feedUrl: feed.url,
              feedContentElement: feed.contentElement,
            );
          },
        ),
      ),
    );
  }
}
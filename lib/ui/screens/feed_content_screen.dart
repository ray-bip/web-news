import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:web_news/providers/global_state_provider.dart';
import 'package:web_news/ui/components/feed_item.dart';
import 'package:xml2json/xml2json.dart';

class FeedContentScreen extends StatefulWidget {
  static const String routeName = 'feed_content';
  final String feedTitle;
  final String feedUrl;
  final String feedContentElement;

  const FeedContentScreen({
    super.key,
    required this.feedTitle,
    required this.feedUrl,
    required this.feedContentElement
  });

  @override
  State<FeedContentScreen> createState() => _FeedContentScreenState();
}

class _FeedContentScreenState extends State<FeedContentScreen> {
  bool _isLoading = true;
  List feedItems = [];
  late Future<void> feedItemsFuture;
  final Xml2Json xml2json = Xml2Json();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

  // make listview draggable
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _scrollController.jumpTo(
      (_scrollController.offset - details.primaryDelta!).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
    );
  }
  
  late String feedType = '';
  bool _isFetching = false;

  Future<void> getFeedItems({int startIndex = 0, int batchSize = 10}) async {
    if (widget.feedUrl.isEmpty || _isFetching) return;
    _isFetching = true;

    final url = Uri.parse(widget.feedUrl);
    final response = await http.get(url);
    final utf8ResponsBody = utf8.decode(response.bodyBytes);

    xml2json.parse(utf8ResponsBody);
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);

    List newItems = [];

    if (data['rss'] != null) {
      newItems = List.from(data['rss']['channel']['item']);
      feedType = 'rss';
    } else {
      newItems = List.from(data['feed']['entry']);
      feedType = 'feed';
    }

    int remainingItems = newItems.length - startIndex;
    int itemsToTake = remainingItems < batchSize ? remainingItems : batchSize;

    if (itemsToTake > 0) {
      setState(() {
        for (var item in newItems.skip(startIndex).take(itemsToTake)) {
          if (!feedItems.contains(item)) {
            feedItems.add(item);
          }
        }
        _isLoading = false;
      });
    }

    _isFetching = false;
  }

  @override
  void initState() {
    // fetch new feed items when scrolling down
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
          getFeedItems(
            startIndex: feedItems.length,
            batchSize: 10,
          );
      }
    });

    feedItemsFuture = getFeedItems();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(KeyEvent keyEvent) {
    if (keyEvent is KeyDownEvent) {
      final logicalKey = keyEvent.logicalKey;
      
      if (logicalKey == LogicalKeyboardKey.f5) {
        _refreshIndicatorKey.currentState?.show();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _onKeyEvent,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: getFeedItems,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                  child: _isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  )
                  : Stack(
                    children: [
                      ListView.separated(
                        physics: Platform.isLinux
                          ? context.watch<GlobalStateProvider>().isScrollingAllowed
                            ? null
                            : const NeverScrollableScrollPhysics()
                          : null,
                        controller: _scrollController,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 8);
                        },
                        itemCount: feedItems.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == feedItems.length) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ));
                          }
                          
                          return FeedItem(
                            item: feedItems[index],
                            index: index,
                            feedType: feedType,
                            feedContentElement: widget.feedContentElement,
                            onVerticalDragUpdate: _onVerticalDragUpdate,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web_news/ui/components/feed_item.dart';
import 'package:web_news/utils/helper_functions.dart';
import 'package:web_news/utils/window_top_bar.dart';
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
  
  Future<void> getFeedItems({int startIndex = 0, int batchSize = 10}) async {
    if (widget.feedUrl.isEmpty) return;

    final url = Uri.parse(widget.feedUrl);
    final response = await http.get(url);
    final utf8ResponsBody = utf8.decode(response.bodyBytes);

    // xml2json.parse(response.body);
    xml2json.parse(utf8ResponsBody);
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    
    List newItems = [];
    
    if (data['rss'] != null) {
      newItems = data['rss']['channel']['item'];
      feedType = 'rss';
    } else {
      newItems = data['feed']['entry'];
      feedType = 'feed';
    }

    setState(() {
      feedItems.addAll(newItems.skip(startIndex).take(batchSize));
      _isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isAndroid ? AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.feedTitle),
        centerTitle: true,
      ) : null,
      body: Focus(
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.tab) {
            Navigator.pop(context);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.f5) {
            getFeedItems();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: RefreshIndicator(
          onRefresh: getFeedItems,
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
                  windowTitle: widget.feedTitle,
                  refreshPage: getFeedItems,
                ),
                Expanded(
                  child: Container(
                    color: isDarkMode(context)
                      ? Theme.of(context).colorScheme.surfaceContainer
                      : Theme.of(context).colorScheme.surfaceTint.withAlpha(40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                      child: _isLoading
                      ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      )
                      : GestureDetector(
                        onHorizontalDragEnd: (details) {
                          const double swipeThreshold = 640;

                          if (details.primaryVelocity != null 
                            && details.primaryVelocity! > swipeThreshold) {
                            Navigator.pop(context);
                          }
                        },
                        child: Stack(
                          children: [
                            ListView.separated(
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
                                );
                              },
                            ),
                            if (Platform.isLinux)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onVerticalDragUpdate: _onVerticalDragUpdate,
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(8, 6, 0, 0),
                                  height: MediaQuery.of(context).size.height - 90,
                                  width: 90,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
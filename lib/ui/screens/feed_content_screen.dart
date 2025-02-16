import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:web_news/ui/components/feed_item_tile.dart';
import 'package:web_news/utils/helper_functions.dart';
import 'package:web_news/utils/window_top_bar.dart';
import 'package:xml2json/xml2json.dart';

class FeedContentScreen extends StatefulWidget {
  static const String routeName = 'feed_content';
  final String feedTitle;
  final String feedUrl;

  const FeedContentScreen({
    super.key,
    required this.feedTitle,
    required this.feedUrl,
  });

  @override
  State<FeedContentScreen> createState() => _FeedContentScreenState();
}

class _FeedContentScreenState extends State<FeedContentScreen> {
  late Future<void> feedItemsFuture;
  bool isLoading = true;
  final Xml2Json xml2json = Xml2Json();
  List feedItems = [];
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

  Future<void> getFeedItems({int startIndex = 0, int batchSize = 10}) async {
    if (widget.feedUrl.isEmpty) return;

    final url = Uri.parse(widget.feedUrl);
    final response = await http.get(url);

    xml2json.parse(response.body);
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    var newItems = data['rss']['channel']['item'];

    setState(() {
      feedItems.addAll(newItems.skip(startIndex).take(batchSize));
      isLoading = false;
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
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                      child: isLoading
                      ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      )
                      : GestureDetector(
                        // allow swipe to navigate back
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
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
                              itemCount: feedItems.length + (isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == feedItems.length) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                  ));
                                }
                                
                                var item = feedItems[index];

                                // retrieve images (oh, so many ways!)
                                String feedItemImage = '';
                                if (item['enclosure'] != null && item['enclosure']['url'] != null) {
                                  feedItemImage = item['enclosure']['url'].toString();
                                } else if (item['image'] != null && item['image'] != '') {
                                  feedItemImage = item['image']['\$t'];
                                } else if (item['media\$thumbnail'] != null) {
                                  feedItemImage = item['media\$thumbnail']['url'];
                                } else if (item['media\$content'] != null) {
                                  feedItemImage = item['media\$content']['url'];
                                }
                                        
                                // retrieve and sanitize title
                                String feedItemTitle = '';
                                if (item['title'] != null && item['title']?['\$t'] != null) {
                                  feedItemTitle = item['title']['\$t'].toString();
                                } else if (item['title'] != null) {
                                  feedItemTitle = item['title'].toString();
                                }
                            
                                feedItemTitle = sanitizeDirtyString(feedItemTitle);
                                
                                // retrieve and format date
                                String dateString = item['pubDate']['\$t'] ?? '';
                                DateTime parsedDate =
                                  DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(dateString);
                                String feedItemDate =
                                  DateFormat('yyyy/MM/dd - HH:mm').format(parsedDate);
                                        
                                // retrieve and sanitize description
                                String feedItemDescription = '';
                                if (item['description'] != null && item['description']['\$t'] != null) {
                                  feedItemDescription = item['description']['\$t'].toString();
                                } else if (item['description'] != null) {
                                  feedItemDescription = item['description'].toString();
                                }
                                
                                feedItemDescription = sanitizeDirtyString(feedItemDescription);
                                    
                                // retrieve and sanitize the bejesus out of content
                                String feedItemContent = '';
                                if (item['content\$encoded'] != null &&
                                  item['content\$encoded']['\$t'] != null) {
                                  feedItemContent = item['content\$encoded']['\$t'].toString();
                                } else if (item['content\$encoded'] != null) {
                                  feedItemContent = item['content\$encoded'].toString();
                                }
                                
                                feedItemContent = sanitizeDirtyString(feedItemContent);
                            
                                // retrieve link and clean it a bit
                                String feedItemLink = '';
                                if (item['link']['\$t'] != null) {
                                  feedItemLink = item['link']['\$t'].toString();
                                } else {
                                  feedItemLink = item['link'].toString()
                                    .replaceAll('{__cdata: ', '')
                                    .replaceAll('}', '');
                                }
                                            
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                                  child: FeedItemTile(
                                    feedItemImage: feedItemImage,
                                    feedItemTitle: feedItemTitle,
                                    feedItemDate: '[${(index + 1).toString()}] [$feedItemDate]',
                                    feedItemDescription: feedItemDescription,
                                    feedItemContent: feedItemContent,
                                    feedItemLink: feedItemLink,
                                  ),
                                );
                              },
                            ),
                            if (Platform.isLinux)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onVerticalDragUpdate: _onVerticalDragUpdate,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  height: 960,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
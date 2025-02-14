import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:web_news/ui/components/feed_item_tile.dart';
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
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
          getFeedItems(
            startIndex: feedItems.length,
            batchSize: 10
          );
      }
    });

    feedItemsFuture = getFeedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isAndroid ? AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.feedTitle),
        centerTitle: true,
      ) : null,
      body: RefreshIndicator(
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
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 0) {
                          Navigator.pop(context);
                        }
                      },
                      child: ListView.separated(
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
                                      
                          feedItemTitle = HtmlUnescape().convert(feedItemTitle
                              .toString()
                              .replaceAll('{__cdata:', '')
                              .replaceAll('}', '')
                              .trim());
                          
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
                          
                          feedItemDescription = HtmlUnescape().convert(feedItemDescription
                              .toString()
                              .replaceAll('{__cdata:', '')
                              .replaceAll('}', '')
                              // remove complete hyperlinks
                              .replaceAll(RegExp(r'<a href="(.*?)">(.*?)<\/a>'), '')
                              // replace [...] and everything that follows with ...
                              .replaceAll(RegExp(r'\[.*?\].*'), '...')
                              .trim());
                                  
                          // retrieve and sanitize the bejesus out of content
                          String feedItemContent = '';
                          if (item['content\$encoded'] != null &&
                            item['content\$encoded']['\$t'] != null) {
                            feedItemContent = item['content\$encoded']['\$t'].toString();
                          } else if (item['content\$encoded'] != null) {
                            feedItemContent = item['content\$encoded'].toString();
                          }
                          
                          feedItemContent = feedItemContent
                              .toString()
                              .replaceAll('{__cdata:', '')
                              .replaceAll('}', '')
                              .replaceAll('\\\\n', '')
                              // replace [...] and everything that follows with ...
                              .replaceAll(RegExp(r'\[.*?\].*'), '...')
                              // replace <!-- and everything that follows with ...
                              .replaceAll(RegExp(r'<!--[\s\S]*$'), '...')
                              .trim();
                                  
                          // retrieve link
                          String feedItemLink = item['link']?['\$t']?.toString() ?? '';
                                      
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
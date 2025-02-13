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
  final String feedLength;

  const FeedContentScreen({
    super.key,
    required this.feedTitle,
    required this.feedUrl,
    required this.feedLength,
  });

  @override
  State<FeedContentScreen> createState() => _FeedContentScreenState();
}

class _FeedContentScreenState extends State<FeedContentScreen> {
  late Future<void> articlesFuture;
  bool isLoading = true;
  final Xml2Json xml2json = Xml2Json();
  List feedItems = [];

  Future<void> getArticles() async {
    final url = Uri.parse(widget.feedUrl);
    final response = await http.get(url);

    xml2json.parse(response.body);

    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    
    setState(() {
      feedItems = data['rss']['channel']['item'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    articlesFuture = getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isAndroid ? AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.feedTitle),
        centerTitle: true,
      ) : null,
      body: Column(
        children: [
          if (Platform.isLinux) const WindowTopBar(currentRoute: FeedContentScreen.routeName),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  )
                )
                : FutureBuilder(
                  future: articlesFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 8);
                      },
                      itemCount: feedItems.length > int.tryParse(widget.feedLength)!
                        ? int.tryParse(widget.feedLength)!
                        : feedItems.length,
                      itemBuilder: (context, index) {
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
                        String feedItemDate = DateFormat('yyyy/MM/dd - HH:mm').format(parsedDate);
            
                        // retrieve and sanitize the bejesus out of description
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
                            // remove all HTML tags
                            .replaceAll(RegExp(r'</?([a-zA-Z0-9]+)[^>]*>'), '')
                            // replace [...] and everything that follows with ...
                            .replaceAll(RegExp(r'\[.*?\].*'), '...')
                            .trim());
            
                        // retrieve and sanitize the bejesus out of content
                        String feedItemContent = '';
                        if (item['content\$encoded'] != null && item['content\$encoded']['\$t'] != null) {
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
                            feedItemDate: feedItemDate,
                            feedItemDescription: feedItemDescription,
                            feedItemContent: feedItemContent,
                            feedItemLink: feedItemLink,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:web_news/ui/components/feed_item_tile.dart';
import 'package:xml2json/xml2json.dart';

class FeedContentScreen extends StatefulWidget {
  static const String routeName = 'feed_content';
  final String feedTitle;
  final String feedUrl;
  const FeedContentScreen({
    super.key,
    required this.feedUrl,
    required this.feedTitle,
  });

  @override
  State<FeedContentScreen> createState() => _FeedContentScreenState();
}

class _FeedContentScreenState extends State<FeedContentScreen> {
  late Future<void> articlesFuture;
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.feedTitle),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: articlesFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 8);
                },
                itemCount: feedItems.length >= 10 ? 10 : feedItems.length,
                itemBuilder: (context, index) {
                  var item = feedItems[index];
                  print(item);

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

                  String feedItemTitle = '';
                  if (item['title'] != null && item['title']?['\$t'] != null) {
                    feedItemTitle = item['title']['\$t'].toString();
                  } else if (item['title'] != null) {
                    feedItemTitle = item['title'].toString();
                  }

                  // sanitize the title
                  feedItemTitle = HtmlUnescape().convert(feedItemTitle
                      .toString()
                      .replaceAll('{__cdata:', '')
                      .replaceAll('}', '')
                      .trim());
                  
                  String feedItemDescription = '';
                  if (item['description'] != null && item['description']['\$t'] != null) {
                    feedItemDescription = item['description']['\$t'].toString();
                  } else if (item['description'] != null) {
                    feedItemDescription = item['description'].toString();
                  }
                  
                  // sanitize the bejesus out of the desciption
                  feedItemDescription = HtmlUnescape().convert(feedItemDescription
                      .toString()
                      .replaceAll('<![CDATA[]>', '')
                      .replaceAll(']]>', '')
                      .replaceAll('{__cdata:', '')
                      .replaceAll('.}', '.')
                      // remove complete hyperlinks
                      .replaceAll(RegExp(r'<a href="(.*?)">(.*?)<\/a>'), '')
                      // remove all HTML tags
                      .replaceAll(RegExp(r'</?([a-zA-Z0-9]+)[^>]*>'), '')
                      // replace [...] and everything that follows with ...
                      .replaceAll(RegExp(r'\[.*?\].*'), '...')
                      .trim());

                  String feedItemLink = item['link']?['\$t']?.toString() ?? '';

                  return FeedItemTile(
                    feedItemImage: feedItemImage,
                    feedItemTitle: feedItemTitle,
                    feedItemDescription: feedItemDescription,
                    feedItemLink: feedItemLink,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_news/ui/components/feed_item_tile.dart';
import 'package:web_news/utils/helper_functions.dart' show extractImageFromContent, sanitizeDirtyString;

class FeedItem extends StatelessWidget {
  final dynamic item;
  final int index;
  final String feedType;
  final String feedContentElement;
  final GestureDragUpdateCallback? onVerticalDragUpdate;

  const FeedItem({
    super.key,
    required this.item,
    required this.index,
    required this.feedType,
    required this.feedContentElement,
    required this.onVerticalDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    String feedItemImage = '';
    String feedItemTitle = '';
    String feedItemDate = '';
    String feedItemDescription = '';
    String feedItemContent = '';
    String feedItemLink = '';

    if (feedType == 'rss') {
      // retrieve and sanitize title
      if (item['title'] != null && item['title']?['\$t'] != null) {
        feedItemTitle = item['title']['\$t'].toString();
      } else if (item['title'] != null) {
        feedItemTitle = item['title'].toString();
      }
  
      feedItemTitle = sanitizeDirtyString(feedItemTitle);
      
      // retrieve and format date
      String dateString = '';
      if (item['pubDate'] != null && item['pubDate']['\$t'] != null) {
        dateString = item['pubDate']['\$t'];
        DateTime parsedDate =
        DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(dateString);
        feedItemDate =
          DateFormat('yyyy/MM/dd - HH:mm').format(parsedDate);
      }

      if (feedContentElement == 'description') {
        // retrieve and sanitize description
        if (item['description'] != null && item['description']['\$t'] != null) {
          feedItemDescription = item['description']['\$t'].toString();
        } else if (item['description'] != null) {
          feedItemDescription = item['description'].toString();
        }
        
        feedItemDescription = sanitizeDirtyString(feedItemDescription);
      } else {
        // retrieve and sanitize content
        if (item['content\$encoded'] != null &&
          item['content\$encoded']['\$t'] != null) {
          feedItemContent = item['content\$encoded']['\$t'].toString();
        } else if (item['content\$encoded'] != null) {
          feedItemContent = item['content\$encoded'].toString();
        }
        
        feedItemContent = sanitizeDirtyString(feedItemContent);
      }
      
      // retrieve and clean link
      if (item['link'] != null) {
        if (item['link'] is Map && item['link']['\$t'] != null) {
          feedItemLink = item['link']['\$t'].toString();
        } else if (item['link'] is Map && item['link']['\$t'] == null) {
          feedItemLink = item['link'].toString()
            .replaceAll('{__cdata: ', '')
            .replaceAll('}', '');
        }
      }

      // retrieve image
      // do this last, because we may need to get this from the description / content
      if (item['enclosure'] != null && item['enclosure']['url'] != null) {
        feedItemImage = item['enclosure']['url'].toString();
      } else if (item['image'] != null && item['image'] != '') {
        feedItemImage = item['image']['\$t'];
      } else if (item['media\$thumbnail'] != null) {
        feedItemImage = item['media\$thumbnail']['url'];
      } else if (item['media\$content'] != null) {
        feedItemImage = item['media\$content']['url'];
      } else if (item['description'].toString().contains(RegExp(r'<img[^>]*>'))) {
        feedItemImage = extractImageFromContent(item['description'].toString())!;
      } else if (item['content\$encoded'].toString().contains(RegExp(r'<img[^>]*>'))) {
        feedItemImage = extractImageFromContent(item['content\$encoded'].toString())!;
      }

    } else if (feedType == 'feed') {
      // retrieve image
      feedItemImage = (item['link'] as List)
        .firstWhere((l) => l['rel'] == 'related',
        orElse: () => {'href': ''})['href'];
              
      // retrieve and sanitize title
      feedItemTitle = item['title']['\$t'] ?? '';
      feedItemTitle = sanitizeDirtyString(feedItemTitle);

      // retrieve and format date
      String dateString = '';
      dateString = item['updated']['\$t'] ?? '';
      DateTime parsedDate = DateTime.parse(dateString);
      feedItemDate = DateFormat('yyyy/MM/dd - HH:mm').format(parsedDate);
          
      // retrieve and sanitize content
      feedItemContent = item['content']['\$t'] ?? '';
      feedItemContent = sanitizeDirtyString(feedItemContent);
  
      // retrieve link and clean it a bit
      feedItemLink = (item['link'] as List)
        .firstWhere((l) => l.containsKey('href'),
        orElse: () => {'href': ''})['href'];
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
        onVerticalDragUpdate: onVerticalDragUpdate,
      ),
    );
  }
}
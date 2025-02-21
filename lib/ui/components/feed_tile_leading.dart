import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:web_news/utils/helper_functions.dart';
import 'package:xml2json/xml2json.dart';

class FeedTileLeading extends StatefulWidget {
  final String feedUrl;
  const FeedTileLeading({
    super.key,
    required this.feedUrl,
  });

  @override
  State<FeedTileLeading> createState() => _FeedTileLeadingState();
}

class _FeedTileLeadingState extends State<FeedTileLeading> {
  final Xml2Json xml2json = Xml2Json();
  String feedIconUrl = '';

  Future<String> getFeedIcon(String feedUrl) async {
    final url = Uri.parse(feedUrl);
    final response = await http.get(url);
    final utf8ResponsBody = utf8.decode(response.bodyBytes);

    xml2json.parse(utf8ResponsBody);
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);

    String feedIcon = '';

    if (data['rss'] != null && data['rss']['channel'] != null) {
      var channel = data['rss']['channel'];
      
      if (channel['atom\$logo'] != null) {
        feedIcon = channel['atom\$logo']['\$t'];
      } else if (channel['image']['url'] != null) {
        feedIcon = channel['image']['url']['\$t'];
      }
    }
    return feedIcon;
  }

  @override
  void initState() {
    super.initState();
    getFeedIcon(widget.feedUrl).then((icon) {
      setState(() {
        feedIconUrl = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget fallbackIcon = SizedBox(
      height: 32,
      width: 32,
      child: Center(
        child: SvgPicture.asset(
          'assets/images/rss.svg',
          width: 24,
          height: 24,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
            BlendMode.srcIn,
          ),
        ),
      ),
    );

    if (Platform.isLinux) {
      if (feedIconUrl.isEmpty) {
        return GestureDetector(
          onTap: () => openBrowser(widget.feedUrl),
          child: fallbackIcon,
        );
      } else if (feedIconUrl.endsWith('.svg')) {
        return GestureDetector(
          onTap: () => openBrowser(widget.feedUrl),
          child: SvgPicture.network(
            feedIconUrl,
            width: 32,
            height: 32,
            placeholderBuilder: (context) => fallbackIcon,
            errorBuilder: (context, error, stackTrace) {
              return fallbackIcon;
            },
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => openBrowser(widget.feedUrl),
          child: Image.network(
              feedIconUrl,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return fallbackIcon;
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return fallbackIcon;
              },
            ),
        );
      }
    } else {
      if (feedIconUrl.isEmpty) {
        return fallbackIcon;
      } else if (feedIconUrl.endsWith('.svg')) {
        return SvgPicture.network(
          feedIconUrl,
          width: 32,
          height: 32,
          placeholderBuilder: (context) => fallbackIcon,
          errorBuilder: (context, error, stackTrace) {
            return fallbackIcon;
          },
        );
      } else {
        return Image.network(
          feedIconUrl,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return fallbackIcon;
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return fallbackIcon;
          },
        );
      }
    }
  }
}
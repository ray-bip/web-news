import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:web_news/utils/helper_functions.dart';
import 'package:xml2json/xml2json.dart';

class FeedTileLeading extends StatefulWidget {
  final String feedUrl;
  final String? feedIconFromUser;

  const FeedTileLeading({
    super.key,
    required this.feedUrl,
    this.feedIconFromUser
  });

  @override
  State<FeedTileLeading> createState() => _FeedTileLeadingState();
}

class _FeedTileLeadingState extends State<FeedTileLeading> {
  final Xml2Json xml2json = Xml2Json();
  String feedIconUrl = '';
  String feedIcon = '';
  String feedSiteLink = '';

  Future<String> feedUrlToIconUrl(String feedUrl) async {
    final url = Uri.parse(feedUrl);
    final response = await http.get(url);
    final utf8ResponsBody = utf8.decode(response.bodyBytes);

    xml2json.parse(utf8ResponsBody);
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);

    if (data['rss'] != null && data['rss']['channel'] != null) {
      var channel = data['rss']['channel'];
      
      if (channel['link'] != null && channel['link']['\$t'] != null) {
        feedSiteLink = sanitizeDirtyString(channel['link']['\$t'].toString());
      } else if (channel['link'] != null) {
        feedSiteLink = sanitizeDirtyString(channel['link'].toString());
      }
    }

    feedIcon = '${feedSiteLinkToBaseDomain(feedSiteLink)}/favicon.ico';

    return feedIcon;
  }

  Future<String> getFeedIcon(String feedUrl) async {
    if (widget.feedIconFromUser != null && widget.feedIconFromUser != '') {
      feedIcon = widget.feedIconFromUser!;
    } else {
      final url = Uri.parse(feedUrl);
      final response = await http.get(url);
      final utf8ResponsBody = utf8.decode(response.bodyBytes);

      xml2json.parse(utf8ResponsBody);
      var jsondata = xml2json.toGData();
      var data = json.decode(jsondata);

      if (data['rss'] != null && data['rss']['channel'] != null) {
        var channel = data['rss']['channel'];
        
        if (channel['atom\$logo'] != null) {
          feedIcon = channel['atom\$logo']['\$t'];
        } else if (channel['image'] != null && channel['image']['url'] != null) {
          feedIcon = channel['image']['url']['\$t'];
        }
      }
    }
    return sanitizeDirtyString(feedIcon);
  }

  @override
  void initState() {
    super.initState();
    getFeedIcon(widget.feedUrl).then((icon) {
      print(icon);
      if (icon != '') {
        setState(() {
          feedIconUrl = icon;
        });
      } else {
        feedUrlToIconUrl(widget.feedUrl).then((icon) {
          print(icon);
          setState(() {
            feedIconUrl = icon;
          });
        });
      }
    });
  }

  void copyFeedUrl() {
    Clipboard.setData(ClipboardData(text: widget.feedUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feed URL copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double imageSize = 32;
    final cacheManager = DefaultCacheManager();
    
    Widget fallbackIcon = SizedBox(
      height: imageSize,
      width: imageSize,
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
          onLongPress: () => copyFeedUrl(),
          child: FutureBuilder<File>(
            future: cacheManager.getSingleFile(feedIconUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: SvgPicture.file(
                    snapshot.data!,
                    width: imageSize,
                    height: imageSize,
                    placeholderBuilder: (context) => fallbackIcon,
                  ),
                );
              } else {
                return fallbackIcon;
              }
            },
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => openBrowser(widget.feedUrl),
          onLongPress: () => copyFeedUrl(),
          child: SizedBox(
            height: imageSize,
            width: imageSize,
            child: CachedNetworkImage(
              imageUrl: feedIconUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              placeholder: (context, url) => fallbackIcon,
              errorWidget: (context, url, error) => fallbackIcon,
            ),
          ),
        );
      }
    } else {
      if (feedIconUrl.isEmpty) {
        return fallbackIcon;
      } else if (feedIconUrl.endsWith('.svg')) {
        return FutureBuilder<File>(
          future: cacheManager.getSingleFile(feedIconUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return SizedBox(
                width: imageSize,
                height: imageSize,
                child: SvgPicture.file(
                  snapshot.data!,
                  width: imageSize,
                  height: imageSize,
                  placeholderBuilder: (context) => fallbackIcon,
                ),
              );
            } else {
              return fallbackIcon;
            }
          },
        );
      } else {
        return SizedBox(
          height: imageSize,
          width: imageSize,
          child: CachedNetworkImage(
            imageUrl: feedIconUrl,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
            placeholder: (context, url) => fallbackIcon,
            errorWidget: (context, url, error) => fallbackIcon,
          ),
        ); 
      }
    }
  }
}
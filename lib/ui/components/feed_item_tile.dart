// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:web_news/utils/helper_functions.dart';

class FeedItemTile extends StatefulWidget {
  final String feedItemImage;
  final String feedItemTitle;
  final String feedItemDate;
  final String feedItemDescription;
  final String feedItemContent;
  final String feedItemLink;

  const FeedItemTile({
    super.key,
    required this.feedItemImage,
    required this.feedItemTitle,
    required this.feedItemDate,
    required this.feedItemDescription,
    required this.feedItemContent,
    required this.feedItemLink,
  });

  @override
  State<FeedItemTile> createState() => _FeedItemTileState();
}

class _FeedItemTileState extends State<FeedItemTile> {
  bool _showContentOrDescription = false;
  
  bool isImage(String imageLocation) {
    return imageLocation.toLowerCase().contains('.gif') ||
      imageLocation.toLowerCase().contains('.jpeg') ||
      imageLocation.toLowerCase().contains('.jpg') ||
      imageLocation.toLowerCase().contains('.png') ||
      imageLocation.toLowerCase().contains('.svg') ||
      imageLocation.toLowerCase().contains('.webp');
  }

  void toggleContentOrDescription() {
    setState(() {
      _showContentOrDescription = !_showContentOrDescription;
    });
  }

  InkWell displayContentOrDescription(String contentOrDescription) {
    // wrap the entire thing in <p></p> if that's not already the case, for consistent spacing
    if (!contentOrDescription.startsWith('<p>')) {
      contentOrDescription = '<p>$contentOrDescription</p>';
    }

    // return as HTML with some styling
    return InkWell(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: contentOrDescription));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Text copied!')),
        );
      },
      child: Html(
        data: contentOrDescription,
        doNotRenderTheseTags: {'a', 'img', 'br', 'form'},
        style: {
          '*' : Style(
            fontSize: FontSize(Platform.isLinux ? 18 : 16),
            lineHeight: LineHeight(Platform.isLinux ? 1.8: 1.6),
          ),
          'h2': Style(
            fontSize: FontSize( Platform.isLinux ? 20 : 18),
            margin: Margins.only(top: 32),
          ),
          'p': Style(
            fontSize: FontSize(Platform.isLinux ? 18 : 16),
            lineHeight: LineHeight(Platform.isLinux ? 1.8: 1.6),
            margin: Margins.only(bottom: 24),
          ),
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer.withAlpha(160),
                  Theme.of(context).colorScheme.primaryContainer.withAlpha(255),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: ListTile(
              onTap: toggleContentOrDescription,
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: widget.feedItemTitle));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Title copied!')),
                );
              },
              isThreeLine: true,
              leading: isImage(widget.feedItemImage)
                ? Image.network(
                  widget.feedItemImage,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover) 
                : Container(
                  color: Theme.of(context).colorScheme.surface,
                  width: 64,
                  height: 64,
                  child: Center(
                    child: Text(
                      'image not available',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              title: Padding(
                padding: Platform.isLinux
                  ? const EdgeInsets.only(left: 8) : const EdgeInsets.all(0),
                child: Text(
                  widget.feedItemTitle,
                  style: TextStyle(
                    fontSize: Platform.isLinux ? 18 : 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: Platform.isLinux
                  ? const EdgeInsets.fromLTRB(8, 12, 0 ,0) : const EdgeInsets.only(top: 8),
                child: Text(
                  widget.feedItemDate,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(192),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              trailing: widget.feedItemDescription != ''
                ? IconButton(
                  onPressed: () {
                    openBrowser(widget.feedItemLink);
                  },
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: widget.feedItemLink));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied!')),
                      );
                  },
                  icon: Icon(
                      Icons.open_in_new,
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                  )
                : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          if (_showContentOrDescription)
            Container(
              color: Theme.of(context).colorScheme.primaryContainer.withAlpha(255),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: widget.feedItemDescription == '' && widget.feedItemContent == ''
                      ? Padding(
                        // I think it should be 88 for Linux below, but the UI says 84
                        // so I guess I'm wrong then...
                        padding: EdgeInsets.only(left: Platform.isLinux ? 84 : 80),
                        child: const Expanded(
                          child: Text('[No content available in rss feed]'),
                        ),
                      )
                      : widget.feedItemContent != ''
                          ? displayContentOrDescription(widget.feedItemContent)
                          : displayContentOrDescription(widget.feedItemDescription),
                    ),
                  ),
                ],
              )
            ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:web_news/ui/components/feed_item_tile_leading.dart';
import 'package:web_news/ui/components/feed_item_tile_subtitle.dart';

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
  bool _tileIsActive = false;

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
      _tileIsActive = !_tileIsActive;
    });
  }

  InkWell displayContentOrDescription(String contentOrDescription) {
    // remove "<br><br>" from start of contentOrDescription
    if (contentOrDescription.startsWith('<br><br>')) {
      contentOrDescription = contentOrDescription.substring(8);
    }
    
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
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Html(
        data: contentOrDescription,
        doNotRenderTheseTags: {'a', 'img', 'form'},
        style: {
          '*' : Style(
            color: Theme.of(context).colorScheme.onSecondaryContainer.withAlpha(192),
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
          AnimatedContainer(
            duration: _tileIsActive 
              ? const Duration(milliseconds: 0)
              : const Duration(milliseconds: 1600),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _tileIsActive
                  ? Theme.of(context).colorScheme.secondaryContainer.withAlpha(128)
                  : Theme.of(context).colorScheme.primaryContainer.withAlpha(160),
                  _tileIsActive
                  ? Theme.of(context).colorScheme.secondaryContainer.withAlpha(192)
                  : Theme.of(context).colorScheme.primaryContainer,
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
              hoverColor: Colors.black.withAlpha(32),
              splashColor: Colors.black.withAlpha(96),
              isThreeLine: true,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              leading: FeedItemTileLeading(
                feedItemImage: widget.feedItemImage
              ),
              title: Padding(
                padding: Platform.isLinux
                  ? const EdgeInsets.fromLTRB(8, 2, 8, 0) : const EdgeInsets.only(top: 2),
                child: Text(
                  widget.feedItemTitle,
                  style: TextStyle(
                    fontSize: Platform.isLinux ? 18 : 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              titleAlignment: ListTileTitleAlignment.titleHeight,
              subtitle: FeedItemTileSubtitle(
                feedItemDate: widget.feedItemDate,
                feedItemLink: widget.feedItemLink,
              ),
            ),
          ),
          if (_showContentOrDescription)
            Container(
              color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(192),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: Platform.isLinux ? 704 : 480,
                ),
                child: SingleChildScrollView(
                  child: 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      child: widget.feedItemDescription.isEmpty
                        && widget.feedItemContent.isEmpty
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text('[No content available in rss feed]'),
                        ),
                      )
                      : widget.feedItemContent != ''
                          ? displayContentOrDescription(widget.feedItemContent)
                          : displayContentOrDescription(widget.feedItemDescription),
                    ),
                ),
              )
            ),
          if (_showContentOrDescription)
            Container(
              color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(160),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: IconButton(
                      onPressed: toggleContentOrDescription,
                      icon: const Icon(Icons.arrow_circle_up, size: 32),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

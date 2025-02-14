// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
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
  bool _showDescriptionOrContent = false;
  
  bool isImage(String imageLocation) {
    return imageLocation.toLowerCase().endsWith('.gif') ||
      imageLocation.toLowerCase().endsWith('.jpeg') ||
      imageLocation.toLowerCase().endsWith('.jpg') ||
      imageLocation.toLowerCase().endsWith('.png') ||
      imageLocation.toLowerCase().endsWith('.svg') ||
      imageLocation.toLowerCase().endsWith('.webp');
  }

  bool isHtml(String textInput) {
    return (textInput.contains('<') &&
      textInput.contains('</') || textInput.contains('<') &&
      textInput.contains('/>'));
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
              onTap: () {
                setState(() {
                  _showDescriptionOrContent = !_showDescriptionOrContent;
                });
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
                  icon: Icon(
                      Icons.open_in_new,
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                  )
                : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          if (_showDescriptionOrContent)
            Container(
              color: Theme.of(context).colorScheme.primaryContainer.withAlpha(255),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      // check if content property is present
                      // >> if so: check if it's HTML
                      // >>>> if so: display as HTML, otherwise display as text
                      // >> if no content property: use description and check if it's HTML
                      // >>>> if so: display as HTML, otherwise display as text
                      child: widget.feedItemContent != ''
                      ? isHtml(widget.feedItemContent)
                        ? Html(
                          data: widget.feedItemContent,
                          doNotRenderTheseTags: {'a', 'img'},
                          style: {
                            'h2': Style(
                              fontSize: FontSize( Platform.isLinux ? 20 : 18),
                              margin: Margins.only(top: 32),
                            ),
                            'p': Style(
                              fontSize: FontSize(Platform.isLinux ? 18 : 16),
                              lineHeight: LineHeight(Platform.isLinux ? 1.8: 1.6),
                            ),
                          }
                        ) : Text(
                          widget.feedItemContent,
                          style: TextStyle(
                            height: Platform.isLinux ? 1.8 : 1.6,
                            fontSize: Platform.isLinux ? 18 : 16,
                          ),
                        )
                      : isHtml(widget.feedItemDescription)
                        ? Html(
                          data: widget.feedItemDescription,
                          doNotRenderTheseTags: {'a', 'img'},
                          style: {
                            'h2': Style(
                              fontSize: FontSize(Platform.isLinux ? 20 : 18),
                              margin: Margins.only(top: 32),
                            ),
                            'p': Style(
                              fontSize: FontSize(Platform.isLinux ? 18 : 16),
                              lineHeight: LineHeight(Platform.isLinux ? 1.8: 1.6),
                            ),
                          }
                        ) : Text(
                          widget.feedItemDescription,
                          style: TextStyle(
                            height: Platform.isLinux ? 1.8 : 1.6,
                            fontSize: Platform.isLinux ? 18 : 16,
                          ),
                        ),
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

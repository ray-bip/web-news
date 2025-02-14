// ignore_for_file: public_member_api_docs, sort_constructors_first
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
                openBrowser(widget.feedItemLink);
              },
              isThreeLine: true,
              leading: widget.feedItemImage != ''
                ? Image.network(
                  widget.feedItemImage,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover) 
                : null,
              title: Text(
                widget.feedItemTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
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
                    setState(() {
                      _showDescriptionOrContent = !_showDescriptionOrContent;
                    });
                  },
                  icon: Icon(
                      _showDescriptionOrContent
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: widget.feedItemContent != ''
                ? Html(
                  data: widget.feedItemContent,
                  doNotRenderTheseTags: {'a', 'img'},
                  style: {
                    'h2': Style(
                      fontSize:
                        FontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 18),
                      margin: Margins.only(top: 32),
                    ),
                  }
                )
                : Html(
                  data: widget.feedItemDescription,
                  doNotRenderTheseTags: {'a', 'img'},
                  style: {
                    'h2': Style(
                      fontSize:
                        FontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 18),
                      margin: Margins.only(top: 32),
                    ),
                  }
                )
              )
            ),
        ],
      ),
    );
  }
}

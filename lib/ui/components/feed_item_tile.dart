// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:web_news/utils/helper_functions.dart';

class FeedItemTile extends StatefulWidget {
  final String feedItemImage;
  final String feedItemTitle;
  final String feedItemDescription;
  final String feedItemLink;

  const FeedItemTile({
    super.key,
    required this.feedItemImage,
    required this.feedItemTitle,
    required this.feedItemDescription,
    required this.feedItemLink,
  });

  @override
  State<FeedItemTile> createState() => _FeedItemTileState();
}

class _FeedItemTileState extends State<FeedItemTile> {
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          ListTile(
            onTap: () {
              openBrowser(widget.feedItemLink);
            },
            leading: widget.feedItemImage != ''
              ? Image.network(
                widget.feedItemImage,
                width: 48,
                height: 48,
                fit: BoxFit.cover) 
              : null,
            title: Text(widget.feedItemTitle),
            trailing: widget.feedItemDescription != ''
              ? IconButton(
                onPressed: () {
                  setState(() {
                    showDescription = !showDescription;
                  });
                },
                icon: Icon(showDescription ? Icons.arrow_upward : Icons.arrow_downward))
              : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tileColor: Theme.of(context).colorScheme.tertiaryContainer,
          ),
          showDescription
          ? Container(
            color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(150),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.feedItemDescription),
            )
          )
          : const Material(),
        ],
      ),
    );
  }
}

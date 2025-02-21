import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedItemTileLeading extends StatelessWidget {
  final String feedItemImage;
  
  const FeedItemTileLeading({
    super.key,
    required this.feedItemImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: feedItemImage));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image URL copied!')),
          );
        },
        child: Image.network(
          feedItemImage,
          width: Platform.isLinux ? 72 : 56,
          height: Platform.isLinux ? 72 : 56,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Container(
                color: Theme.of(context).colorScheme.surface.withAlpha(128),
                width: Platform.isLinux ? 72 : 56,
                height: Platform.isLinux ? 72 : 56,
                child: Center(
                  child: Text(
                    'image loading...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.surface.withAlpha(128),
              width: Platform.isLinux ? 72 : 56,
              height: Platform.isLinux ? 72 : 56,
              child: Center(
                child: Text(
                  'image not available',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
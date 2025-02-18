import 'dart:io';

import 'package:flutter/material.dart';

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
              color: Theme.of(context).colorScheme.surface,
              width: 64,
              height: 64,
              child: Center(
                child: Text(
                  'image loading...',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
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
          );
        },
      ),
    );
  }
}
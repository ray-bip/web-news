import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedItemTileLeading extends StatelessWidget {
  static final double imageSize = Platform.isLinux ? 72 : 56;
  final String feedItemImage;
  
  const FeedItemTileLeading({
    super.key,
    required this.feedItemImage,
  });

  Widget fallBackImage(BuildContext context, String imageText) {
    return Container(
      color: Theme.of(context).colorScheme.surface.withAlpha(128),
      width: imageSize,
      height: imageSize,
      child: Center(
        child: Text(
          imageText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (feedItemImage.endsWith('.webm')){
      // fix this later, return N/A for
      return fallBackImage(context, 'image not available');
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: GestureDetector(
          onLongPress: () {
            if(Platform.isLinux) {
              Clipboard.setData(ClipboardData(text: feedItemImage));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image URL copied!')),
              );
            }
          },
          child: Image.network(
            feedItemImage,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return fallBackImage(context, 'image loading...');
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return fallBackImage(context, 'image not available');
            },
          ),
        ),
      );
    }
  }
}
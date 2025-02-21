import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:web_news/utils/helper_functions.dart';

class FeedItemTileContent extends StatelessWidget {
  final String content;
  
  const FeedItemTileContent({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    String contentToDisplay = content;
    
    // remove "<br><br>" from start of contentOrDescription
    if (contentToDisplay.startsWith('<br><br>')) {
      contentToDisplay = content.substring(8);
    }

    // wrap the entire thing in <p></p> if that's not already the case, for consistent spacing
    if (!contentToDisplay.startsWith('<p>')) {
      contentToDisplay = '<p>$contentToDisplay</p>';
    }

    return InkWell(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: htmlToPlainText(contentToDisplay)));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Text copied!')),
        );
      },
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: HtmlWidget(
        contentToDisplay,
        customStylesBuilder: (element) {
          if (element.localName == 'h2') {
            return {
              'color': colorToCss(Theme.of(context).colorScheme.onSurface.withAlpha(192)),
              'font-size': Platform.isLinux ? '20px' : '18px',
              'margin-top': '32px',
            };
          } else if (element.localName == 'p') {
            return {
              'color': colorToCss(Theme.of(context).colorScheme.onSurface.withAlpha(192)),
              'font-size': Platform.isLinux ? '18px' : '16px',
              'line-height':  Platform.isLinux ? '180%' : '160%',
            };
          }
          return {
            'color': colorToCss(Theme.of(context).colorScheme.onSurface.withAlpha(192)),
            'font-size': Platform.isLinux ? '18px' : '16px',
            'line-height':  Platform.isLinux ? '180%' : '160%',
          };
        },
        customWidgetBuilder: (element) {
          if (element.localName == 'img') {
            String imageUrl = element.attributes['src'].toString();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 80
                ),
                child: GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: imageUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image URL copied!')),
                    );
                  },
                  child: Image.network(
                    imageUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                          color: Theme.of(context).colorScheme.surface.withAlpha(128),
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
              ),
            );
          }
          return null;
        }
      ),
    );
  }
}
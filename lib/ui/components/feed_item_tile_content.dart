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
        Clipboard.setData(ClipboardData(text: contentToDisplay));
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
          if (element.localName == 'a') {
            return {
              'color': colorToCss(Theme.of(context).colorScheme.onSurface.withAlpha(192)),
              'text-decoration': 'underline',
              'text-decoration-color': 
                colorToCss(Theme.of(context).colorScheme.onSurface.withAlpha(192)),
            };
          } else if (element.localName == 'h2') {
            return {
              'color': colorToCss(Theme.of(context).colorScheme.onSurface.withAlpha(192)),
              'font-size': Platform.isLinux ? '20px' : '18px',
              'margin-top': '32px',
            };
          }
          else if (element.localName == 'img') {
            return {
              'display': 'block',
              'margin-bottom': '24px',
              'margin-top': '24px',
              'max-width': '${MediaQuery.of(context).size.width - 80}px',
            };
          }
          else if (element.localName == 'p') {
            return {
              'color': colorToCss(Theme.of(context).colorScheme.onSurface.withAlpha(192)),
              'font-size': Platform.isLinux ? '18px' : '16px',
              'line-height':  Platform.isLinux ? '180%' : '160%',
            };
          }
          return {};
        },
      ),
    );
  }
}
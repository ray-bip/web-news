import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart' show HtmlUnescape;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as html_parser;

void openBrowser(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

String sanitizeDirtyString(String dirtyString) {
  return HtmlUnescape().convert(dirtyString
    .replaceAll('{__cdata:', '')
    .replaceAll('}', '')
    .replaceAll('\\t', '')
    // remove "\\n"
    .replaceAll('\\\\n', '')
    // remove complete hyperlinks
    // as a test, we're keeping them for now, so the line below is commented out
    // .replaceAll(RegExp(r'<a href="(.*?)">(.*?)<\/a>'), '')
    // remove images
    // as a test, we're keeping them for now, so the line below is commented out
    // .replaceAll(RegExp(r'<img[^>]*>'), '')
    // remove forms
    .replaceAll(RegExp(r'<form\b[^>]*>.*?</form>', dotAll: true, caseSensitive: false), '')
    // remove inputs
    .replaceAll(RegExp(r'<input\b[^>]*\/?>', caseSensitive: false), '')
    // replace [...] and everything that follows with ...
    .replaceAll(RegExp(r'\[.*?\].*'), '...')
    // replace <!-- and everything that follows with ...
    .replaceAll(RegExp(r'<!--[\s\S]*$'), '...')
    
    // disable filters below, as we are now properly decoding the http response
    // test this for a while, and remove commented out code below if no longer needed
    // replace dumb, hideous single and double quotes
    // .replaceAll('‘', '\'')
    // .replaceAll('’', '\'')
    // .replaceAll('â', '\'')
    // .replaceAll('â', '\'')
    // .replaceAll('â', '\'')
    // .replaceAll('â', '\'')
    // .replaceAll('â', '"')
    // the empty space below contains a character, believe it or not
    // (and it works, so don't touch it!)
    // .replaceAll(',â', '"')
    // replace some other weird characters with whatever is appropriate
    // .replaceAll('â', ' ')
    // .replaceAll('â¢', '&bull;')
    // replace a collection of common phrases

    
    .replaceAll('Het bericht  verscheen eerst op .', '')
    .trim()
  );
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

String colorToCss(Color color) {
  int r = (color.r * 255).toInt();
  int g = (color.g * 255).toInt();
  int b = (color.b * 255).toInt();
  double a = color.a;

  return 'rgba($r, $g, $b, $a)';
}

String? extractImageFromContent(String htmlContent) {
  var document = html_parser.parse(htmlContent);
  var imgTag = document.querySelector('img');
  
  return imgTag?.attributes['src'];
}

String htmlToPlainText(String htmlContent) {
  return htmlContent.replaceAll(RegExp(r'<[^>]+>'), '');
}

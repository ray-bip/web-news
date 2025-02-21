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
    // remove some general stuff
    .replaceAll('{__cdata:', '')
    .replaceAll('}', '')
    .replaceAll('\\t', '')
    .replaceAll('\\\\n', '')
    // remove banners (assuming they're anchor tags with images inside)
    .replaceAll(RegExp(r'<a[^>]*>.*<img[^>]*>.*</a>'), '')
    // remove "blijf lezen" hyperlinks
    .replaceAll(RegExp(r'<a[^>]*>.*Blijf lezen.*</a>'), '')
    // remove forms
    .replaceAll(RegExp(r'<form\b[^>]*>.*?</form>', dotAll: true, caseSensitive: false), '')
    // remove inputs
    .replaceAll(RegExp(r'<input\b[^>]*\/?>', caseSensitive: false), '')
    // replace [...] and everything that follows with ...
    .replaceAll(RegExp(r'\[.*?\].*'), '...')
    // replace <!-- and everything that follows with ...
    .replaceAll(RegExp(r'<!--[\s\S]*$'), '...')
    // replace some common phrases
    .replaceAll('Het bericht  verscheen eerst op .', '')
    .replaceAll(RegExp(r'<p>The post.*GelreNieuws</a>\.</p>'), '')
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

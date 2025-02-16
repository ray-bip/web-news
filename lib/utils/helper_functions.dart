import 'dart:io';

import 'package:html_unescape/html_unescape.dart' show HtmlUnescape;
import 'package:url_launcher/url_launcher.dart';

void openBrowser(String url) async {
  if (Platform.isLinux) {
    Process.run('xdg-open', [url]);
  } else {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
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
      .replaceAll(RegExp(r'<a href="(.*?)">(.*?)<\/a>'), '')
      // remove images
      .replaceAll(RegExp(r'<img[^>]*>'), '')
      // remove forms
      .replaceAll(RegExp(r'<form\b[^>]*>.*?</form>', dotAll: true, caseSensitive: false), '')
      // remove inputs
      .replaceAll(RegExp(r'<input\b[^>]*\/?>', caseSensitive: false), '')
      // replace [...] and everything that follows with ...
      .replaceAll(RegExp(r'\[.*?\].*'), '...')
      // replace <!-- and everything that follows with ...
      .replaceAll(RegExp(r'<!--[\s\S]*$'), '...')
      // replace dumb, hideous single and double quotes
      .replaceAll('‘', '\'')
      .replaceAll('’', '\'')
      .replaceAll('â', '\'')
      .replaceAll('â', '\'')
      .replaceAll('â', '\'')
      .replaceAll('â', '\'')
      .replaceAll('â', '"')
      // the empty space below contains a character, believe it or not
      // (and it works, so don't touch it!)
      .replaceAll(',â', '"')
      // replace some other weird character with a space
      .replaceAll('â', ' ')
      // replace a collection of common phrases
      .replaceAll('Het bericht  verscheen eerst op .', '')
      .trim());
  }
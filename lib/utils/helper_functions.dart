import 'dart:io';

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

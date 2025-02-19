import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_news/data/feed.dart';
import 'package:web_news/providers/theme_provider.dart';
import 'package:web_news/ui/components/feed_tile.dart';
import 'package:web_news/utils/constants.dart';
import 'package:web_news/utils/helper_functions.dart';
import 'package:web_news/utils/window_top_bar.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  HomeScreen({super.key});

  final List<Feed> feeds = Feed.feeds;
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isAndroid ? AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: Icon(
            Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
              ? Icons.light_mode
              : Icons.dark_mode,
          ),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
        title: const Text(appName),
        centerTitle: true,
      ) : null,
      body: Container(
        decoration: Platform.isLinux ? BoxDecoration(
          border: Border.all(
            color: isDarkMode(context)
              ? Theme.of(context).colorScheme.surfaceBright
              : Theme.of(context).colorScheme.surfaceBright,
            width: 1.6,
          ),
        ) : null,
        child: Column(
          children: [
            if (Platform.isLinux) const WindowTopBar(
              currentRoute: routeName,
              windowTitle: appName,
            ),
            Expanded(
              child: Container(
                color: isDarkMode(context)
                  ? Theme.of(context).colorScheme.surfaceContainer
                  : Theme.of(context).colorScheme.surfaceTint.withAlpha(48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 8);
                    },
                    itemCount: feeds.length,
                    itemBuilder: (BuildContext context, int index) { 
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: FeedTile(
                          feedTitle: feeds[index].title,
                          feedUrl: feeds[index].url,
                          feedContentElement: feeds[index].contentElement,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


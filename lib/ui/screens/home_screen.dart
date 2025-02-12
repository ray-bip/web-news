import 'package:flutter/material.dart';
import 'package:web_news/ui/components/feed_tile.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  HomeScreen({super.key});

  final List<Map<String, String>> feeds = [
    {'title': 'Nu.nl - Binnenland', 'url': 'https://www.nu.nl/rss/Binnenland'},
    {'title': 'Nu.nl - Buitenland', 'url': 'https://www.nu.nl/rss/Buitenland'},
    {'title': '112 Nederland', 'url': 'https://112nederland.nl/feed/'},
    {'title': 'BBC - World', 'url': 'https://feeds.bbci.co.uk/news/world/rss.xml'},
    {'title': 'Flutter', 'url': 'https://blog.flutter.wtf/rss/'},
  ];
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Web Nieuws - Home'),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8);
            },
            itemCount: feeds.length,
            itemBuilder: (BuildContext context, int index) { 
              return FeedTile(
                feedTitle: feeds[index]['title']!,
                feedUrl: feeds[index]['url']!,
              );
            },
          ),
        ),
      ),
    );
  }
}


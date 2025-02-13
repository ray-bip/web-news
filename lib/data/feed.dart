class Feed {
  final String title;
  final String url;
  final String length;

  Feed({
    required this.title,
    required this.url,
    required this.length
  });

  static final List<Feed> feeds = [
    Feed(
      title: 'Nu.nl - Binnenland',
      url: 'https://www.nu.nl/rss/Binnenland',
      length: '20',
    ),
    Feed(
      title: 'Nu.nl - Buitenland',
      url: 'https://www.nu.nl/rss/Buitenland',
      length: '20',
    ),
    // Feed(
    //   title: '112 Nederland',
    //   url: 'https://112nederland.nl/feed/',
    //   length: '10',
    // ),
    Feed(
      title: 'BBC - World',
      url: 'https://feeds.bbci.co.uk/news/world/rss.xml',
      length: '20',
    ),
    Feed(
      title: 'Nu.nl - Tech & Wetenschap',
      url: 'https://www.nu.nl/rss/tech-wetenschap',
      length: '10',
    ),
    Feed(
      title: 'Scientias - Algemeen',
      url: 'https://feeds.feedburner.com/scientias-wetenschap',
      length: '5',
    ),
    Feed(
      title: 'Scientias - Geschiedenis',
      url: 'https://scientias.nl/nieuws/geschiedenis/feed/',
      length: '5',
    ),
    Feed(
      title: 'Scientias - Astronomie & Ruimtevaart',
      url: 'https://scientias.nl/nieuws/astronomie-ruimtevaart/feed/',
      length: '5',
    ),
    Feed(
      title: 'Scientias - Psychologie',
      url: 'https://scientias.nl/nieuws/gezondheid-psychologie/feed/',
      length: '5',
    ),
    Feed(
      title: 'Scientias - Natuur & Klimaat',
      url: 'https://scientias.nl/nieuws/natuur-klimaat/feed/',
      length: '5',
    ),
    Feed(
      title: 'Scientias - Technologie',
      url: 'https://scientias.nl/nieuws/green-tech/feed/',
      length: '5',
    ),
    Feed(
      title: 'Flutter',
      url: 'https://blog.flutter.wtf/rss/',
      length: '5',
    ),
  ];
}



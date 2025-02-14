class Feed {
  final String title;
  final String url;

  Feed({
    required this.title,
    required this.url,
  });

  static final List<Feed> feeds = [
    Feed(
      title: 'Nu.nl - Binnenland',
      url: 'https://www.nu.nl/rss/Binnenland',
    ),
    Feed(
      title: 'Nu.nl - Buitenland',
      url: 'https://www.nu.nl/rss/Buitenland',
    ),
    Feed(
      title: 'Nu.nl - Tech & Wetenschap',
      url: 'https://www.nu.nl/rss/tech-wetenschap',
    ),
    Feed(
      title: 'Nu.nl - Opmerkelijk',
      url: 'https://www.nu.nl/rss/Opmerkelijk',
    ),
    Feed(
      title: 'NOS - Binnenland',
      url: 'https://feeds.nos.nl/nosnieuwsbinnenland',
    ),
    Feed(
      title: 'NOS - Buitenland',
      url: 'https://feeds.nos.nl/nosnieuwsbuitenland',
    ),
    Feed(
      title: 'NOS - Opmerkelijk',
      url: 'https://feeds.nos.nl/nosnieuwsopmerkelijk',
    ),
    Feed(
      title: '112 Nederland',
      url: 'https://112nederland.nl/feed/',
    ),
    Feed(
      title: 'BBC - World',
      url: 'https://feeds.bbci.co.uk/news/world/rss.xml',
    ),
    Feed(
      title: 'UN - Top Stories',
      url: 'https://news.un.org/feed/subscribe/en/news/all/rss.xml',
    ),
    Feed(
      title: 'GP 33',
      url: 'https://gp33.nl/sitemap/news.xml',
    ),
    Feed(
      title: 'GP Blog',
      url: 'https://www.gpblog.com/nl/rss/index.xml',
    ),
    Feed(
      title: 'GP Fans',
      url: 'https://www.gpfans.com/nl/rss.xml',
    ),
    // Feed(
    //   title: 'Motorsport.com - NL',
    //   url: 'https://nl.motorsport.com/rss/',
    // ),
    Feed(
      title: 'Scientias - Algemeen',
      url: 'https://feeds.feedburner.com/scientias-wetenschap',
    ),
    Feed(
      title: 'Scientias - Geschiedenis',
      url: 'https://scientias.nl/nieuws/geschiedenis/feed/',
    ),
    Feed(
      title: 'Scientias - Astronomie & Ruimtevaart',
      url: 'https://scientias.nl/nieuws/astronomie-ruimtevaart/feed/',
    ),
    // Feed(
    //   title: 'Scientias - Psychologie',
    //   url: 'https://scientias.nl/nieuws/gezondheid-psychologie/feed/',
    // ),
    Feed(
      title: 'Scientias - Natuur & Klimaat',
      url: 'https://scientias.nl/nieuws/natuur-klimaat/feed/',
    ),
    Feed(
      title: 'Scientias - Technologie',
      url: 'https://scientias.nl/nieuws/green-tech/feed/',
    ),
    Feed(
      title: 'Flutter',
      url: 'https://blog.flutter.wtf/rss/',
    ),
    Feed(
      title: 'De Speld',
      url: 'https://speld.nl/feed',
    ),
  ];
}



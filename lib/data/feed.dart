class Feed {
  final String title;
  final String url;
  final String? iconUrl;
  final String contentElement;

  Feed({
    required this.title,
    required this.url,
    required this.contentElement,
    this.iconUrl,
  });

  static final List<Feed> feeds = [
    Feed(
      title: 'Nu.nl - Binnenland',
      url: 'https://www.nu.nl/rss/Binnenland',
      contentElement: 'description'
    ),
    Feed(
      title: 'Nu.nl - Buitenland',
      url: 'https://www.nu.nl/rss/Buitenland',
      contentElement: 'description'
    ),
    Feed(
      title: 'Nu.nl - Technologie & Wetenschap',
      url: 'https://www.nu.nl/rss/tech-wetenschap',
      contentElement: 'description'
    ),
    Feed(
      title: 'Nu.nl - Opmerkelijk',
      url: 'https://www.nu.nl/rss/Opmerkelijk',
      contentElement: 'description'
    ),
    Feed(
      title: 'NOS - Binnenland',
      url: 'https://feeds.nos.nl/nosnieuwsbinnenland',
      contentElement: 'description'
    ),
    Feed(
      title: 'NOS - Buitenland',
      url: 'https://feeds.nos.nl/nosnieuwsbuitenland',
      contentElement: 'description'
    ),
    Feed(
      title: 'NOS - Opmerkelijk',
      url: 'https://feeds.nos.nl/nosnieuwsopmerkelijk',
      contentElement: 'description'
    ),
    Feed(
      title: '112 Nederland',
      url: 'https://112nederland.nl/feed/',
      contentElement: 'description'
    ),
    Feed(
      title: 'GelreNieuws',
      url: 'https://www.gelrenieuws.nl/rss',
      contentElement: 'description'
    ),
    Feed(
      title: 'Omroep Gelderland',
      url: 'https://www.gld.nl/rss/index.xml',
      iconUrl: 'https://s.regiogroei.cloud/img/favicons/gelderland/apple-touch-icon.png',
      contentElement: 'description'
    ),
    Feed(
      title: 'BBC - World',
      url: 'https://feeds.bbci.co.uk/news/world/rss.xml',
      contentElement: 'description'
    ),
    Feed(
      title: 'UN - Top Stories',
      url: 'https://news.un.org/feed/subscribe/en/news/all/rss.xml',
      contentElement: 'description'
    ),
    Feed(
      title: 'GP 33',
      url: 'https://gp33.nl/sitemap/news.xml',
      iconUrl: 'https://r.testifier.nl/Acbs8526SDKI/resizing_type:fill/plain/https%3A%2F%2Fs3-newsifier.ams3.digitaloceanspaces.com%2Fgp33.nl%2Fimages%2F2024-09%2Ffavicongp33-66ec39b84b1de.png',
      contentElement: 'description'
    ),
    Feed(
      title: 'GP Blog',
      url: 'https://www.gpblog.com/nl/rss/index.xml',
      iconUrl: 'https://next.cdn.gpblog.com/images/gp/favicon/apple-touch-icon.png',
      contentElement: 'description'
    ),
    Feed(
      title: 'GP Fans',
      url: 'https://www.gpfans.com/nl/rss.xml',
      contentElement: 'description'
    ),
    Feed(
      title: 'Motorsport.com - NL',
      url: 'https://nl.motorsport.com/rss/f1/news/',
      iconUrl: 'https://nl.motorsport.com/design/images/webapp/i72.png',
      contentElement: 'description'
    ),
    Feed(
      title: 'MIT - AI',
      url: 'https://news.mit.edu/topic/mitartificial-intelligence2-rss.xml',
      contentElement: 'content'
    ),
    Feed(
      title: 'Gizmodo',
      url: 'https://gizmodo.com/feed',
      contentElement: 'description'
    ),
    Feed(
      title: 'Hugging Face',
      url: 'https://papers.takara.ai/api/feed',
      contentElement: 'description'
    ),
    Feed(
      title: 'TechCrunch',
      url: 'https://techcrunch.com/feed/',
      contentElement: 'description'
    ),
    Feed(
      title: 'European Space Agency',
      url: 'http://www.esa.int/rssfeed/Our_Activities/Space_News',
      contentElement: 'description'
    ),
    Feed(
      title: 'NASA',
      url: 'https://www.nasa.gov/news-release/feed/',
      iconUrl: 'https://www.nasa.gov/wp-content/plugins/nasa-hds-core-setup/assets/favicons/favicon-96x96.png',
      contentElement: 'description'
    ),
    Feed(
      title: 'NATO',
      url: 'http://www.nato.int/cps/rss/en/natohq/rssFeed.xsl/rssFeed.xml',
      iconUrl: 'https://www.nato.int/nato_static_fl2014/assets_enh/layout/logo_EN.png',
      contentElement: 'description'
    ),
    Feed(
      title: 'Europese Unie',
      url: 'https://european-union.europa.eu/node/484/rss_en',
      contentElement: 'description'
    ),
    Feed(
      title: 'Europees Parlement',
      url: 'https://www.europarl.europa.eu/rss/doc/top-stories/nl.xml',
      contentElement: 'description'
    ),
    Feed(
      title: 'Europol',
      url: 'https://www.europol.europa.eu/rss.xml',
      contentElement: 'description'
    ),
    Feed(
      title: 'International Criminal Court',
      url: 'https://www.icc-cpi.int/rss/news/all',
      iconUrl: 'https://www.icc-cpi.int/themes/custom/icccpi/favicon.ico',
      contentElement: 'description'
    ),
    Feed(
      title: 'Scientias - Algemeen',
      url: 'https://feeds.feedburner.com/scientias-wetenschap',
      contentElement: 'description'
    ),
    Feed(
      title: 'Scientias - Geschiedenis',
      url: 'https://scientias.nl/nieuws/geschiedenis/feed/',
      contentElement: 'description'
    ),
    Feed(
      title: 'Scientias - Astronomie & Ruimtevaart',
      url: 'https://scientias.nl/nieuws/astronomie-ruimtevaart/feed/',
      contentElement: 'description'
    ),
    Feed(
      title: 'Scientias - Gezondheid',
      url: 'https://scientias.nl/nieuws/gezondheid/feed/',
      contentElement: 'description'
    ),
    Feed(
      title: 'Scientias - Natuur & Klimaat',
      url: 'https://scientias.nl/nieuws/natuur-klimaat/feed/',
      contentElement: 'description'
    ),
    Feed(
      title: 'Scientias - Technologie',
      url: 'https://scientias.nl/nieuws/green-tech/feed/',
      contentElement: 'description'
    ),
    Feed(
      title: 'Flutter',
      url: 'https://blog.flutter.wtf/rss/',
      contentElement: 'content'
    ),
    Feed(
      title: 'Visual Studio Code',
      url: 'https://code.visualstudio.com/feed.xml',
      iconUrl: 'https://code.visualstudio.com/assets/apple-touch-icon.png',
      contentElement: 'description'
    ),
    Feed(
      title: 'Linux Mint',
      url: 'https://blog.linuxmint.com/?feed=rss2',
      contentElement: 'description'
    ),
    Feed(
      title: 'De Speld',
      url: 'https://speld.nl/feed',
      contentElement: 'content'
    ),

    // TO BE FIXED
    // Feed(
    //   title: 'Open AI',
    //   url: 'https://openai.com/news/rss.xml',
    // contentElement: 'description'
    // ),
    // Feed(
    //   title: 'Machine Learning Mastery',
    //   url: 'https://machinelearningmastery.com/feed/',
    // contentElement: 'description'
    // ),
  ];

  // feeds Rianne
  // static final List<Feed> feeds = [
  //   Feed(
  //     title: 'NOS - Binnenland',
  //     url: 'https://feeds.nos.nl/nosnieuwsbinnenland',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'NOS - Buitenland',
  //     url: 'https://feeds.nos.nl/nosnieuwsbuitenland',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: '112 Nederland',
  //     url: 'https://112nederland.nl/feed/',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'GelreNieuws',
  //     url: 'https://www.gelrenieuws.nl/rss',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'Omroep Gelderland',
  //     url: 'https://www.gld.nl/rss/index.xml',
  //     iconUrl: 'https://s.regiogroei.cloud/img/favicons/gelderland/apple-touch-icon.png',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'BBC - World',
  //     url: 'https://feeds.bbci.co.uk/news/world/rss.xml',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'UN - Top Stories',
  //     url: 'https://news.un.org/feed/subscribe/en/news/all/rss.xml',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'Scientias - Algemeen',
  //     url: 'https://feeds.feedburner.com/scientias-wetenschap',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'Scientias - Geschiedenis',
  //     url: 'https://scientias.nl/nieuws/geschiedenis/feed/',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'Scientias - Astronomie & Ruimtevaart',
  //     url: 'https://scientias.nl/nieuws/astronomie-ruimtevaart/feed/',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'Scientias - Gezondheid',
  //     url: 'https://scientias.nl/nieuws/gezondheid/feed/',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'Scientias - Natuur & Klimaat',
  //     url: 'https://scientias.nl/nieuws/natuur-klimaat/feed/',
  //     contentElement: 'description'
  //   ),
  //   Feed(
  //     title: 'Scientias - Technologie',
  //     url: 'https://scientias.nl/nieuws/green-tech/feed/',
  //     contentElement: 'description'
  //   ),
  // ];

}



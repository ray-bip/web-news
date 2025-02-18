import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_news/utils/window_top_bar.dart';

class FullArticleScreen extends StatefulWidget {
  static const String routeName = 'full_article';
  final String pageUrl;
  
  const FullArticleScreen({
    super.key,
    required this.pageUrl,
  });

  @override
  State<FullArticleScreen> createState() => _FullArticleScreenState();
}

class _FullArticleScreenState extends State<FullArticleScreen> {
  bool isLoading = true;
  late String pageContent;

  Future<void> getPageContent() async {
    if (widget.pageUrl.isEmpty) return;

    setState(() {
      isLoading = false;
      pageContent = 'page content goes here';
    });
  }

  @override
  void initState() {
    getPageContent();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    print(widget.pageUrl);
    return Scaffold(
      appBar: Platform.isAndroid ? AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Webview'),
        centerTitle: true,
      ) : null,
      body: Focus(
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.tab) {
            Navigator.pop(context);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.f5) {
            getPageContent();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: RefreshIndicator(
          onRefresh: getPageContent,
          child: Container(
            decoration: Platform.isLinux ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceBright,
                width: 1.6,
              ),
            ) : null,
            child: Column(
              children: [
                if (Platform.isLinux) WindowTopBar(
                  currentRoute: FullArticleScreen.routeName,
                  windowTitle: 'Webview',
                  refreshPage: getPageContent,
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                      child: isLoading
                      ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      )
                      : GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            Navigator.pop(context);
                          }
                        },
                        child: Column(
                          children: [
                            Text(widget.pageUrl),
                            Text(pageContent),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
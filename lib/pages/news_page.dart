import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wn_app/providers/news_provider.dart';
import 'package:wn_app/providers/settings_provider.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  NewsProvider? newsProvider;
  SettingsProvider? settingsProvider;

  @override
  void initState() {
    newsProvider = Provider.of<NewsProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${settingsProvider?.selectedNewsCategory}'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer<NewsProvider>(
              builder:
                  (BuildContext context, NewsProvider newsProvider, child) {
                return StreamBuilder<List<dynamic>>(
                  stream: newsProvider.newsStream,
                  builder: (context, snapshot) {
                    List<dynamic> news = snapshot.data ?? [];
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No news available'));
                    } else {
                      return newsProvider.loading
                          ? const Center(child: CircularProgressIndicator())
                          : news.isEmpty
                              ? const Center(child: Text('No news found'))
                              : ListView.builder(
                                  itemCount: news.length,
                                  itemBuilder: (context, index) {
                                    final article = news[index];
                                    return Card(
                                      margin: EdgeInsets.all(10.sp),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: _buildLeadingImage(
                                                article['urlToImage']),
                                          ),
                                          ListTile(
                                            title: Text(article['title']),
                                            subtitle: Text(
                                                article['description'] ??
                                                    'No description available'),
                                            trailing: IconButton(
                                              icon:
                                                  const Icon(Icons.open_in_new),
                                              onPressed: () {
                                                _openArticleUrl(
                                                    context, article['url']);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: 150.h,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        ),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: 150.h,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 150.h,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported),
      );
    }
  }

  void _openArticleUrl(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Article'),
        content: const Text('Do you want to open this article?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _launchInBrowser(url);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

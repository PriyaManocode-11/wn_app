import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:sentiment_dart/sentiment_dart.dart';
import 'package:http/http.dart' as http;
import 'package:wn_app/constants.dart/constant_params.dart';
import 'package:wn_app/constants.dart/end_points.dart';
import 'package:wn_app/constants.dart/strings.dart';

class NewsProvider with ChangeNotifier {
  List<dynamic> _news = [];
  bool _loading = false;

  final StreamController<List<dynamic>> _newsStreamController =
      StreamController<List<dynamic>>.broadcast();

  Stream<List<dynamic>> get newsStream => _newsStreamController.stream;
  bool get loading => _loading;

  @override
  void dispose() {
    _newsStreamController.close();
    super.dispose();
  }

  Future<void> fetchNews(String category,
      {String? weatherCondition, bool filterBasedOnWeather = false}) async {
    _loading = true;
    notifyListeners();

    String newsApiEndpoints = category == Strings.tesla
        ? Endpoints().getTeslaApi()
        : category == Strings.apple
            ? Endpoints().getAppleApi()
            : category == Strings.techCrunch
                ? Endpoints.techCrunch
                : category == Strings.business
                    ? Endpoints.businessNews
                    : Endpoints.wallNutStreetJournal;

    final response = await http.get(Uri.parse(
        '${Endpoints.newsBaseUrl}$newsApiEndpoints${Endpoints.apikey}${ConstantParams.newsApiKey}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _news = data['articles'];
      if (filterBasedOnWeather) {
        await filterNewsBasedOnWeather(weatherCondition ?? '');
      } else {
        _newsStreamController.add(_news);
      }
    } else {
      _newsStreamController.addError('Failed to load news');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> filterNewsBasedOnWeather(String weatherCondition) async {
    List<dynamic> filteredNews = [];

    for (var article in _news) {
      String title = article['title'];
      var analysis = Sentiment.analysis(title);

      if ((weatherCondition == 'cold') &&
          (analysis.words.good.length < analysis.words.bad.length)) {
        filteredNews.add(article);
      } else if (weatherCondition == 'hot' &&
          (analysis.words.good.length > analysis.words.bad.length)) {
        filteredNews.add(article);
      }
    }

    _newsStreamController.add(filteredNews);
  }
}

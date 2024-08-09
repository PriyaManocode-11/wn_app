import 'package:intl/intl.dart';

class Endpoints {
  DateTime now = DateTime.now();

  String formatDateToString() => DateFormat("yyyy-MM-dd").format(now);

  static const String newsBaseUrl = 'https://newsapi.org/v2/';
  static const String businessNews =
      'top-headlines?country=us&category=business&';
  static const String techCrunch = 'top-headlines?sources=techcrunch&';
  static const String wallNutStreetJournal = 'everything?domains=wsj.com&';
  static const String apikey = 'apiKey=';

  String getTeslaApi() =>
      'everything?q=tesla&from=$formatDateToString&sortBy=publishedAt&';

  String getAppleApi() =>
      'everything?q=apple&from=$formatDateToString&to=$formatDateToString&sortBy=popularity&';
}

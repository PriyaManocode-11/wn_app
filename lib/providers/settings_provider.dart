import 'package:flutter/material.dart';
import 'package:wn_app/constants.dart/strings.dart';

class SettingsProvider with ChangeNotifier {
  String _temperatureUnit = Strings.celsius;
  String _selectedNewsCategory = Strings.business;
  bool _filterNewsBasedOnWeather = false;

  String get temperatureUnit => _temperatureUnit;
  String get selectedNewsCategory => _selectedNewsCategory;
  bool get filterNewsBasedOnWeather => _filterNewsBasedOnWeather;

  void setTemperatureUnit(String unit) {
    _temperatureUnit = unit;
    notifyListeners();
  }

  void setNewsCategory(String category) {
    _selectedNewsCategory = category;
    notifyListeners();
  }

  void toggleFilterNewsBasedOnWeather(bool value) {
    _filterNewsBasedOnWeather = value;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wn_app/constants.dart/strings.dart';
import 'package:wn_app/providers/news_provider.dart';
import 'package:wn_app/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    NewsProvider newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.settings),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Text(
            Strings.temperatureUnit,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
            title: const Text(Strings.celsius),
            value: Strings.celsius,
            groupValue: settingsProvider.temperatureUnit,
            onChanged: (value) {
              settingsProvider.setTemperatureUnit(value!);
            },
          ),
          RadioListTile<String>(
            title: const Text(Strings.fahrenheit),
            value: Strings.fahrenheit,
            groupValue: settingsProvider.temperatureUnit,
            onChanged: (value) {
              settingsProvider.setTemperatureUnit(value!);
            },
          ),
          SizedBox(height: 10.h),
          Text(
            Strings.newsCategories,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 270.h,
            child: ListView(
              children: [
                CheckboxListTile(
                  title: const Text(Strings.business),
                  value: settingsProvider.selectedNewsCategory
                      .contains(Strings.business),
                  onChanged: (value) {
                    settingsProvider.setNewsCategory(Strings.business);
                    newsProvider
                        .fetchNews(settingsProvider.selectedNewsCategory);
                  },
                ),
                CheckboxListTile(
                  title: const Text(Strings.tesla),
                  value: settingsProvider.selectedNewsCategory
                      .contains(Strings.tesla),
                  onChanged: (value) {
                    settingsProvider.setNewsCategory(Strings.tesla);
                    newsProvider
                        .fetchNews(settingsProvider.selectedNewsCategory);
                  },
                ),
                CheckboxListTile(
                  title: const Text(Strings.apple),
                  value: settingsProvider.selectedNewsCategory
                      .contains(Strings.apple),
                  onChanged: (value) {
                    settingsProvider.setNewsCategory(Strings.apple);
                    newsProvider
                        .fetchNews(settingsProvider.selectedNewsCategory);
                  },
                ),
                CheckboxListTile(
                  title: const Text(Strings.techCrunch),
                  value: settingsProvider.selectedNewsCategory
                      .contains(Strings.techCrunch),
                  onChanged: (value) {
                    settingsProvider.setNewsCategory(Strings.techCrunch);
                    newsProvider
                        .fetchNews(settingsProvider.selectedNewsCategory);
                  },
                ),
                CheckboxListTile(
                  title: const Text(Strings.theWallStreetJournal),
                  value: settingsProvider.selectedNewsCategory
                      .contains(Strings.theWallStreetJournal),
                  onChanged: (value) {
                    settingsProvider
                        .setNewsCategory(Strings.theWallStreetJournal);
                    newsProvider
                        .fetchNews(settingsProvider.selectedNewsCategory);
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Strings.filterBasedOnNews,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10.w,
              ),
              Tooltip(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4.sp),
                ),
                message:
                    'This enables to filter news based on weather condition\n 1. Positive news for Hot weather\n 2. Negative news for cold Weather\n',
                child: Icon(Icons.info, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SwitchListTile(
            title: const Text(
              'Filter news by weather',
              maxLines: 2,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            value: settingsProvider.filterNewsBasedOnWeather,
            onChanged: (value) {
              settingsProvider.toggleFilterNewsBasedOnWeather(value);
            },
          ),
        ],
      ),
    );
  }
}

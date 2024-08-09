import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:wn_app/constants.dart/styles.dart';
import 'package:wn_app/pages/news_page.dart';
import 'package:wn_app/pages/settings_page.dart';
import 'package:wn_app/providers/news_provider.dart';
import 'package:wn_app/providers/settings_provider.dart';
import 'package:wn_app/providers/weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
      Provider.of<WeatherProvider>(context, listen: false)
        ..fetchWeather()
        ..fetchFiveDayForecast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider = Provider.of<WeatherProvider>(context);
    final Weather? weather = weatherProvider.weather;
    final List<Weather>? forecast = weatherProvider.forecast;
    DateTime weatherNow = weather?.date ?? DateTime.now();
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings,
                color: Color.fromARGB(255, 58, 102, 137)),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen()));
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          'Weather Report',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 58, 102, 137),
          ),
        ),
      ),
      body: SafeArea(
        child: (weatherProvider.loading || weatherProvider.weather == null || weatherProvider.forecast!.isEmpty)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30.sp),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 219, 213, 213),
                              Color.fromARGB(255, 3, 63, 112),
                              Colors.blue,
                            ],
                            end: Alignment.bottomLeft,
                            begin: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(50.sp),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://openweathermap.org/img/wn/${weather?.weatherIcon ?? ''}@2x.png',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      weather?.areaName ?? '',
                                      style: textStyle(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      (settingsProvider.temperatureUnit ==
                                              'Celsius')
                                          ? '${weather?.temperature?.celsius?.toStringAsFixed(0)} °C'
                                          : '${weather?.temperature?.fahrenheit?.toStringAsFixed(0)} °F',
                                      style: textStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.all(20.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    weather?.weatherDescription ?? '',
                                    style: textStyle(fontSize: 15.sp),
                                  ),
                                  Text(
                                    DateFormat("EEEE").format(weatherNow),
                                    style: textStyle(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Text(
                        "Five Days Weather Forecast",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 58, 102, 137),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 0.3.sh,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: (forecast ?? []).length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 200.w,
                            margin: EdgeInsets.only(left: 30.w),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 219, 213, 213),
                                  Color.fromARGB(255, 176, 188, 198),
                                  Color.fromARGB(255, 189, 212, 231),
                                ],
                                end: Alignment.bottomLeft,
                                begin: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 12.h),
                                Text(
                                  DateFormat("EEEE").format(
                                      forecast?[index].date ?? DateTime.now()),
                                  style: textStyle(),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  settingsProvider.temperatureUnit == 'Celsius'
                                      ? '${forecast?[index].temperature?.celsius?.toStringAsFixed(0)} °C'
                                      : '${forecast?[index].temperature?.celsius?.toStringAsFixed(0)} °F',
                                  style: textStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.all(40.sp),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://openweathermap.org/img/wn/${forecast?[index].weatherIcon ?? ''}@2x.png',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat("h:mm a").format(
                                      forecast?[index].date ?? DateTime.now()),
                                  style: textStyle(fontSize: 14.sp),
                                ),
                                Text(
                                  forecast?[index].weatherDescription ?? '',
                                  style: textStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NewsPage()));
                        String temeperature =
                            (weatherProvider.weather?.temperature?.celsius ??
                                        0) <=
                                    10
                                ? 'cold'
                                : 'hot';
                        Future.delayed(const Duration(seconds: 1)).then(
                          (value) =>
                              Provider.of<NewsProvider>(context, listen: false)
                                  .fetchNews(
                                      settingsProvider.selectedNewsCategory,
                                      weatherCondition: temeperature,
                                      filterBasedOnWeather: settingsProvider
                                          .filterNewsBasedOnWeather),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.sp),
                        margin: EdgeInsets.symmetric(
                            horizontal: 50.w, vertical: 30.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 16, 39, 78),
                              Color.fromARGB(255, 176, 188, 198),
                              Color.fromARGB(255, 96, 136, 169),
                            ],
                            end: Alignment.bottomLeft,
                            begin: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Center(
                          child: Text(
                            'Today\'s News',
                            style: textStyle(fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

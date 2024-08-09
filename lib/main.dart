import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wn_app/pages/weather_page.dart';
import 'package:wn_app/providers/news_provider.dart';
import 'package:wn_app/providers/settings_provider.dart';
import 'package:wn_app/providers/weather_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
            title: 'Weather News App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              tooltipTheme: TooltipThemeData(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
                showDuration:
                    const Duration(seconds: 5),
              ),
            ),
            home: child);
      },
      child: const WeatherScreen(),
    );
  }
}

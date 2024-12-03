import 'package:aero_forecast/weather_page/weather_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: WeatherPage(),

    );
  }

}

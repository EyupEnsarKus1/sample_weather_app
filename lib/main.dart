import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_weather_app/weather_page.dart';

import 'core/bloc/weather_bloc.dart';
import 'core/service/weather_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => WeatherBloc(WeatherService()),
        child: WeatherPage(),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sample_weather_app/weather_page.dart';

import 'core/bloc/weather_bloc.dart';
import 'core/service/weather_service.dart';
import 'design/app_colors.dart';
import 'design/app_sizes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            final MediaQueryData mediaQueryData = MediaQuery.of(context);
            ScreenUtil.init(context);
            AppSizes.init();
            return MediaQuery(
              data: mediaQueryData,
              child: child!,
            );
          },
          home: SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => WeatherBloc(WeatherService()),
          child: const WeatherPage(),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGray,
      body: Center(
        child: Lottie.asset(
          "assets/weather_animation.json",
        ),
      ),
    );
  }
}

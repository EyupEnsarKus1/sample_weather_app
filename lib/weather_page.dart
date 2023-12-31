import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sample_weather_app/design/app_sizes.dart';
import 'package:sample_weather_app/design/custom_shimmer.dart';

import '../core/bloc/weather_bloc.dart';
import '../core/bloc/weather_event.dart';
import '../core/bloc/weather_state.dart';
import '../core/model/weather_model.dart';
import 'design/app_colors.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
    _fetchWeatherData();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum servisleri etkin değil. Lütfen etkinleştirin.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konum izinleri reddedildi.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum izinleri kalıcı olarak reddedildi.')),
      );
      return;
    }
  }

  void _fetchWeatherData() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      context.read<WeatherBloc>().add(WeatherAndCurrentRequested(lat: position.latitude, lon: position.longitude));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum alınamadı: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGray,
      appBar: AppBar(
        title: Text(
          'Hava Durumu',
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppSizes.size18,
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.lightGray,
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoadInProgress) {
            return SingleChildScrollView(
              child: Padding(
                padding: AppPadding.p16.horizontal(),
                child: Column(
                  children: [
                    CurrentWeatherCard.shimmerWidget(context),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return WeatherForecastCard.shimmerWidget(context);
                        })
                  ],
                ),
              ),
            );
          } else if (state is WeatherCombinedLoadSuccess) {
            return Padding(
              padding: AppPadding.p16.horizontal(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.currentWeatherData != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: AppSizes.size16,
                        ),
                        Text(
                          "Anlık Hava Durumu",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: AppSizes.size24,
                            fontWeight: AppWeights.bold,
                          ),
                        ),
                        CurrentWeatherCard(data: state.currentWeatherData!),
                      ],
                    ),
                  Text(
                    "5 Günlük Hava Durumu",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppSizes.size24,
                      fontWeight: AppWeights.bold,
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.size8,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: AppPadding.p16.onlyBottom(),
                      scrollDirection: Axis.vertical,
                      itemCount: state.weatherForecastData?.forecastList.length ?? 0,
                      itemBuilder: (context, index) {
                        return WeatherForecastCard(forecast: state.weatherForecastData!.forecastList[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WeatherLoadFailure) {
            return Text('Hata: ${state.message}');
          }
          return Container();
        },
      ),
    );
  }
}

class WeatherForecastCard extends StatelessWidget {
  final WeatherForecast forecast;

  const WeatherForecastCard({super.key, required this.forecast});

  static shimmerWidget(BuildContext context) {
    return ShimmerContainer(
      width: MediaQuery.of(context).size.width,
      height: 100,
      padding: AppPadding.p16.all(),
      margin: AppPadding.p8.onlyBottom(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MM yyyy - HH:mm').format(forecast.dateTime);
    final String iconUrl = 'https://openweathermap.org/img/wn/${forecast.weather.icon}@2x.png';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.lightGray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: AppPadding.p16.all(),
          margin: AppPadding.p8.onlyBottom(),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tarih/Zaman: $formattedDate',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Sıcaklık: ${forecast.temperature.temp}°C',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Hava Durumu: ${forecast.weather.description}',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Rüzgar Hızı: ${forecast.wind.speed} km/s',
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconCircle(
                  iconUrl: iconUrl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeatherData data;

  const CurrentWeatherCard({Key? key, required this.data}) : super(key: key);

  static shimmerWidget(BuildContext context) {
    return ShimmerContainer(
      padding: AppPadding.p16.all(),
      margin: AppPadding.p8.vertical(),
      width: MediaQuery.of(context).size.width,
      height: 150,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String iconUrl = 'https://openweathermap.org/img/wn/${data.weather.icon}.png';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: AppPadding.p16.all(),
      margin: AppPadding.p8.vertical(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                '${data.name}',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSizes.size20,
                  fontWeight: AppWeights.bold,
                ),
              ),
              SizedBox(
                height: AppSizes.size16,
              ),
              IconCircle(
                iconUrl: iconUrl,
                circleSize: AppSizes.size64,
                iconSize: AppSizes.size32,
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  SingleInfoCard(title: "Durum", value: data.weather.main),
                  SizedBox(
                    width: AppSizes.size4,
                  ),
                  SingleInfoCard(title: "Sıcaklık", value: "${data.temperature.temp}°C"),
                  SizedBox(
                    width: AppSizes.size4,
                  ),
                  SingleInfoCard(title: "Hissedilen", value: "${data.temperature.feelsLike}°C"),
                ],
              ),
              SizedBox(
                height: AppSizes.size8,
              ),
              Row(
                children: [
                  SingleInfoCard(title: "Minimum", value: "${data.temperature.tempMin}°C"),
                  SizedBox(
                    width: AppSizes.size4,
                  ),
                  SingleInfoCard(title: "Rüzgar", value: "${data.wind.speed} km/s, Yön: ${data.wind.deg}°"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SingleInfoCard extends StatelessWidget {
  final String title;
  final String value;
  const SingleInfoCard({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: AppPadding.p8.all(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: AppWeights.normal,
              fontSize: AppSizes.size12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: AppWeights.normal,
              fontSize: AppSizes.size12,
            ),
          ),
        ],
      ),
    );
  }
}

class IconCircle extends StatelessWidget {
  final String iconUrl;
  final double? circleSize;
  final double? iconSize;
  const IconCircle({Key? key, required this.iconUrl, this.circleSize, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: circleSize ?? AppSizes.size48,
      width: circleSize ?? AppSizes.size48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkGray,
      ),
      child: Image.network(
        iconUrl,
        fit: BoxFit.cover,
        width: iconSize ?? AppSizes.size24,
        height: iconSize ?? AppSizes.size24,
      ),
    );
  }
}

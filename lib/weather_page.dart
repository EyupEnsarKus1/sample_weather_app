import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../core/bloc/weather_bloc.dart';
import '../core/bloc/weather_event.dart';
import '../core/bloc/weather_state.dart';
import '../core/model/weather_model.dart';

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

  // Future<void> _getCurrentLocation(BuildContext context) async {
  //   try {
  //     final position = await Geolocator.getCurrentPosition();
  //     context.read<WeatherBloc>().add(WeatherRequested(lat: position.latitude, lon: position.longitude));
  //     context.read<WeatherBloc>().add(CurrentWeatherRequested(lat: position.latitude, lon: position.longitude));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Konum alınamadı: $e')),
  //     );
  //   }
  // }

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
      appBar: AppBar(
        title: Text('Hava Durumu'),
        centerTitle: true,
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherCombinedLoadSuccess) {
            return Column(
              children: [
                if (state.currentWeatherData != null) CurrentWeatherCard(data: state.currentWeatherData!),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.weatherForecastData?.forecastList.length ?? 0,
                    itemBuilder: (context, index) {
                      return WeatherForecastCard(forecast: state.weatherForecastData!.forecastList[index]);
                    },
                  ),
                ),
              ],
            );
          } else if (state is WeatherLoadInProgress) {
            return CircularProgressIndicator();
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Tarih/Zaman: ${forecast.dateTime}'),
            SizedBox(height: 8.0),
            Text('Sıcaklık: ${forecast.temperature.temp}°C'),
            Text('Hava Durumu: ${forecast.weather.description}'),
            Text('Rüzgar Hızı: ${forecast.wind.speed} km/s'),
          ],
        ),
      ),
    );
  }
}

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeatherData data;

  const CurrentWeatherCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Şu Anki Hava Durumu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Durum: ${data.weather.main}'),
            Text('Sıcaklık: ${data.temperature.temp}°C'),
            Text('Hissedilen: ${data.temperature.feelsLike}°C'),
            Text('Minimum: ${data.temperature.tempMin}°C'),
            Text('Rüzgar: ${data.wind.speed} km/s, Yön: ${data.wind.deg}°'),
          ],
        ),
      ),
    );
  }
}

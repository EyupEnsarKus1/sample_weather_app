import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../core/bloc/weather_bloc.dart';
import '../core/bloc/weather_event.dart';
import '../core/bloc/weather_state.dart';
import '../core/model/weather_model.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
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

  Future<void> _getCurrentLocation(BuildContext context) async {
    try {
      final position = await Geolocator.getCurrentPosition();
      context.read<WeatherBloc>().add(WeatherRequested(lat: position.latitude, lon: position.longitude));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum alınamadı: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hava Durumu')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _getCurrentLocation(context),
              child: Text('Cihaz Konumu İle Hava Durumu Getir'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoadInProgress) {
                    return CircularProgressIndicator();
                  } else if (state is WeatherLoadSuccess) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.weatherData.forecastList.length,
                      itemBuilder: (context, index) {
                        return WeatherForecastCard(forecast: state.weatherData.forecastList[index]);
                      },
                    );
                  } else if (state is WeatherLoadFailure) {
                    return Text('Hata: ${state.message}');
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherForecastCard extends StatelessWidget {
  final WeatherForecast forecast;

  WeatherForecastCard({required this.forecast});

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

import '../model/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoadInProgress extends WeatherState {}

class WeatherLoadSuccess extends WeatherState {
  final WeatherData weatherData;

  WeatherLoadSuccess({required this.weatherData});
}

class WeatherLoadFailure extends WeatherState {
  final String message;

  WeatherLoadFailure({required this.message});
}

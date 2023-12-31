import '../model/weather_model.dart';

abstract class WeatherState {}

class WeatherLoadInProgress extends WeatherState {}

class WeatherCombinedLoadSuccess extends WeatherState {
  final CurrentWeatherData? currentWeatherData;
  final WeatherData? weatherForecastData;

  WeatherCombinedLoadSuccess({this.currentWeatherData, this.weatherForecastData});
}

class WeatherLoadFailure extends WeatherState {
  final String message;

  WeatherLoadFailure({required this.message});
}

abstract class WeatherEvent {}

class WeatherRequested extends WeatherEvent {
  final double lat;
  final double lon;

  WeatherRequested({required this.lat, required this.lon});
}

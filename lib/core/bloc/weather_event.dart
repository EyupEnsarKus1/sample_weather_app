abstract class WeatherEvent {}

class WeatherAndCurrentRequested extends WeatherEvent {
  final double lat;
  final double lon;

  WeatherAndCurrentRequested({required this.lat, required this.lon});
}

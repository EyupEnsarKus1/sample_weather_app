import '../model/weather_model.dart';
import 'api_service.dart';

class WeatherService {
  final ApiService _apiService = ApiService(baseUrl: 'https://api.openweathermap.org/data/2.5/');
  final String _apiKey = 'ac78173c70a856e0ca425cdae51a2b5d';

  Future<ApiResponse<WeatherData?>> fetchWeather(double lat, double lon) async {
    try {
      final response = await _apiService.get<WeatherData>(
        'forecast',
        (data) => WeatherData.fromJson(data),
        queryParams: {
          'lat': lat,
          'lon': lon,
          'lang': 'tr',
          'units': 'metric',
          'appid': _apiKey,
        },
      );
      return response;
    } catch (e) {
      return ApiResponse<WeatherData?>(type: ResponseType.error);
    }
  }

  Future<ApiResponse<CurrentWeatherData?>> fetchCurrentWeather(double lat, double lon) async {
    try {
      final response = await _apiService.get<CurrentWeatherData>(
        'weather',
        (data) => CurrentWeatherData.fromJson(data),
        queryParams: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'lang': 'tr',
          'units': 'metric',
        },
      );
      return response;
    } catch (e) {
      return ApiResponse<CurrentWeatherData?>(type: ResponseType.error);
    }
  }
}

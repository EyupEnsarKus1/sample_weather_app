import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_weather_app/core/bloc/weather_event.dart';
import 'package:sample_weather_app/core/bloc/weather_state.dart';

import '../service/api_service.dart';
import '../service/weather_service.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService _weatherService;

  WeatherBloc(this._weatherService) : super(WeatherLoadInProgress()) {
    on<WeatherAndCurrentRequested>(_onWeatherAndCurrentRequested);
  }

  Future<void> _onWeatherAndCurrentRequested(WeatherAndCurrentRequested event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadInProgress());
    try {
      final currentWeatherResponse = await _weatherService.fetchCurrentWeather(event.lat, event.lon);
      final weatherForecastResponse = await _weatherService.fetchWeather(event.lat, event.lon);

      if (currentWeatherResponse.type == ResponseType.success && weatherForecastResponse.type == ResponseType.success) {
        emit(WeatherCombinedLoadSuccess(
          currentWeatherData: currentWeatherResponse.data,
          weatherForecastData: weatherForecastResponse.data,
        ));
      } else {
        emit(WeatherLoadFailure(message: 'Hava durumu verileri alınamadı.'));
      }
    } catch (error) {
      emit(WeatherLoadFailure(message: error.toString()));
    }
  }
}

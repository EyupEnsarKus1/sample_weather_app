import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_weather_app/core/bloc/weather_event.dart';
import 'package:sample_weather_app/core/bloc/weather_state.dart';

import '../model/weather_model.dart';
import '../service/api_service.dart';
import '../service/weather_service.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService _weatherService;

  WeatherBloc(this._weatherService) : super(WeatherInitial()) {
    on<WeatherRequested>((event, emit) async {
      emit(WeatherLoadInProgress());
      try {
        final ApiResponse<WeatherData?> response = await _weatherService.fetchWeather(event.lat, event.lon);
        if (response.type == ResponseType.success && response.data != null) {
          emit(WeatherLoadSuccess(weatherData: response.data!));
        } else {
          emit(WeatherLoadFailure(message: 'Hava durumu verileri alınamadı.'));
        }
      } catch (error) {
        emit(WeatherLoadFailure(message: error.toString()));
      }
    });
  }
}

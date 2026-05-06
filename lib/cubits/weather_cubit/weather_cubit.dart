import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_state.dart';
import '../../services/api_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final ApiService _apiService;

  WeatherCubit({required ApiService apiService})
      : _apiService = apiService,
        super(WeatherInitial());


  Future<void> getCurrentWeather(String cityName) async {
    try {
      emit(WeatherLoading());
      final weather = await _apiService.getCurrentWeather(cityName);
      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }


  Future<void> getForecast(String cityName) async {
    try {
      emit(WeatherLoading());
      final forecast = await _apiService.getForecast(cityName);
      emit(ForecastLoaded(forecast: forecast));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }


  Future<void> getWeatherAndForecast(String cityName) async {
    try {
      emit(WeatherLoading());
      final weather = await _apiService.getCurrentWeather(cityName);
      final forecast = await _apiService.getForecast(cityName);
      emit(WeatherAndForecastLoaded(
        weather: weather,
        forecast: forecast,
      ));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
}
import '../../models/weather_model.dart';


abstract class WeatherState {}


class WeatherInitial extends WeatherState {}


class WeatherLoading extends WeatherState {}


class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  WeatherLoaded({required this.weather});
}


class ForecastLoaded extends WeatherState {
  final List<Map<String, dynamic>> forecast;

  ForecastLoaded({required this.forecast});
}


class WeatherError extends WeatherState {
  final String message;

  WeatherError({required this.message});
}


class WeatherAndForecastLoaded extends WeatherState {
  final WeatherModel weather;
  final List<Map<String, dynamic>> forecast;

  WeatherAndForecastLoaded({
    required this.weather,
    required this.forecast,
  });
}
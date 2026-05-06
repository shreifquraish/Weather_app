class WeatherModel {
  final String cityName;
  final double temp;
  final double feelsLike;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;

  WeatherModel({
    required this.cityName,
    required this.temp,
    required this.feelsLike,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, String cityName) {

    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return WeatherModel(
      cityName: cityName,
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '01d',
      humidity: main['humidity'] ?? 0,
      windSpeed: (wind['speed'] as num).toDouble(),
      pressure: main['pressure'] ?? 0,
      visibility: (json['visibility'] ?? 0) ~/ 1000,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temp': temp,
      'feelsLike': feelsLike,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'visibility': visibility,
    };
  }
}
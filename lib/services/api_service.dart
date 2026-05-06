import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';
import '../models/weather_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );


  Future<WeatherModel> getCurrentWeather(String cityName) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'q': cityName,
          'appid': AppConstants.apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data, cityName);
      } else {
        throw Exception('فشل في جلب بيانات الطقس');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('API Key غير صالحة');
      } else if (e.response?.statusCode == 404) {
        throw Exception('المدينة غير موجودة');
      } else {
        throw Exception('خطأ في الاتصال: ${e.message}');
      }
    }
  }


  Future<List<Map<String, dynamic>>> getForecast(String cityName) async {
    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'q': cityName,
          'appid': AppConstants.apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['list'];
        List<Map<String, dynamic>> dailyForecast = [];
        for (int i = 0; i < 5; i++) {
          dailyForecast.add(list[i * 8]);
        }
        return dailyForecast;
      } else {
        throw Exception('فشل في جلب التوقعات');
      }
    } on DioException catch (e) {
      throw Exception('خطأ في جلب التوقعات: ${e.message}');
    }
  }
}
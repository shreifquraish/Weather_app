import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/utils/helpers.dart';

class ForecastScreen extends StatefulWidget {
  final String cityName;

  const ForecastScreen({
    super.key,
    required this.cityName,
  });

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late ApiService _apiService;
  List<Map<String, dynamic>> _forecast = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _loadForecast();
  }

  Future<void> _loadForecast() async {
    try {
      final forecast = await _apiService.getForecast(widget.cityName);
      setState(() {
        _forecast = forecast;
      });
    } catch (e) {
      print('Error loading forecast: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('توقعات ${widget.cityName}'),
        centerTitle: true,
      ),
      body: _forecast.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _forecast.length,
              itemBuilder: (context, index) {
                final data = _forecast[index];
                

                final main = data['main'];
                final weather = data['weather'][0];
                

                final maxTemp = (main['temp_max'] as num).toDouble();
                final minTemp = (main['temp_min'] as num).toDouble();
                final description = weather['description'] ?? '';
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Helpers.getDayName(index),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getWeatherName(description),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Text(
                            _getIconForWeather(description),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${maxTemp.round()}°',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${minTemp.round()}°',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _getIconForWeather(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear') || desc.contains('sun')) return '☀️';
    if (desc.contains('cloud') && desc.contains('few')) return '🌤️';
    if (desc.contains('cloud')) return '☁️';
    if (desc.contains('rain')) return '🌧️';
    return '🌤️';
  }

  String _getWeatherName(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('clear') || desc.contains('sun')) return 'Sunny';
    if (desc.contains('cloud') && desc.contains('few')) return 'Partly Cloudy';
    if (desc.contains('cloud')) return 'Cloudy';
    if (desc.contains('rain')) return 'Rainy';
    return 'Partly Cloudy';
  }
}
import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../core/utils/helpers.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.lightBlue],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [

            Text(
              weather.cityName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              Helpers.getCurrentDate(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.cloud,
                      size: 60,
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  Helpers.formatTemp(weather.temp),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              weather.description,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Feels like ${Helpers.formatTemp(weather.feelsLike)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
            const Divider(color: Colors.white30, height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.air,
                  label: 'الرياح',
                  value: '${weather.windSpeed} km/h',
                ),
                _buildDetailItem(
                  icon: Icons.water_drop,
                  label: 'الرطوبة',
                  value: '${weather.humidity}%',
                ),
                _buildDetailItem(
                  icon: Icons.remove_red_eye,
                  label: 'الرؤية',
                  value: '${weather.visibility} km',
                ),
                _buildDetailItem(
                  icon: Icons.speed,
                  label: 'الضغط',
                  value: '${weather.pressure} mb',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
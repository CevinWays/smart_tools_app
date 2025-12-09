import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_tools_app/features/weather/domain/entities/weather_entity.dart';

class WeatherDetailScreen extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherDetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Weather Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCurrentWeather(),
            const SizedBox(height: 24),
            _buildGridDetails(),
            const SizedBox(height: 24),
            _buildHourlyForecast(),
            const SizedBox(height: 24),
            _buildDailyForecast(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            _getWeatherIcon(weather.currentWeatherCode),
            size: 80,
            color: Colors.blue.shade800,
          ),
          const SizedBox(height: 16),
          Text(
            '${weather.currentTemp.toStringAsFixed(1)}°C',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          Text(
            _getWeatherDescription(weather.currentWeatherCode),
            style: TextStyle(fontSize: 24, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildGridDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildDetailItem(
            Icons.water_drop,
            'Humidity',
            '${weather.humidity}%',
          ),
          _buildDetailItem(Icons.air, 'Wind', '${weather.windSpeed} km/h'),
          if (weather.aqi != null)
            _buildDetailItem(
              Icons.masks,
              'AQI',
              '${weather.aqi!.toStringAsFixed(0)}',
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Hourly Forecast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: weather.hourly.length,
            itemBuilder: (context, index) {
              final forecast = weather.hourly[index];
              return Container(
                width: 70,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(forecast.time),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Icon(_getWeatherIcon(forecast.weatherCode), size: 24),
                    const SizedBox(height: 8),
                    Text(
                      '${forecast.temp.toStringAsFixed(0)}°',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Daily Forecast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: weather.daily.length,
          itemBuilder: (context, index) {
            final forecast = weather.daily[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE').format(forecast.time),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(_getWeatherIcon(forecast.weatherCode), size: 24),
                      const SizedBox(width: 16),
                      Text(
                        '${forecast.temp.toStringAsFixed(0)}° / ${forecast.minTemp?.toStringAsFixed(0)}°',
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _getWeatherDescription(int code) {
    if (code == 0) return 'Clear Sky';
    if (code >= 1 && code <= 3) return 'Partly Cloudy';
    if (code >= 45 && code <= 48) return 'Foggy';
    if (code >= 51 && code <= 67) return 'Rainy';
    if (code >= 71 && code <= 77) return 'Snowy';
    if (code >= 80 && code <= 82) return 'Rain Showers';
    if (code >= 95 && code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code >= 1 && code <= 3) return Icons.cloud;
    if (code >= 45 && code <= 48) return Icons.cloud_queue;
    if (code >= 51 && code <= 67) return Icons.grain;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 80 && code <= 82) return Icons.umbrella;
    if (code >= 95 && code <= 99) return Icons.flash_on;
    return Icons.help_outline;
  }
}

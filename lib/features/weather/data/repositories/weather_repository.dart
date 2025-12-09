import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_tools_app/features/weather/data/models/weather_model.dart';

class WeatherRepository {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _aqiUrl =
      'https://air-quality-api.open-meteo.com/v1/air-quality';

  Future<WeatherModel> fetchWeather(double lat, double lng) async {
    try {
      // Fetch Weather Data
      final weatherResponse = await http.get(
        Uri.parse(
          '$_baseUrl?latitude=$lat&longitude=$lng&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,wind_direction_10m&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto',
        ),
      );

      if (weatherResponse.statusCode != 200) {
        throw Exception('Failed to load weather data');
      }

      // Fetch AQI Data (Optional, but requested)
      double? aqi;
      try {
        final aqiResponse = await http.get(
          Uri.parse('$_aqiUrl?latitude=$lat&longitude=$lng&current=us_aqi'),
        );
        if (aqiResponse.statusCode == 200) {
          final aqiJson = jsonDecode(aqiResponse.body);
          aqi = (aqiJson['current']['us_aqi'] as num).toDouble();
        }
      } catch (_) {
        // Ignore AQI errors, it's secondary
      }

      final weatherJson = jsonDecode(weatherResponse.body);
      return WeatherModel.fromJson(weatherJson, aqi: aqi);
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}

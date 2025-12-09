class WeatherModel {
  final double currentTemp;
  final int currentWeatherCode;
  final double windSpeed;
  final int windDirection;
  final int humidity;
  final List<HourlyForecast> hourlyForecasts;
  final List<DailyForecast> dailyForecasts;
  final double? aqi; // Air Quality Index

  WeatherModel({
    required this.currentTemp,
    required this.currentWeatherCode,
    required this.windSpeed,
    required this.windDirection,
    required this.humidity,
    required this.hourlyForecasts,
    required this.dailyForecasts,
    this.aqi,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, {double? aqi}) {
    final current = json['current'];
    final hourly = json['hourly'];
    final daily = json['daily'];

    List<HourlyForecast> hourlyList = [];
    if (hourly != null) {
      final times = hourly['time'] as List;
      final temps = hourly['temperature_2m'] as List;
      final codes = hourly['weather_code'] as List;

      // Take next 24 hours
      for (int i = 0; i < times.length && i < 24; i++) {
        hourlyList.add(
          HourlyForecast(
            time: DateTime.parse(times[i]),
            temp: (temps[i] as num).toDouble(),
            weatherCode: codes[i] as int,
          ),
        );
      }
    }

    List<DailyForecast> dailyList = [];
    if (daily != null) {
      final times = daily['time'] as List;
      final maxTemps = daily['temperature_2m_max'] as List;
      final minTemps = daily['temperature_2m_min'] as List;
      final codes = daily['weather_code'] as List;

      // Take next 3 days
      for (int i = 0; i < times.length && i < 3; i++) {
        dailyList.add(
          DailyForecast(
            date: DateTime.parse(times[i]),
            maxTemp: (maxTemps[i] as num).toDouble(),
            minTemp: (minTemps[i] as num).toDouble(),
            weatherCode: codes[i] as int,
          ),
        );
      }
    }

    return WeatherModel(
      currentTemp: (current['temperature_2m'] as num).toDouble(),
      currentWeatherCode: current['weather_code'] as int,
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      windDirection: current['wind_direction_10m'] as int,
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      hourlyForecasts: hourlyList,
      dailyForecasts: dailyList,
      aqi: aqi,
    );
  }
}

class HourlyForecast {
  final DateTime time;
  final double temp;
  final int weatherCode;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.weatherCode,
  });
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });
}

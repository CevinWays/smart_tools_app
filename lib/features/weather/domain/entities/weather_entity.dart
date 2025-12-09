class WeatherEntity {
  final double currentTemp;
  final int currentWeatherCode;
  final double windSpeed;
  final int humidity;
  final double? aqi;
  final List<WeatherForecast> hourly;
  final List<WeatherForecast> daily;

  WeatherEntity({
    required this.currentTemp,
    required this.currentWeatherCode,
    required this.windSpeed,
    required this.humidity,
    this.aqi,
    required this.hourly,
    required this.daily,
  });
}

class WeatherForecast {
  final DateTime time;
  final double temp; // For daily, this can be max temp
  final double? minTemp; // Only for daily
  final int weatherCode;

  WeatherForecast({
    required this.time,
    required this.temp,
    this.minTemp,
    required this.weatherCode,
  });
}

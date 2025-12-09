import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tools_app/features/weather/data/repositories/weather_repository.dart';
import 'package:smart_tools_app/features/weather/domain/entities/weather_entity.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _repository;

  WeatherCubit(this._repository) : super(WeatherInitial());

  Future<void> fetchWeather(double lat, double lng) async {
    emit(WeatherLoading());
    try {
      final model = await _repository.fetchWeather(lat, lng);

      // Map Model to Entity
      final entity = WeatherEntity(
        currentTemp: model.currentTemp,
        currentWeatherCode: model.currentWeatherCode,
        windSpeed: model.windSpeed,
        humidity: model.humidity,
        aqi: model.aqi,
        hourly: model.hourlyForecasts
            .map(
              (e) => WeatherForecast(
                time: e.time,
                temp: e.temp,
                weatherCode: e.weatherCode,
              ),
            )
            .toList(),
        daily: model.dailyForecasts
            .map(
              (e) => WeatherForecast(
                time: e.date,
                temp: e.maxTemp,
                minTemp: e.minTemp,
                weatherCode: e.weatherCode,
              ),
            )
            .toList(),
      );

      emit(WeatherLoaded(entity));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}

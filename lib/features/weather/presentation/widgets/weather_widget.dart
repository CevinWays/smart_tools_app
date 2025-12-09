import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_tools_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:smart_tools_app/features/weather/presentation/cubit/weather_state.dart';

class WeatherWidget extends StatelessWidget {
  final String? locationName;

  const WeatherWidget({super.key, this.locationName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          return GestureDetector(
            onTap: () => context.push(
              '/weather',
              extra: {'weather': state.weather, 'location': locationName},
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getWeatherIcon(state.weather.currentWeatherCode),
                    size: 24,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${state.weather.currentTemp.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getWeatherDescription(state.weather.currentWeatherCode),
                    style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
                  ),
                  if (locationName != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.blue.shade200,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        locationName!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        } else if (state is WeatherError) {
          return const SizedBox.shrink(); // Hide on error
        }
        return const SizedBox.shrink();
      },
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

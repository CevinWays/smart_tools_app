import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

enum HomeStatus { initial, loading, loaded, error, panic }

class HomeState extends Equatable {
  final HomeStatus status;
  final Position? position;
  final Placemark? placemark;
  final String? errorMessage;
  final bool isFlashlightOn;
  final bool isPanicActive;

  const HomeState({
    this.status = HomeStatus.initial,
    this.position,
    this.placemark,
    this.errorMessage,
    this.isFlashlightOn = false,
    this.isPanicActive = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    Position? position,
    Placemark? placemark,
    String? errorMessage,
    bool? isFlashlightOn,
    bool? isPanicActive,
  }) {
    return HomeState(
      status: status ?? this.status,
      position: position ?? this.position,
      placemark: placemark ?? this.placemark,
      errorMessage: errorMessage ?? this.errorMessage,
      isFlashlightOn: isFlashlightOn ?? this.isFlashlightOn,
      isPanicActive: isPanicActive ?? this.isPanicActive,
    );
  }

  @override
  List<Object?> get props => [
    status,
    position,
    placemark,
    errorMessage,
    isFlashlightOn,
    isPanicActive,
  ];
}

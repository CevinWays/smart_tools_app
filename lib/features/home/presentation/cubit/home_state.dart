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
  final bool isSOSCountdownActive;
  final int sosCountdownValue;

  const HomeState({
    this.status = HomeStatus.initial,
    this.position,
    this.placemark,
    this.errorMessage,
    this.isFlashlightOn = false,
    this.isPanicActive = false,
    this.isSOSCountdownActive = false,
    this.sosCountdownValue = 3,
  });

  HomeState copyWith({
    HomeStatus? status,
    Position? position,
    Placemark? placemark,
    String? errorMessage,
    bool? isFlashlightOn,
    bool? isPanicActive,
    bool? isSOSCountdownActive,
    int? sosCountdownValue,
  }) {
    return HomeState(
      status: status ?? this.status,
      position: position ?? this.position,
      placemark: placemark ?? this.placemark,
      errorMessage: errorMessage ?? this.errorMessage,
      isFlashlightOn: isFlashlightOn ?? this.isFlashlightOn,
      isPanicActive: isPanicActive ?? this.isPanicActive,
      isSOSCountdownActive: isSOSCountdownActive ?? this.isSOSCountdownActive,
      sosCountdownValue: sosCountdownValue ?? this.sosCountdownValue,
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
    isSOSCountdownActive,
    sosCountdownValue,
  ];
}

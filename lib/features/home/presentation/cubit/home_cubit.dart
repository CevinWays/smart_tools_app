import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share_plus/share_plus.dart';
import 'package:torch_light/torch_light.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  StreamSubscription<Position>? _positionStreamSubscription;

  HomeCubit() : super(const HomeState());

  Future<void> initLocation() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: 'Location services are disabled.',
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              status: HomeStatus.error,
              errorMessage: 'Location permissions are denied',
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: 'Location permissions are permanently denied',
          ),
        );
        return;
      }

      _startLocationUpdates();
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _startLocationUpdates() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _updateAddress(position);
            emit(state.copyWith(status: HomeStatus.loaded, position: position));
          },
          onError: (e) {
            emit(
              state.copyWith(
                status: HomeStatus.error,
                errorMessage: e.toString(),
              ),
            );
          },
        );
  }

  Future<void> _updateAddress(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        emit(state.copyWith(placemark: placemarks.first));
      }
    } catch (_) {
      // Ignore geocoding errors for now
    }
  }

  Future<void> toggleFlashlight() async {
    try {
      if (state.isFlashlightOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      emit(state.copyWith(isFlashlightOn: !state.isFlashlightOn));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Could not toggle flashlight: $e'));
    }
  }

  void setPanicActive(bool isActive) {
    emit(state.copyWith(isPanicActive: isActive));
  }

  Future<void> shareLocation() async {
    if (state.position == null) return;
    final url =
        'https://www.google.com/maps/search/?api=1&query=${state.position!.latitude},${state.position!.longitude}';
    await Share.share('SOS! I need help. My location: $url');
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share_plus/share_plus.dart';
import 'package:torch_light/torch_light.dart';
import 'package:smart_tools_app/features/profile/data/repositories/profile_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _sosTimer;
  final ProfileRepository _profileRepository;

  HomeCubit(this._profileRepository) : super(const HomeState());

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

  void startSOSCountdown() {
    if (state.isSOSCountdownActive) return;

    emit(state.copyWith(isSOSCountdownActive: true, sosCountdownValue: 3));

    _sosTimer?.cancel();
    _sosTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.sosCountdownValue > 1) {
        emit(state.copyWith(sosCountdownValue: state.sosCountdownValue - 1));
      } else {
        timer.cancel();
        triggerSOS();
      }
    });
  }

  void cancelSOSCountdown() {
    _sosTimer?.cancel();
    emit(state.copyWith(isSOSCountdownActive: false, sosCountdownValue: 3));
  }

  Future<void> triggerSOS() async {
    cancelSOSCountdown(); // Reset UI
    // In a real app, this would send SMS, call API, etc.
    // For now, we'll just share location as a proxy for "sending alerts"
    // and maybe emit a specific status if we want the UI to show a snackbar.
    // However, the UI currently shows a snackbar on long press.
    // We should probably move that responsibility here or let the UI listen to a state change.
    // Let's use the errorMessage field for now to trigger a snackbar, or better, add a 'sosTriggered' status?
    // The current HomeState has a 'panic' status. Let's use that.
    emit(state.copyWith(status: HomeStatus.panic));

    // Also share location automatically?
    // The requirement says "Call, share, and record automatically" in the image,
    // but the text prompt just says "enhance tombol sos agar tidak menciptakan false alarm".
    // I will keep it simple: just trigger the "panic" state which the UI can react to.
    shareLocation();
  }

  Future<void> shareLocation() async {
    if (state.position == null) return;

    final url =
        'https://www.google.com/maps/search/?api=1&query=${state.position!.latitude},${state.position!.longitude}';

    final StringBuffer message = StringBuffer();
    message.writeln('SOS! Saya Butuh Bantuan. Lokasi Saya: $url');

    try {
      final profile = await _profileRepository.getUserProfile();
      if (profile != null) {
        message.writeln('\n--- DATA DIRI ---');
        message.writeln('Nama: ${profile.name}');
        message.writeln('Golongan Darah: ${profile.bloodType}');
        message.writeln('Kontak Darurat: ${profile.emergencyContact}');

        if (profile.medicalHistory.isNotEmpty) {
          message.writeln('Riwayat Medis: ${profile.medicalHistory}');
        }
        if (profile.allergies.isNotEmpty) {
          message.writeln('Alergi: ${profile.allergies}');
        }
        if (profile.routineMedication.isNotEmpty) {
          message.writeln('Obat Rutin: ${profile.routineMedication}');
        }
        if (profile.specialNotes.isNotEmpty) {
          message.writeln('Catatan Khusus: ${profile.specialNotes}');
        }
      }
    } catch (e) {
      // Ignore profile fetch errors, just send location
    }

    await Share.share(message.toString());
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    _sosTimer?.cancel();
    return super.close();
  }
}

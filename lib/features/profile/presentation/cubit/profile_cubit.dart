import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tools_app/features/profile/data/repositories/profile_repository.dart';
import 'package:smart_tools_app/features/profile/domain/entities/user_profile.dart';
import 'package:smart_tools_app/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _repository.getUserProfile();
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileEmpty());
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    emit(ProfileLoading());
    try {
      await _repository.saveUserProfile(profile);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

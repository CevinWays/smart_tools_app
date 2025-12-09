import 'package:hive/hive.dart';
import 'package:smart_tools_app/features/profile/domain/entities/user_profile.dart';

class ProfileRepository {
  static const String _boxName = 'user_profile_box';
  static const String _profileKey = 'user_profile';

  Future<Box<UserProfile>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<UserProfile>(_boxName);
    }
    return Hive.box<UserProfile>(_boxName);
  }

  Future<UserProfile?> getUserProfile() async {
    final box = await _openBox();
    return box.get(_profileKey);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final box = await _openBox();
    await box.put(_profileKey, profile);
  }
}

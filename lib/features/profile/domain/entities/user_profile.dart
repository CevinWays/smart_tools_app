import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime? dob;

  @HiveField(2)
  final String gender;

  @HiveField(3)
  final String emergencyContact;

  @HiveField(4)
  final String medicalHistory;

  @HiveField(5)
  final String allergies;

  @HiveField(6)
  final String bloodType;

  @HiveField(7)
  final String routineMedication;

  @HiveField(8)
  final String specialNotes;

  UserProfile({
    required this.name,
    this.dob,
    required this.gender,
    required this.emergencyContact,
    required this.medicalHistory,
    required this.allergies,
    required this.bloodType,
    required this.routineMedication,
    required this.specialNotes,
  });

  UserProfile copyWith({
    String? name,
    DateTime? dob,
    String? gender,
    String? emergencyContact,
    String? medicalHistory,
    String? allergies,
    String? bloodType,
    String? routineMedication,
    String? specialNotes,
  }) {
    return UserProfile(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      bloodType: bloodType ?? this.bloodType,
      routineMedication: routineMedication ?? this.routineMedication,
      specialNotes: specialNotes ?? this.specialNotes,
    );
  }
}

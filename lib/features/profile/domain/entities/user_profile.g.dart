// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 1;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      name: fields[0] as String,
      dob: fields[1] as DateTime?,
      gender: fields[2] as String,
      emergencyContact: fields[3] as String,
      medicalHistory: fields[4] as String,
      allergies: fields[5] as String,
      bloodType: fields[6] as String,
      routineMedication: fields[7] as String,
      specialNotes: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dob)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.emergencyContact)
      ..writeByte(4)
      ..write(obj.medicalHistory)
      ..writeByte(5)
      ..write(obj.allergies)
      ..writeByte(6)
      ..write(obj.bloodType)
      ..writeByte(7)
      ..write(obj.routineMedication)
      ..writeByte(8)
      ..write(obj.specialNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

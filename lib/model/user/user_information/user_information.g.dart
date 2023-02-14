// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInformationAdapter extends TypeAdapter<UserInformation> {
  @override
  final int typeId = 4;

  @override
  UserInformation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInformation(
      id: fields[0] as String?,
      companyId: fields[1] as String?,
      firstname: fields[2] as String?,
      lastname: fields[3] as String?,
      username: fields[4] as String?,
      language: fields[5] as String?,
      deviceUuid: fields[6] as String?,
      deviceType: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInformation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.firstname)
      ..writeByte(3)
      ..write(obj.lastname)
      ..writeByte(4)
      ..write(obj.username)
      ..writeByte(5)
      ..write(obj.language)
      ..writeByte(6)
      ..write(obj.deviceUuid)
      ..writeByte(7)
      ..write(obj.deviceType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInformationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

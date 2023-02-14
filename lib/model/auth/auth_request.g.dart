// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthRequestAdapter extends TypeAdapter<AuthRequest> {
  @override
  final int typeId = 2;

  @override
  AuthRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthRequest(
      username: fields[0] as String?,
      password: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthRequest obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

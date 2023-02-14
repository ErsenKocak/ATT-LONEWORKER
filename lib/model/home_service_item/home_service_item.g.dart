// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_service_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeServiceItemAdapter extends TypeAdapter<HomeServiceItem> {
  @override
  final int typeId = 5;

  @override
  HomeServiceItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeServiceItem(
      id: fields[5] as int?,
      title: fields[0] as String?,
      iconCode: fields[1] as int?,
      navigateScreen: fields[3] as String?,
      isSelected: fields[4] as bool?,
      iconColorValue: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HomeServiceItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.iconCode)
      ..writeByte(2)
      ..write(obj.iconColorValue)
      ..writeByte(3)
      ..write(obj.navigateScreen)
      ..writeByte(4)
      ..write(obj.isSelected)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeServiceItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

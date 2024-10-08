// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeStateAdapter extends TypeAdapter<ThemeState> {
  @override
  final int typeId = 0;

  @override
  ThemeState read(final BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeState(
      isLightMode: fields[0] as bool,
      color: fields[1] as int,
    );
  }

  @override
  void write(final BinaryWriter writer, final ThemeState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isLightMode)
      ..writeByte(1)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is ThemeStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

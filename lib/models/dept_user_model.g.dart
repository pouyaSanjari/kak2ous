// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dept_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeptUserModelAdapter extends TypeAdapter<DeptUserModel> {
  @override
  final int typeId = 3;

  @override
  DeptUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeptUserModel(
      fields[0] as String,
      (fields[1] as List).cast<int>(),
      (fields[2] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, DeptUserModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.depts)
      ..writeByte(2)
      ..write(obj.payments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeptUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

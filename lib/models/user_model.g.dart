// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      systemNumber: fields[3] as String,
      startTime: fields[0] as String,
      endTime: fields[1] as String,
      excessCosts: (fields[2] as List).cast<ExcessCostsModel>(),
      price: fields[4] as int,
      isEnded: fields[5] as bool,
      descripstions: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.excessCosts)
      ..writeByte(3)
      ..write(obj.systemNumber)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.isEnded)
      ..writeByte(6)
      ..write(obj.descripstions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

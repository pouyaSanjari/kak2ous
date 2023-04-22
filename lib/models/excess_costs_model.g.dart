// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excess_costs_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExcessCostsModelAdapter extends TypeAdapter<ExcessCostsModel> {
  @override
  final int typeId = 2;

  @override
  ExcessCostsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExcessCostsModel(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ExcessCostsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExcessCostsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

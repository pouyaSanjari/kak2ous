import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimeAdapter extends TypeAdapter<TimeOfDay> {
  @override
  read(BinaryReader reader) {
    return TimeOfDay.now();
    // TODO: implement read
  }

  @override
  // TODO: implement typeId
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, obj) {
    // TODO: implement write
  }
}

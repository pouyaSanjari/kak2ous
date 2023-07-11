import 'package:hive_flutter/hive_flutter.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String startTime;
  @HiveField(1)
  final String endTime;
  @HiveField(2)
  final List<ExcessCostsModel> excessCosts;
  @HiveField(3)
  final String systemNumber;
  @HiveField(4)
  final int price;
  @HiveField(5)
  final bool isEnded;
  @HiveField(6)
  final String descripstions;
  UserModel({
    required this.systemNumber,
    required this.startTime,
    required this.endTime,
    required this.excessCosts,
    required this.price,
    required this.isEnded,
    required this.descripstions,
  });
}

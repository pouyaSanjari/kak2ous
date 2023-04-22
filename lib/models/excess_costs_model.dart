import 'package:hive/hive.dart';
part 'excess_costs_model.g.dart';

@HiveType(typeId: 2)
class ExcessCostsModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int price;

  ExcessCostsModel(this.name, this.price);
}

import 'package:hive/hive.dart';
part 'dept_user_model.g.dart';

@HiveType(typeId: 3)
class DeptUserModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final List<int> depts;
  @HiveField(2)
  final List<int> payments;

  DeptUserModel(this.name, this.depts, this.payments);
}

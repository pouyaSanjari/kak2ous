import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kak2ous/models/dept_user_model.dart';

class DeptBookController extends GetxController {
  RxList<DeptUserModel> depts = <DeptUserModel>[].obs;

  void readData() async {
    depts.value = [];
    var box = await Hive.openBox<DeptUserModel>('deptBook');
    for (var i = 0; i < box.length; i++) {
      depts.add(box.values.elementAt(i));
    }
  }

  void addNewDept(DeptUserModel deptBook) async {
    var box = await Hive.openBox<DeptUserModel>('deptBook');
    box.add(deptBook);
    readData();
  }

  void deleteDept(int index) async {
    var box = await Hive.openBox<DeptUserModel>('deptBook');
    box.deleteAt(index);
    readData();
  }

  void updateData(int index, DeptUserModel data) async {
    var box = await Hive.openBox<DeptUserModel>('deptBook');
    box.putAt(index, data);
    readData();
  }
}

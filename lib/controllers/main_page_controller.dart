import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kak2ous/components/my_row.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/models/user_model.dart';

class MainPageController extends GetxController {
  RxList<MyRow> items = <MyRow>[].obs;
  RxList<ExcessCostsModel> excessCostsList = <ExcessCostsModel>[].obs;
  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  void loadData() async {
    items.value = [];
    var box = await Hive.openBox<UserModel>('userModel');
    for (var i = 0; i < box.values.length; i++) {
      MyRow row = MyRow(
        indx: i,
        startTime: box.values.elementAt(i).startTime,
        endTime: box.values.elementAt(i).endTime,
        excessCosts: box.values.elementAt(i).excessCosts,
        systemNumber: box.values.elementAt(i).systemNumber,
        price: box.values.elementAt(i).price,
      );
      items.add(row);
    }
  }

  void getExcessCosts(int index) async {
    var box = await Hive.openBox<UserModel>('userModel');
    List<ExcessCostsModel> excessCosts = [];
    if (box.values.elementAt(index).excessCosts.isNotEmpty) {
      for (var element in box.values.elementAt(index).excessCosts) {
        excessCosts.add(element);
      }
    }
    excessCostsList.value = excessCosts;
  }

  void updateData(int index, UserModel data) async {
    var box = await Hive.openBox<UserModel>('userModel');
    box.putAt(index, data);
    loadData();
  }

  addItem(
      {required String startTime,
      required String endTime,
      required String systemNumber,
      required List<ExcessCostsModel> excessCosts,
      required int price}) async {
    var box = await Hive.openBox<UserModel>('userModel');
    box.add(UserModel(
        systemNumber: systemNumber,
        startTime: startTime,
        endTime: endTime,
        excessCosts: excessCosts,
        price: price));
    loadData();
  }

  void deleteItem(int index) async {
    var box = await Hive.openBox<UserModel>('userModel');
    box.deleteAt(index);
    loadData();
  }
}

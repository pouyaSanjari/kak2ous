import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kak2ous/controllers/main_page_controller.dart';
import 'package:kak2ous/models/excess_costs_model.dart';

class ExcessCostsController extends GetxController {
  RxList<ExcessCostsModel> items = <ExcessCostsModel>[].obs;
  final mainController = Get.put(MainPageController());
  @override
  void onInit() {
    getItems();
    super.onInit();
  }

  void getItems() async {
    items.value = [];
    var box = await Hive.openBox<ExcessCostsModel>('excessCosts');
    for (var element in box.values) {
      items.add(element);
    }
  }

  void addItem(String name, int price) async {
    var box = await Hive.openBox<ExcessCostsModel>('excessCosts');
    box.add(ExcessCostsModel(name, price));
    getItems();
  }

  void editItem(int index) {}
  void deleteItem(int index) async {
    var box = await Hive.openBox<ExcessCostsModel>('excessCosts');
    box.deleteAt(index);
    getItems();
  }
}

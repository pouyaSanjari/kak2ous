import 'package:dart_vlc/dart_vlc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:kak2ous/components/my_row.dart';
import 'package:kak2ous/components/user_details.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/models/user_model.dart';

class MainPageController extends GetxController {
  RxList<MyRow> items = <MyRow>[].obs;
  RxList<UserDetails> startedItems = <UserDetails>[].obs;
  RxList<UserDetails> notStartedItems = <UserDetails>[].obs;
  RxList<UserDetails> endedItems = <UserDetails>[].obs;
  RxList<ExcessCostsModel> excessCostsList = <ExcessCostsModel>[].obs;
  RxMap<String, bool> isEnded = <String, bool>{}.obs;
  final player = Player(id: 69420);
  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  playAudio(String systemNumber) {
    final asset = Media.asset('assets/sounds/systemN$systemNumber.wav');

    player.open(asset);
  }

  void loadData() async {
    items.value = [];
    startedItems.value = [];
    notStartedItems.value = [];
    endedItems.value = [];
    isEnded.value = {};
    var box = await Hive.openBox<UserModel>('userModel');
    for (var i = 0; i < box.values.length; i++) {
      isEnded.addAll({box.values.elementAt(i).systemNumber: false});
      MyRow row = MyRow(
        indx: i,
        startTime: box.values.elementAt(i).startTime,
        endTime: box.values.elementAt(i).endTime,
        excessCosts: box.values.elementAt(i).excessCosts,
        systemNumber: box.values.elementAt(i).systemNumber,
        price: box.values.elementAt(i).price,
        isEnded: box.values.elementAt(i).isEnded,
        descriptions: box.values.elementAt(i).descripstions,
      );
      UserDetails userDetails = UserDetails(
        indx: i,
        startTime: box.values.elementAt(i).startTime,
        endTime: box.values.elementAt(i).endTime,
        excessCosts: box.values.elementAt(i).excessCosts,
        systemNumber: box.values.elementAt(i).systemNumber,
        price: box.values.elementAt(i).price,
        isEnded: box.values.elementAt(i).isEnded,
        descriptions: box.values.elementAt(i).descripstions,
      );
      items.add(row);
      bool isStarted =
          DateTime.now().isAfter(DateTime.parse(userDetails.startTime));
      bool isEndedItem =
          DateTime.now().isAfter(DateTime.parse(userDetails.endTime));
      if (isStarted && !isEndedItem) {
        startedItems.add(userDetails);
      } else if (!isStarted) {
        notStartedItems.add(userDetails);
      } else {
        endedItems.add(userDetails);
      }
    }
    items.sort(
      (a, b) => a.systemNumber.compareTo(b.systemNumber),
    );
    startedItems.sort(
      (a, b) => a.systemNumber.compareTo(b.systemNumber),
    );
    notStartedItems.sort(
      (a, b) => a.systemNumber.compareTo(b.systemNumber),
    );
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
      required int price,
      required String descriptions}) async {
    var box = await Hive.openBox<UserModel>('userModel');
    var isInfinitTime = startTime == endTime ? true : false;
    box.add(UserModel(
        systemNumber: systemNumber,
        startTime: startTime,
        endTime: endTime,
        excessCosts: excessCosts,
        price: price,
        isEnded: isInfinitTime,
        descripstions: descriptions));

    loadData();
  }

  void deleteItem(int index) async {
    var box = await Hive.openBox<UserModel>('userModel');
    box.deleteAt(index);

    loadData();
  }
}

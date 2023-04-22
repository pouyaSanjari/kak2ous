import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kak2ous/components/my_text_field.dart';
import 'package:kak2ous/controllers/excess_costs_controller.dart';
import 'package:kak2ous/controllers/main_page_controller.dart';
import 'package:kak2ous/controllers/my_row_controller.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/models/user_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class MyRow extends StatefulWidget {
  const MyRow({
    super.key,
    required this.indx,
    required this.startTime,
    required this.endTime,
    required this.excessCosts,
    required this.systemNumber,
    required this.price,
  });
  final int indx;
  final String startTime;
  final String endTime;
  final List<ExcessCostsModel> excessCosts;
  final String systemNumber;
  final int price;

  @override
  State<MyRow> createState() => _MyRowState();
}

class _MyRowState extends State<MyRow> {
  final mainController = Get.put(MainPageController());
  final excessController = Get.put(ExcessCostsController());
  final controller = Get.put(MyRowController());
  String totalCost = '';
  String remainTime = '';
  String elapsedTime = '';
  Timer? timer;
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  updateData(ExcessCostsModel excessCostsModel) {
    var currentList = widget.excessCosts;
    List<ExcessCostsModel> newList = [];
    for (var element in currentList) {
      newList.add(element);
    }
    newList.add(excessCostsModel);
    mainController.updateData(
        widget.indx,
        UserModel(
            systemNumber: widget.systemNumber,
            startTime: widget.startTime,
            endTime: widget.endTime,
            excessCosts: newList,
            price: widget.price));
  }

  void checkCosts() {
    List<int> costs = [];
    for (var element in widget.excessCosts) {
      costs.add(element.price);
    }
    var start = DateTime.parse(widget.startTime);
    var end = DateTime.parse(widget.endTime);
    var diff = end.difference(start);
    var diffInMinute = diff.inMinutes;
    double diffInHour = diffInMinute / 60;
    var playCost = diffInHour * widget.price;
    costs.add(playCost.round());
    var sum = costs.reduce((a, b) => a + b);
    setState(() {
      totalCost = sum.toString();
    });
  }

  void checkRemain() {
    var end = DateTime.parse(widget.endTime);
    var start = DateTime.parse(widget.startTime);
    var distanse = end.difference(DateTime.now());
    var elapsed = DateTime.now().difference(start);
    String printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      if (duration > Duration.zero) {
        String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
        return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
      }
      return "00:00:00";
    }

    remainTime = printDuration(distanse);

    elapsedTime = printDuration(elapsed);
    setState(() {});
  }

  @override
  void initState() {
    checkRemain();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        checkRemain();
        checkCosts();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Table(
        border: TableBorder.symmetric(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Center(
              child: Text(widget.systemNumber,
                  style: const TextStyle(fontSize: 25)),
            ),
            Center(
              child: StatefulBuilder(
                builder: (context, setstate) {
                  var start = DateTime.parse(widget.startTime);
                  return Text("${start.hour}:${start.minute}");
                },
              ),
            ),
            Center(
              child: StatefulBuilder(
                builder: (context, setstate) {
                  var end = DateTime.parse(widget.endTime);
                  return Text("${end.hour}:${end.minute}");
                },
              ),
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    addExtraCostDialog(context);
                  },
                  child: const Text('مشاهده')),
            ),
            Center(
                child: InkWell(
                    onTap: () {
                      checkCosts();
                    },
                    child: Text('${totalCost.seRagham()}  تومان'))),
            Center(
                child: Text(
              remainTime,
              style: TextStyle(
                  color: remainTime == '00:00:00' ? Colors.red : Colors.black),
            )),
            Center(
                child: Text(
              elapsedTime,
              style: TextStyle(
                  color: elapsedTime == '00:00:00' ? Colors.red : Colors.black),
            )),
            Center(
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      var hourlyCostController = TextEditingController();
                      hourlyCostController.text = widget.price.toString();
                      controller.editDialogStartTime.value =
                          DateTime.parse(widget.startTime);
                      controller.editDialogEndTime.value =
                          DateTime.parse(widget.endTime);
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(20),
                        title: const Center(child: Text('ویرایش')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('ساعت شروع'),
                            const SizedBox(height: 10),
                            Obx(
                              () => Center(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    DateTime dateTime;
                                    var newTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now());
                                    setState(() {
                                      dateTime = join(DateTime.now(),
                                          newTime ?? TimeOfDay.now());
                                      controller.editDialogStartTime.value =
                                          dateTime;
                                    });
                                  },
                                  child: Text(
                                      '${controller.editDialogStartTime.value.hour}:${controller.editDialogStartTime.value.minute}'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('ساعت اتمام'),
                            const SizedBox(height: 10),
                            Obx(
                              () => Center(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    DateTime dateTime;
                                    var newTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now());
                                    dateTime = join(DateTime.now(),
                                        newTime ?? TimeOfDay.now());
                                    controller.editDialogEndTime.value =
                                        dateTime;
                                  },
                                  child: Text(
                                      '${controller.editDialogEndTime.value.hour}:${controller.editDialogEndTime.value.minute}'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('هزینه هر ساعت(به تومان)'),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: hourlyCostController,
                              isNumber: true,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (hourlyCostController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'هزینه هر ساعت را وارد نکردید')));
                                  return;
                                }
                                mainController.updateData(
                                    widget.indx,
                                    UserModel(
                                      systemNumber: widget.systemNumber,
                                      startTime: controller
                                          .editDialogStartTime.value
                                          .toString(),
                                      endTime: controller
                                          .editDialogEndTime.value
                                          .toString(),
                                      excessCosts: widget.excessCosts,
                                      price:
                                          int.parse(hourlyCostController.text),
                                    ));
                                Navigator.pop(context);
                              },
                              child: const Text('تایید')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('لغو'))
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  deleteItemDialog(context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            )
          ])
        ],
      ),
    );
  }

  Future<dynamic> deleteItemDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: const Text('مطمئنی میخوای حذفش کنی؟'), actions: [
        TextButton(
            onPressed: () {
              mainController.deleteItem(widget.indx);
              Navigator.pop(context);
            },
            child: const Text('آره')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('نه'))
      ]),
    );
  }

  Future<dynamic> addExtraCostDialog(BuildContext context) {
    mainController.getExcessCosts(widget.indx);

    return showDialog(
      context: context,
      builder: (context) {
        ExcessCostsModel selectedItem = ExcessCostsModel('', 0);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            titlePadding: const EdgeInsets.all(20),
            title: const Center(child: Text('هزینه های مازاد')),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: mainController.excessCostsList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Row(children: [
                              Text((index + 1).toString()),
                              const SizedBox(width: 10),
                              Text(mainController.excessCostsList[index].name),
                              const Expanded(child: SizedBox(width: 20)),
                              Text(
                                  'قیمت: ${mainController.excessCostsList[index].price}'),
                              IconButton(
                                  onPressed: () {
                                    deletExtraCost(
                                        deleteItemNumber: index,
                                        rowNumber: widget.indx);
                                    mainController.getExcessCosts(widget.indx);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ]),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    const Text(
                      'محصول/خدمت',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    DropdownSearch(
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          textAlign: TextAlign.center),
                      items: excessController.items,
                      itemAsString: (item) {
                        return item.name;
                      },
                      onChanged: (value) {
                        if (value != null) {
                          selectedItem = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    updateData(selectedItem);
                    mainController.getExcessCosts(widget.indx);
                  },
                  child: const Text('افزودن')),
            ],
          ),
        );
      },
    );
  }

  void deletExtraCost({required int deleteItemNumber, required int rowNumber}) {
    var oldList = widget.excessCosts;
    oldList.removeAt(deleteItemNumber);
    mainController.updateData(
      rowNumber,
      UserModel(
        systemNumber: widget.systemNumber,
        startTime: widget.startTime,
        endTime: widget.endTime,
        excessCosts: oldList,
        price: widget.price,
      ),
    );
  }
}

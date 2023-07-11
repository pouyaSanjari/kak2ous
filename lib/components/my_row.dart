import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kak2ous/components/my_text_field.dart';
import 'package:kak2ous/constants/constants.dart';
import 'package:kak2ous/controllers/excess_costs_controller.dart';
import 'package:kak2ous/controllers/main_page_controller.dart';
import 'package:kak2ous/controllers/my_row_controller.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/models/user_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class MyRow extends StatefulWidget {
  const MyRow(
      {super.key,
      required this.indx,
      required this.startTime,
      required this.endTime,
      required this.excessCosts,
      required this.systemNumber,
      required this.price,
      required this.isEnded,
      required this.descriptions});
  final int indx;
  final String startTime;
  final String endTime;
  final List<ExcessCostsModel> excessCosts;
  final String systemNumber;
  final int price;
  final bool isEnded;
  final String descriptions;

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
  String extraCost = '';

  Timer? timer;
  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void addExcessCost(ExcessCostsModel excessCostsModel) {
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
            price: widget.price,
            isEnded: widget.isEnded,
            descripstions: widget.descriptions));
  }

  void deletExcessCost(
      {required int deleteItemNumber, required int rowNumber}) {
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
          isEnded: widget.isEnded,
          descripstions: widget.descriptions),
    );
  }

  /// هزینه هارو محاسبه میکنه
  void checkCosts() {
    List<int> costs = [];
    for (var element in widget.excessCosts) {
      costs.add(element.price);
    }
    var start = DateTime.parse(widget.startTime);
    var end = DateTime.parse(widget.endTime);
    var totalTime = end.difference(start);
    var elapsedTime = DateTime.now().difference(start);
    double totalInHour = totalTime.inMinutes / 60;
    double elapsedInHour = elapsedTime.inMinutes / 60;
    // double totalInHour = diffInMinute / 60;
    // double elapsedInHour = elapsedInMinute / 60;
    var totalPlayCost = totalInHour * widget.price;
    var extra =
        ((elapsedInHour * widget.price).round() - totalPlayCost.round());
    costs.add(totalPlayCost.round());
    costs.add(extra);

    extraCost = ((elapsedInHour * widget.price).round() - totalPlayCost.round())
        .toString();

    var sum = costs.reduce((a, b) => a + b);

    setState(() {
      totalCost = sum.toString();
    });
  }

  void checkRemain() async {
    var start = DateTime.parse(widget.startTime);
    var end = DateTime.parse(widget.endTime);
    var elapsed = DateTime.now().difference(start);
    var distanse = end.difference(DateTime.now());

    // اگه زمان باقی مونده داشته باشه ولی تمام شده براش ثبت شده باشه
    // یعنی اینکه قبلا تموم شده ولی تمدید کرده
    // پس به عنوان تموم نشده تو دیتابیس تغییرش میدیم
    if (distanse.inSeconds > 0 && widget.isEnded == true) {
      mainController.updateData(
        widget.indx,
        UserModel(
            systemNumber: widget.systemNumber,
            startTime: widget.startTime,
            endTime: widget.endTime,
            excessCosts: widget.excessCosts,
            price: widget.price,
            isEnded: false,
            descripstions: widget.descriptions),
      );
    }
    // اگه زمان باقی مونده اش صفر باشه صدا رو پخش میکنه و تو دیتابیس به عنوان تموم شده
    // ثبتش میکنه
    if (distanse.inSeconds < 0 && widget.isEnded == false) {
      mainController.playAudio(widget.systemNumber);
      mainController.updateData(
        widget.indx,
        UserModel(
            systemNumber: widget.systemNumber,
            startTime: widget.startTime,
            endTime: widget.endTime,
            excessCosts: widget.excessCosts,
            price: widget.price,
            isEnded: true,
            descripstions: widget.descriptions),
      );
    }

    /// این فانکشن زمان رو بصورت ساعت دقیقه و ثانیه خروجی میده
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
    final List<TableRow> portraitList = [
      TableRow(children: [
        Center(
          child: Text(widget.systemNumber,
              style: const TextStyle(fontSize: 25, fontFamily: 'titr')),
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
            child: Text(
          remainTime,
          style: TextStyle(
              color: remainTime == '00:00:00' ? Colors.red : Colors.green),
        )),
        Center(child: Text('${totalCost.seRagham()}  تومان')),
      ])
    ];

    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
        ? true
        : false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Table(
        border: TableBorder.symmetric(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: isPortrait
            ? portraitList
            : [
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
                      child: Text(
                    remainTime,
                    style: TextStyle(
                        color: remainTime == '00:00:00'
                            ? Colors.red
                            : Colors.green),
                  )),
                  Center(
                      child: Text(
                    elapsedTime,
                    style: TextStyle(
                        color: elapsedTime == '00:00:00'
                            ? Colors.red
                            : Colors.black),
                  )),
                  Center(
                      child: Text(
                          '${extraCost.contains('-') ? '0' : extraCost.seRagham()}  تومان')),
                  Center(child: Text('${totalCost.seRagham()}  تومان')),
                  Center(
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            // var hourlyCostController = TextEditingController();
                            var systemNumberController =
                                TextEditingController();
                            // hourlyCostController.text = widget.price.toString();
                            systemNumberController.text =
                                widget.systemNumber.toString();
                            controller.editDialogStartTime.value =
                                DateTime.parse(widget.startTime);
                            controller.editDialogEndTime.value =
                                DateTime.parse(widget.endTime);
                            return AlertDialog(
                              titlePadding: const EdgeInsets.all(0),
                              title: Center(
                                  child: Text(
                                      'ویرایش سیستم شماره ${widget.systemNumber}')),
                              content: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('شماره سیستم'),
                                    const SizedBox(height: 10),
                                    MyTextField(
                                      controller: systemNumberController,
                                      isNumber: true,
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const Text('از ساعت'),
                                                const SizedBox(height: 10),
                                                Obx(
                                                  () => Center(
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        DateTime dateTime;
                                                        var startTime =
                                                            DateTime.parse(
                                                                widget
                                                                    .startTime);

                                                        var newTime = await showTimePicker(
                                                            context: context,
                                                            cancelText: "لغو",
                                                            confirmText:
                                                                'تایید',
                                                            initialEntryMode:
                                                                TimePickerEntryMode
                                                                    .input,
                                                            hourLabelText:
                                                                "ساعت",
                                                            minuteLabelText:
                                                                "دقیقه",
                                                            helpText:
                                                                "ساعت را وارد کنید",
                                                            initialTime: TimeOfDay(
                                                                hour: startTime
                                                                    .hour,
                                                                minute: startTime
                                                                    .minute));
                                                        if (newTime != null) {
                                                          dateTime = join(
                                                              DateTime.now(),
                                                              newTime);
                                                          controller
                                                              .editDialogStartTime
                                                              .value = dateTime;
                                                        }
                                                      },
                                                      child: Text(
                                                          '${controller.editDialogStartTime.value.hour > 12 ? controller.editDialogStartTime.value.hour - 12 : controller.editDialogStartTime.value.hour}:${controller.editDialogStartTime.value.minute}'),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const Text('تا ساعت'),
                                                const SizedBox(height: 10),
                                                Obx(
                                                  () => Center(
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        DateTime dateTime;
                                                        var endTime =
                                                            DateTime.parse(
                                                                widget.endTime);
                                                        var newTime = await showTimePicker(
                                                            context: context,
                                                            cancelText: "لغو",
                                                            confirmText:
                                                                'تایید',
                                                            initialEntryMode:
                                                                TimePickerEntryMode
                                                                    .input,
                                                            hourLabelText:
                                                                "ساعت",
                                                            minuteLabelText:
                                                                "دقیقه",
                                                            helpText:
                                                                "ساعت را وارد کنید",
                                                            initialTime: TimeOfDay(
                                                                hour: endTime
                                                                    .hour,
                                                                minute: endTime
                                                                    .minute));
                                                        if (newTime != null) {
                                                          dateTime = join(
                                                              DateTime.now(),
                                                              newTime);
                                                          controller
                                                              .editDialogEndTime
                                                              .value = dateTime;
                                                        }
                                                      },
                                                      child: Text(
                                                          '${controller.editDialogEndTime.value.hour > 12 ? controller.editDialogEndTime.value.hour - 12 : controller.editDialogEndTime.value.hour}:${controller.editDialogEndTime.value.minute}'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      mainController.updateData(
                                          widget.indx,
                                          UserModel(
                                              systemNumber:
                                                  systemNumberController.text,
                                              startTime: controller
                                                  .editDialogStartTime.value
                                                  .toString(),
                                              endTime: controller
                                                  .editDialogEndTime.value
                                                  .toString(),
                                              excessCosts: widget.excessCosts,
                                              price: Constants.everyHourCost,
                                              isEnded: widget.isEnded,
                                              descripstions:
                                                  widget.descriptions));
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
    final paid = TextEditingController();

    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        ExcessCostsModel selectedItem = ExcessCostsModel('', 0);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            titlePadding: const EdgeInsets.all(20),
            title: Center(
                child:
                    Text('هزینه های مازاد سیستم شماره ${widget.systemNumber}')),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ListView.separated(
                        separatorBuilder: (context, index) =>
                            Divider(color: Colors.deepPurple.withOpacity(0.1)),
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
                                  deletExcessCost(
                                      deleteItemNumber: index,
                                      rowNumber: widget.indx);
                                  mainController.getExcessCosts(widget.indx);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),

                    // const Divider(color: Colors.deepPurple),
                    const Text(
                      'محصول/خدمت',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    DropdownSearch(
                      popupProps: PopupProps.menu(
                          menuProps: MenuProps(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          searchFieldProps: TextFieldProps(
                              autofocus: true,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(40)),
                                  filled: true,
                                  suffixIcon: const Icon(Icons.search),
                                  suffixIconColor: Colors.deepPurple,
                                  fillColor:
                                      Colors.deepPurple.withOpacity(0.1))),
                          showSearchBox: true,
                          searchDelay: Duration.zero),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(40)),
                              filled: true,
                              fillColor: Colors.deepPurple.withOpacity(0.1)),
                          textAlign: TextAlign.center),
                      items: excessController.items,
                      itemAsString: (item) {
                        return item.name;
                      },
                      onChanged: (value) {
                        if (value != null) {
                          selectedItem = value;
                          addExcessCost(selectedItem);
                          mainController.getExcessCosts(widget.indx);
                        }
                      },
                    ),
                    const Text(
                      'مبلغ پرداختی',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: TextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: false),
                              controller: paid,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(40)),
                                  filled: true,
                                  fillColor:
                                      Colors.deepPurple.withOpacity(0.1)),
                            )),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                              onPressed: () {
                                if (paid.text.isNotEmpty) {
                                  var paidAmount = int.parse('-${paid.text}');
                                  addExcessCost(ExcessCostsModel(
                                      ' پرداختی ', paidAmount));
                                  mainController.getExcessCosts(widget.indx);
                                }
                              },
                              child: const Text('افزودن')),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

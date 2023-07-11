import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kak2ous/components/my_text_field.dart';
import 'package:kak2ous/controllers/excess_costs_controller.dart';
import 'package:kak2ous/controllers/main_page_controller.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/models/user_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class UserDetails extends StatefulWidget {
  const UserDetails(
      {super.key,
      required this.indx,
      required this.startTime,
      required this.endTime,
      required this.excessCosts,
      required this.systemNumber,
      required this.price,
      required this.isEnded,
      required this.descriptions});

  @override
  State<UserDetails> createState() => _UserDetailsState();
  final int indx;
  final String startTime;
  final String endTime;
  final List<ExcessCostsModel> excessCosts;
  final String systemNumber;
  final int price;
  final bool isEnded;
  final String descriptions;
}

/// زمان باقی مانده را به ساعت و دقیقه نشان میدهد
String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  if (duration > Duration.zero) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }
  return "00:00";
}

DateTime join(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

final mainController = Get.put(MainPageController());
final excessController = Get.put(ExcessCostsController());

class _UserDetailsState extends State<UserDetails> {
  String totalCost = '';
  String remainTime = '';
  String elapsedTime = '';
  String extraCost = '';
  double elapsedInPercent = 0.0;
  Timer? timer;
  bool notStarted = false;

  /// تبدیل ساعت به تاریخ
  String join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute)
        .toString();
  }

  /// حذف سیستم
  Future<dynamic> deleteItemDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(
              'مطمئنی میخوای سیسیتم شماره ${widget.systemNumber} رو حذفش کنی؟'),
          actions: [
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

  /// هزینه هارو محاسبه میکنه
  void checkCosts() {
    List<int> costs = [];
    for (var element in widget.excessCosts) {
      costs.add(element.price);
    }
    var start = DateTime.parse(widget.startTime);
    var end = DateTime.parse(widget.endTime);
    notStarted = start.isAfter(DateTime.now());

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

  /// چک کردن زمان باقی مانده
  void checkRemain() async {
    var start = DateTime.parse(widget.startTime);
    var end = DateTime.parse(widget.endTime);
    elapsedTime = printDuration(DateTime.now().difference(start));
    remainTime = printDuration(end.difference(DateTime.now()));

    // el = 1;
    if (start == end) {
      elapsedInPercent = 0;
    } else {
      if ((DateTime.now().difference(end).inSeconds /
                  end.difference(start).inSeconds) *
              100 !=
          double.infinity) {
        elapsedInPercent = ((DateTime.now().difference(start).inSeconds /
                    start.difference(end).inSeconds) *
                100) /
            100 *
            -1;
      } else {
        elapsedInPercent = 1;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    checkRemain();
    checkCosts();
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
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        // progress indicator
        Container(
          width: 350,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: notStarted
              ? Container()
              : LinearProgressIndicator(
                  minHeight: 230,
                  value: !elapsedInPercent.isInfinite || !elapsedInPercent.isNaN
                      ? elapsedInPercent
                      : 0,
                  backgroundColor: Colors.white54,
                  color: Colors.red[200],
                ),
        ),
        // system number
        Positioned(
          top: 100,
          child: Text(
            widget.systemNumber,
            style: const TextStyle(
              fontSize: 200,
              color: Colors.black54,
              fontFamily: 'inter',
              height: 0.5,
              // color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        // main
        InkWell(
            borderRadius: BorderRadius.circular(29),
            mouseCursor: MouseCursor.defer,
            onDoubleTap: () {
              var systemNumber = TextEditingController();
              var descriptions = TextEditingController();
              systemNumber.text = widget.systemNumber;
              descriptions.text = widget.descriptions;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Center(
                      child:
                          Text('  ویرایش سیستم شماره ${widget.systemNumber}')),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('شماره سیستم'),
                      MyTextField(
                        controller: systemNumber,
                        autoFocus: true,
                        onSubmitted: (value) {
                          if (value != '') {
                            mainController.updateData(
                              widget.indx,
                              UserModel(
                                  systemNumber: value,
                                  startTime: widget.startTime,
                                  endTime: widget.endTime,
                                  excessCosts: widget.excessCosts,
                                  price: widget.price,
                                  isEnded: widget.isEnded,
                                  descripstions: descriptions.text),
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const Text('توضیحات'),
                      MyTextField(controller: descriptions)
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (systemNumber.text != '') {
                            mainController.updateData(
                              widget.indx,
                              UserModel(
                                systemNumber: systemNumber.text,
                                startTime: widget.startTime,
                                endTime: widget.endTime,
                                excessCosts: widget.excessCosts,
                                price: widget.price,
                                isEnded: widget.isEnded,
                                descripstions: descriptions.text,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('تایید'))
                  ],
                ),
              );
            },
            child: Container(
              width: 350,
              height: 230,
              decoration: BoxDecoration(
                color: !notStarted
                    ? const Color(0xffBCEEB7).withOpacity(0.5)
                    : Colors.indigo.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('از ساعت', style: TextStyle(fontSize: 20)),
                    Text('تا ساعت', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Builder(builder: (context) {
                      var start = DateTime.parse(widget.startTime);

                      return InkWell(
                        onTap: () async {
                          var newTime = await showTimePicker(
                              initialEntryMode: TimePickerEntryMode.inputOnly,
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: start.hour, minute: start.minute));
                          if (newTime != null) {
                            mainController.updateData(
                                widget.indx,
                                UserModel(
                                    systemNumber: widget.systemNumber,
                                    startTime: join(DateTime.now(), newTime),
                                    endTime: widget.endTime,
                                    excessCosts: widget.excessCosts,
                                    price: widget.price,
                                    isEnded: widget.isEnded,
                                    descripstions: widget.descriptions));
                          }
                          checkRemain();
                        },
                        child: _Cbox(
                            color: const Color(0xff6DB9BE).withOpacity(0.6),
                            text: "${start.hour}:${start.minute}"),
                      );
                    }),
                    InkWell(
                      onTap: () async {
                        var end = DateTime.parse(widget.endTime);
                        var newTime = await showTimePicker(
                            initialEntryMode: TimePickerEntryMode.inputOnly,
                            context: context,
                            initialTime:
                                TimeOfDay(hour: end.hour, minute: end.minute));
                        if (newTime != null) {
                          mainController.updateData(
                              widget.indx,
                              UserModel(
                                systemNumber: widget.systemNumber,
                                startTime: widget.startTime,
                                endTime: join(DateTime.now(), newTime),
                                excessCosts: widget.excessCosts,
                                price: widget.price,
                                isEnded: widget.isEnded,
                                descripstions: widget.descriptions,
                              ));
                        }
                        checkRemain();
                      },
                      child: Builder(builder: (context) {
                        var end = DateTime.parse(widget.endTime);
                        if (widget.startTime == widget.endTime) {
                          return Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:
                                    const Color(0xff6DB9BE).withOpacity(0.6)),
                            child: const Center(
                                child: Icon(
                              Iconsax.unlimited4,
                              size: 50,
                            )),
                          );
                        }
                        return _Cbox(
                            color: const Color(0xff6DB9BE).withOpacity(0.6),
                            text: "${end.hour}:${end.minute}");
                      }),
                    ),
                  ],
                ),
                !notStarted
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text('سپری شده', style: TextStyle(fontSize: 20)),
                          Text('باقی مانده', style: TextStyle(fontSize: 20)),
                        ],
                      )
                    : Container(),
                !notStarted
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _Cbox(
                              color: const Color(0xff6DBE75).withOpacity(0.6),
                              text: elapsedTime),
                          _Cbox(
                              color: const Color(0xffBE816D).withOpacity(0.6),
                              text: remainTime),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            addExtraCostDialog(context);
                          },
                          icon: Icon(
                            Iconsax.wallet_2,
                            size: 40,
                            color: Colors.green[600],
                          )),
                      !notStarted
                          ? Row(
                              children: [
                                const Text('تومان  ',
                                    style:
                                        TextStyle(fontSize: 35, height: 0.5)),
                                Text(totalCost.seRagham(),
                                    style: const TextStyle(
                                        fontSize: 35, height: 0.5)),
                              ],
                            )
                          : Text(widget.descriptions,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 30,
                                height: 0.5,
                                color: Colors.red.shade300,
                              )),
                      IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            deleteItemDialog(context);
                          },
                          icon: Icon(
                            Iconsax.user_minus,
                            size: 40,
                            color: Colors.red[300],
                          )),
                    ],
                  ),
                ),
              ]),
            )),
      ],
    );
  }

  Future<dynamic> addExtraCostDialog(BuildContext context) {
    mainController.getExcessCosts(widget.indx);
    final paid = TextEditingController();

    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
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
              descripstions: widget.descriptions,
            ),
          );
        }

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
                                padding: const EdgeInsets.all(0),
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
                                      borderRadius: BorderRadius.circular(5)),
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
                                  borderRadius: BorderRadius.circular(5)),
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
                                      borderRadius: BorderRadius.circular(5)),
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

class _Cbox extends StatelessWidget {
  const _Cbox({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
      child: Center(
          child: Text(
        text,
        style: const TextStyle(
          fontSize: 35,
          fontFamily: 'inter',
        ),
      )),
    );
  }
}

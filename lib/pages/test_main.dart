import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kak2ous/components/my_button.dart';
import 'package:kak2ous/components/my_text_field.dart';
import 'package:kak2ous/components/user_details.dart';
import 'package:kak2ous/constants/constants.dart';
import 'package:kak2ous/controllers/main_page_controller.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/pages/dept_book.dart';
import 'package:kak2ous/pages/excess_costs.dart';

class TestMain extends StatelessWidget {
  TestMain({super.key});
  final controller = Get.put(MainPageController());

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          toolbarHeight: 40,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            '🌵 نرمافزار مدیریت گم نت کاکتوس 🌵',
            style: TextStyle(fontSize: 30),
          ),
          actions: [
            MyButton(
                onPressed: () {
                  Get.to(() => DeptBook());
                },
                text: 'حساب دفتری',
                icon: Iconsax.book),
            const SizedBox(width: 15),
            MyButton(
              onPressed: () => Get.to(ExcessCosts()),
              text: 'محصولات و خدمات',
              icon: Iconsax.shop,
            ),
            const SizedBox(width: 45),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.grey[100],
          elevation: 10,
          tooltip: 'اضافه کردن',
          hoverElevation: 5,
          child: const Icon(
            Iconsax.add,
            color: Colors.black,
            size: 50,
          ),
          onPressed: () {
            addNewRowDialog(context);
          },
        ),
        body: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Container(
                width: mainController.notStartedItems.isEmpty ? 0 : 350,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        // offset: Offset(0, 15),
                        blurRadius: 8,
                        spreadRadius: 0)
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'سیستم های رزرو شده',
                      style: TextStyle(fontSize: 25),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => ListView.separated(
                            itemCount: controller.notStartedItems.length,
                            itemBuilder: (context, index) {
                              return controller.notStartedItems[index];
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 5);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  opacity: 0.2,
                                  image: AssetImage('assets/cactus.png')))),
                    ),
                    SingleChildScrollView(
                        child: Center(
                      child: Obx(
                        () => Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: controller.startedItems.value,
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            Obx(
              () => mainController.endedItems.isEmpty
                  ? Container()
                  : Container(
                      width: 350,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              // offset: Offset(0, 15),
                              blurRadius: 8,
                              spreadRadius: 0)
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'وقت های تمام شده',
                            style: TextStyle(fontSize: 25),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(
                                () => ListView.separated(
                                  itemCount: controller.endedItems.length,
                                  itemBuilder: (context, index) {
                                    return controller.endedItems[index];
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 5);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> addNewRowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        final TextEditingController systemNumber = TextEditingController();
        final TextEditingController descriptions = TextEditingController();
        final TextEditingController hourTime = TextEditingController(text: '0');
        final TextEditingController minutesTime =
            TextEditingController(text: '0');
        var startTime = DateTime.now();
        var endTime = DateTime.now();
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.bottomRight,
          title: const Center(child: Text('افزودن ')),
          actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
          titlePadding: const EdgeInsets.only(top: 20),
          content: Directionality(
              textDirection: TextDirection.rtl,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('شماره سیستم'),
                        const SizedBox(height: 5),
                        MyTextField(
                          controller: systemNumber,
                          isNumber: true,
                          autoFocus: true,
                          onSubmitted: (p0) {
                            if (systemNumber.text.isEmpty) {
                              var snack = const SnackBar(
                                  content: Text('شماره سیستم را وارد کنید.'));
                              ScaffoldMessenger.of(context).showSnackBar(snack);
                              return;
                            }

                            controller.addItem(
                                startTime: startTime.toString(),
                                endTime: endTime.toString(),
                                systemNumber: systemNumber.text.toString(),
                                excessCosts: <ExcessCostsModel>[],
                                price: Constants.everyHourCost,
                                descriptions: descriptions.text);
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('از ساعت'),
                              Center(
                                child: MyButton(
                                    onPressed: () async {
                                      DateTime dateTime;
                                      var newTime = await showTimePicker(
                                          context: context,
                                          cancelText: "لغو",
                                          confirmText: 'تایید',
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          hourLabelText: "ساعت",
                                          minuteLabelText: "دقیقه",
                                          helpText: "ساعت را وارد کنید",
                                          initialTime: TimeOfDay.now());
                                      setState(() {
                                        dateTime = join(DateTime.now(),
                                            newTime ?? TimeOfDay.now());
                                        startTime = dateTime;
                                      });
                                    },
                                    text:
                                        '${startTime.hour > 12 ? startTime.hour - 12 : startTime.hour}:${startTime.minute}'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('تا ساعت'),
                              Center(
                                  child: MyButton(
                                      onPressed: () async {
                                        DateTime dateTime;
                                        var newTime = await showTimePicker(
                                            context: context,
                                            cancelText: "لغو",
                                            confirmText: 'تایید',
                                            initialEntryMode:
                                                TimePickerEntryMode.input,
                                            hourLabelText: "ساعت",
                                            minuteLabelText: "دقیقه",
                                            helpText: "ساعت را وارد کنید",
                                            initialTime: TimeOfDay.now());
                                        setState(() {
                                          dateTime = join(DateTime.now(),
                                              newTime ?? TimeOfDay.now());
                                          endTime = dateTime;
                                        });
                                      },
                                      text:
                                          '${endTime.hour > 12 ? endTime.hour - 12 : endTime.hour}:${endTime.minute}'))
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('به مدت'),
                        // const SizedBox(height: 10),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Column(
                            children: [
                              InkWell(
                                  onTap: () {
                                    int initail = int.parse(minutesTime.text);
                                    if (initail < 44) {
                                      var addedTime = initail + 15;
                                      minutesTime.text = addedTime.toString();
                                    }
                                  },
                                  child: const Icon(Iconsax.arrow_up_2)),
                              SizedBox(
                                width: 70,
                                child: MyTextField(
                                  controller: minutesTime,
                                  label: 'دقیقه',
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    int initail = int.parse(minutesTime.text);
                                    if (initail > 0) {
                                      var addedTime = initail - 15;
                                      minutesTime.text = addedTime.toString();
                                    }
                                  },
                                  child: const Icon(Iconsax.arrow_down_1)),
                            ],
                          ),
                          const SizedBox(width: 6),
                          Column(
                            children: [
                              InkWell(
                                  onTap: () {
                                    int initail = int.parse(hourTime.text);
                                    var addedTime = initail + 1;
                                    hourTime.text = addedTime.toString();
                                  },
                                  child: const Icon(Iconsax.arrow_up_2)),
                              SizedBox(
                                width: 70,
                                child: MyTextField(
                                  controller: hourTime,
                                  label: 'ساعت',
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    int initail = int.parse(hourTime.text);
                                    if (initail > 0) {
                                      var addedTime = initail - 1;
                                      hourTime.text = addedTime.toString();
                                    }
                                  },
                                  child: const Icon(Iconsax.arrow_down_1)),
                            ],
                          ),
                          const SizedBox(width: 6),
                          MyButton(
                              onPressed: () {
                                endTime = startTime.add(Duration(
                                    hours: int.parse(hourTime.text),
                                    minutes: int.parse(minutesTime.text)));
                                setState(() {});
                              },
                              text: 'تایید')
                        ]),
                        const Text('توضیحات'),
                        MyTextField(controller: descriptions)
                      ],
                    ),
                  );
                },
              )),
          actions: [
            MyButton(
                onPressed: () {
                  if (systemNumber.text.isEmpty) {
                    var snack = const SnackBar(
                        content: Text('شماره سیستم را وارد کنید.'));
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                    return;
                  }

                  controller.addItem(
                      startTime: startTime.toString(),
                      endTime: endTime.toString(),
                      systemNumber: systemNumber.text.toString(),
                      excessCosts: <ExcessCostsModel>[],
                      price: Constants.everyHourCost,
                      descriptions: descriptions.text);
                  Navigator.of(context).pop();
                },
                text: 'تایید'),
          ],
        );
      },
    );
  }
}

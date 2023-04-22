import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kak2ous/components/my_text_field.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/pages/excess_costs.dart';
import '../controllers/main_page_controller.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key, required this.title});

  final String title;
  final controller = Get.put(MainPageController());
  bool isVertical = true;

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete),
            label: const Text('حذف کامل'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExcessCosts(),
              ));
            },
            icon: const Icon(Icons.dinner_dining_sharp),
            label: const Text('هزینه های مازاد'),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.symmetric(
                  outside: BorderSide.none,
                ),
                children: const [
                  TableRow(children: [
                    Center(child: Text('شماره سیستم')),
                    Center(child: Text('از ساعت')),
                    Center(child: Text('تا ساعت')),
                    Center(child: Text('سایر هزینه ها')),
                    Center(child: Text('مجموع')),
                    Center(child: Text('زمان باقی مانده')),
                    Center(child: Text('زمان سپری شده')),
                    Center(child: Text('ویرایش')),
                    Center(child: Text('حذف')),
                  ])
                ]),
          ),
          const SizedBox(height: 10),
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return controller.items[index];
              },
              itemCount: controller.items.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              addNewRowDialog(context);

              // controller.addItem();
            },
            tooltip: 'افزودن سطر جدید',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              if (isVertical) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft,
                ]);
                isVertical = !isVertical;
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                isVertical = !isVertical;
              }
            },
            tooltip: 'چرخش صفحه',
            child: const Icon(Icons.recycling_rounded),
          )
        ],
      ),
    );
  }

  Future<dynamic> addNewRowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        final TextEditingController systemNumber = TextEditingController();
        final TextEditingController price = TextEditingController();
        var startTime = DateTime.now();
        var endTime = DateTime.now();
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          title: const Center(child: Text('افزودن ')),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 5),
          buttonPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.symmetric(horizontal: 2),
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
                        MyTextField(controller: systemNumber, isNumber: true),
                        const SizedBox(height: 10),
                        const Text('از ساعت'),
                        const SizedBox(height: 5),
                        Center(
                          child: OutlinedButton(
                            onPressed: () async {
                              DateTime dateTime;
                              var newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              setState(() {
                                dateTime = join(
                                    DateTime.now(), newTime ?? TimeOfDay.now());
                                startTime = dateTime;
                              });
                            },
                            child:
                                Text('${startTime.hour}:${startTime.minute}'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('تا ساعت'),
                        const SizedBox(height: 5),
                        Center(
                            child: OutlinedButton(
                                onPressed: () async {
                                  DateTime dateTime;
                                  var newTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  setState(() {
                                    dateTime = join(DateTime.now(),
                                        newTime ?? TimeOfDay.now());
                                    endTime = dateTime;
                                  });
                                },
                                child:
                                    Text('${endTime.hour}:${endTime.minute}'))),
                        const SizedBox(height: 10),
                        const Text('قیمت هر ساعت(به تومان)'),
                        const SizedBox(height: 5),
                        MyTextField(
                          controller: price,
                          isNumber: true,
                        ),
                      ],
                    ),
                  );
                },
              )),
          actions: [
            TextButton(
                onPressed: () {
                  if (systemNumber.text.isEmpty) {
                    var snack = const SnackBar(
                        content: Text('شماره سیستم را وارد کنید.'));
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                    return;
                  }
                  if (price.text.isEmpty) {
                    var snack = const SnackBar(
                        content: Text('هزینه هر ساعت بازی را وارد کنید.'));
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                    return;
                  }
                  controller.addItem(
                    startTime: startTime.toString(),
                    endTime: endTime.toString(),
                    systemNumber: systemNumber.text.toString(),
                    excessCosts: <ExcessCostsModel>[],
                    price: int.parse(price.text),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('تایید')),
          ],
        );
      },
    );
  }
}

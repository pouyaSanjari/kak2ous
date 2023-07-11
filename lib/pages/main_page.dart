import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kak2ous/components/my_text_field.dart';
import 'package:kak2ous/constants/constants.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/pages/excess_costs.dart';
import 'package:kak2ous/pages/test_main.dart';
import '../controllers/main_page_controller.dart';

class AddRow extends Intent {}

class MainPage extends StatelessWidget {
  MainPage({super.key, required this.title});

  final String title;
  final controller = Get.put(MainPageController());
  final bool isVertical = true;
  final List<Widget> portraitItems = [
    const Center(child: Text('شماره سیستم')),
    const Center(child: Text('از ساعت')),
    const Center(child: Text('تا ساعت')),
    const Center(child: Text('باقی مانده')),
    const Center(child: Text('مجموع')),
  ];

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
        ? true
        : false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExcessCosts(),
              ));
            },
            child: const Text('هزینه های مازاد'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TestMain(),
              ));
            },
            child: const Text('تست'),
          )
        ],
      ),
      body: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.keyA, LogicalKeyboardKey.control):
              AddRow()
        },
        child: Actions(
          actions: {
            AddRow: CallbackAction<AddRow>(
              onInvoke: (intent) => addNewRowDialog(context),
            )
          },
          child: Focus(
            autofocus: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.symmetric(
                        outside: BorderSide.none,
                        inside: const BorderSide(width: 0.2)),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.4),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        children: isPortrait
                            ? portraitItems
                            : [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(child: Text('شماره سیستم')),
                                ),
                                const Center(child: Text('از ساعت')),
                                const Center(child: Text('تا ساعت')),
                                const Center(child: Text('سایر هزینه ها')),
                                const Center(child: Text('باقی مانده')),
                                const Center(child: Text('زمان سپری شده')),
                                const Center(child: Text('هزینه مازاد')),
                                const Center(child: Text('مجموع')),
                                const Center(child: Text('ویرایش')),
                                const Center(child: Text('حذف')),
                              ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: index.isOdd
                                  ? Colors.amber.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: controller.items[index]),
                      );
                    },
                    itemCount: controller.items.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 0);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'b',
            onPressed: () {
              addNewRowDialog(context);
            },
            tooltip: 'افزودن سطر جدید',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            heroTag: 'c',
            label: const Text('چرخش صفحه'),
            onPressed: () {
              isPortrait
                  ? SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight
                    ])
                  : SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
            },
          )
        ],
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
        var startTime = DateTime.now();
        var endTime = DateTime.now();
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          title: const Center(child: Text('افزودن ')),
          actionsPadding: const EdgeInsets.only(right: 10, bottom: 10),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  const Text('از ساعت'),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: OutlinedButton(
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
                                      child: Text(
                                          '${startTime.hour > 12 ? startTime.hour - 12 : startTime.hour}:${startTime.minute}'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  const Text('تا ساعت'),
                                  const SizedBox(height: 10),
                                  Center(
                                      child: OutlinedButton(
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
                                          child: Text(
                                              '${endTime.hour > 12 ? endTime.hour - 12 : endTime.hour}:${endTime.minute}')))
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        MyTextField(controller: descriptions),
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

                  controller.addItem(
                      startTime: startTime.toString(),
                      endTime: endTime.toString(),
                      systemNumber: systemNumber.text.toString(),
                      excessCosts: <ExcessCostsModel>[],
                      price: Constants.everyHourCost,
                      descriptions: descriptions.text);
                  Navigator.of(context).pop();
                },
                child: const Text('تایید')),
          ],
        );
      },
    );
  }
}

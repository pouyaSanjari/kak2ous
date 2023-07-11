import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kak2ous/components/dept_user_view.dart';
import 'package:kak2ous/components/my_button.dart';
import 'package:kak2ous/components/my_text_field.dart';
import 'package:kak2ous/controllers/dept_book_controller.dart';
import 'package:kak2ous/models/dept_user_model.dart';

class DeptBook extends StatelessWidget {
  DeptBook({super.key});
  final controller = Get.put(DeptBookController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar:
            AppBar(title: const Center(child: Text('حساب دفتری')), actions: [
          MyButton(
            icon: Iconsax.add,
            text: 'افزودن',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  var name = TextEditingController();
                  var deptAmount = TextEditingController();
                  return AlertDialog(
                    title: const Center(child: Text('افزودن بدهکار')),
                    actions: [
                      TextButton(
                          onPressed: () {
                            controller.addNewDept(DeptUserModel(
                                name.text, [int.parse(deptAmount.text)], []));
                          },
                          child: const Text('افزودن'))
                    ],
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      MyTextField(
                        controller: name,
                        label: 'نام',
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: deptAmount,
                        label: 'مبلغ بدهی',
                      )
                    ]),
                  );
                },
              );
            },
          )
        ]),
        body: Obx(
          () => ListView.builder(
            itemCount: controller.depts.length,
            itemBuilder: (context, index) {
              int depts = 0;
              if (controller.depts[index].depts.length.isGreaterThan(2)) {
                depts = controller.depts[index].depts.reduce((a, b) => a + b);
              } else if (controller.depts[index].depts.isNotEmpty) {
                depts = controller.depts[index].depts[0];
              }
              int paid = 0;
              if (controller.depts[index].payments.isNotEmpty) {
                paid = controller.depts[index].payments.reduce((a, b) => a + b);
              }
              String remain = (depts - paid).toString();

              return DeptUserView(
                index: index,
                name: controller.depts[index].name,
                totalDept: depts.toString(),
                paid: paid.toString(),
                remain: remain,
              );
            },
          ),
        ),
      ),
    );
  }
}

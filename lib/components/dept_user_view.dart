import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kak2ous/controllers/dept_book_controller.dart';

class DeptUserView extends StatelessWidget {
  DeptUserView(
      {super.key,
      required this.name,
      required this.paid,
      required this.remain,
      required this.index,
      required this.totalDept});
  final int index;
  final String name;
  final String totalDept;
  final String paid;
  final String remain;

  final controller = Get.put(DeptBookController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Text('نام: '),
        Text(name),
        const SizedBox(width: 30),
        const Text('بدهکار: '),
        Text(totalDept),
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.edit)),
        const SizedBox(width: 30),
        const Text('بستانکار: '),
        Text(paid),
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.edit)),
        const SizedBox(width: 30),
        const Text('باقی مانده: '),
        Text(remain),
        const SizedBox(width: 30),
        IconButton(
            onPressed: () {
              controller.deleteDept(index);
            },
            icon: const Icon(
              Iconsax.trash,
              color: Colors.red,
            ))
      ]),
    );
  }
}

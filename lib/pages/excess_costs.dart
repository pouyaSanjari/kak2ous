import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kak2ous/components/my_text_field.dart';
import 'package:kak2ous/controllers/excess_costs_controller.dart';

class ExcessCosts extends StatelessWidget {
  ExcessCosts({super.key});
  final controller = Get.put(ExcessCostsController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('لیست هزینه های مازاد')),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            var name = TextEditingController();
            var price = TextEditingController();
            showDialog(
              context: context,
              builder: (context) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    actionsPadding: EdgeInsets.zero,
                    title: const Text('اضافه کردن'),
                    content: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('محصول'),
                            TextField(
                                controller: name,
                                decoration: const InputDecoration(
                                    constraints: BoxConstraints(maxHeight: 30),
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 5))),
                            const Text('قیمت'),
                            MyTextField(
                              controller: price,
                            )
                          ]),
                    ),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text('لغو')),
                      TextButton(
                          onPressed: () {
                            controller.addItem(
                                name.text, int.parse(price.text));
                            Navigator.pop(context);
                          },
                          child: const Text('ثبت')),
                    ],
                  ),
                );
              },
            );
          },
        ),
        body: Obx(
          () => ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.blueGrey)),
                          child: Center(
                              child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 19),
                          ))),
                      const SizedBox(width: 10),
                      Text(controller.items[index].name),
                      const SizedBox(width: 20),
                      const Text('قیمت:'),
                      const SizedBox(width: 10),
                      Text(controller.items[index].price.toString()),
                      const SizedBox(width: 5),
                      const Expanded(child: Text('تومان')),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            controller.deleteItem(index);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ))
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: controller.items.length),
        ),
      ),
    );
  }
}

import 'package:get/get.dart';

class MyRowController extends GetxController {
  Rx<DateTime> editDialogStartTime = DateTime.now().obs;
  Rx<DateTime> editDialogEndTime = DateTime.now().obs;
}

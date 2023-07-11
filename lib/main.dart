import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kak2ous/models/dept_user_model.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/pages/main_page.dart';
import 'package:kak2ous/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(DeptUserModelAdapter());
  Hive.registerAdapter(ExcessCostsModelAdapter());
  Hive.init(directory.path);
  DartVLC.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نرمافزار مدیریت گیم نت کاکتوس',
      theme: ThemeData(
        // useMaterial3: true,
        fontFamily: 'koodak',
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: MainPage(title: 'نرمافزار مدیریت گیم نت کاکتوس')),
    );
  }
}

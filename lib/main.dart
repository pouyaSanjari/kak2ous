import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kak2ous/models/excess_costs_model.dart';
import 'package:kak2ous/models/time_adapter.dart';
import 'package:kak2ous/pages/main_page.dart';
import 'package:kak2ous/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TimeAdapter());
  Hive.registerAdapter(ExcessCostsModelAdapter());
  Hive.init(directory.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نرمافزار مدیریت گیم نت کاکتوس',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: MainPage(title: 'نرمافزار مدیریت گیم نت کاکتوس')),
    );
  }
}

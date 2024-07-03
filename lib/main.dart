import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = AppDatabase();
  GetIt.I.registerSingleton<AppDatabase>(database);

  final resp = await database.getSchedules();
  print(resp);

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: "NotoSans",
    ),
    home: HomeScreen(),
  ));
}

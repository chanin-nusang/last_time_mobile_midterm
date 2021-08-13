import 'package:flutter/material.dart';
import 'package:last_time_mobile_midterm/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:last_time_mobile_midterm/models/lasttime.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(LastTimeAdapter());
  await Hive.openBox('lasttime');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/note_hive_helper.dart';
import 'package:note_app/note_screen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(NoteHiveHelper.notebox);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: NoteScreen(),
    );
  }
}

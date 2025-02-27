import 'package:flutter/material.dart';
import 'character_selection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jump Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'crayon', // 設置全局字體
      ),
      home: const CharacterSelection(),
    );
  }
}

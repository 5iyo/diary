import 'package:flutter/material.dart';
import 'package:my_diary_front/diaryInfoPage.dart';
import 'mapPage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: '/diaryInfoPage',
      routes: {
        '/mapPage': (context) => MapPage(),
        '/diaryInfoPage': (context) => DiaryInfoPage()
      },
    );
  }
}
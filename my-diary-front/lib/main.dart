import 'package:flutter/material.dart';
import 'package:my_diary_front/diaryImagePage.dart';
import 'package:my_diary_front/diaryInfoPage.dart';
import 'package:my_diary_front/signInPage.dart';
import 'mapPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: '/signInPage',
      routes: {
        '/signInPage': (context) => SignInPage(),
        '/mapPage': (context) => MapPage(),
        '/diaryInfoPage': (context) => DiaryInfoPage(),
        '/diaryImagePage': (context) => DiaryImagePage(),
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:my_diary_front/view/pages/post/diaryImagePage.dart';
import 'package:my_diary_front/view/pages/post/diaryInfoPage.dart';
import 'package:my_diary_front/signInPage.dart';
import 'view/pages/post/mapPage.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/mapPage',
      routes: {
        '/signInPage': (context) => SignInPage(),
        '/mapPage': (context) => MapPage(),
        '/diaryInfoPage': (context) => DiaryInfoPage(),
        '/diaryImagePage': (context) => DiaryImagePage(),
      },
    );
  }
}
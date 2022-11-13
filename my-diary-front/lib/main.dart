import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_diary_front/diaryImagePage.dart';
import 'package:my_diary_front/diaryInfoPage.dart';
import 'package:my_diary_front/geocodingPage.dart';
import 'package:my_diary_front/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_diary_front/mapPage.dart';
import 'package:my_diary_front/signInPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
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
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              titleTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      initialRoute: '/mapPage',
      routes: {
        '/homePage': (context) => HomePage(),
        '/signInPage': (context) => SignInPage(),
        '/mapPage': (context) => MapPage(),
        '/diaryInfoPage': (context) => DiaryInfoPage(),
        '/diaryImagePage': (context) => DiaryImagePage(),
        '/geocodingPage': (context) => GeocodingPage(),
      },
    );
  }
}

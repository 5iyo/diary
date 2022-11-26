import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_diary_front/data.dart';
import 'package:my_diary_front/geocodingPage.dart';
import 'package:my_diary_front/homePage.dart';
import 'package:my_diary_front/view/pages/post/diaryImagePage.dart';
import 'package:my_diary_front/view/pages/post/diaryInfoPage.dart';
import 'package:my_diary_front/signInPage.dart';
import 'package:my_diary_front/view/pages/user/user_info.dart';
import 'view/pages/post/mapPage.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(nativeAppKey: dotenv.get("KAKAO_CLIENT_ID"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<MainViewModel>.value(
      value: MainViewModel(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                titleTextStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        initialRoute: '/userInfoPage',
        routes: {
          '/homePage': (context) => HomePage(),
          '/signInPage': (context) => SignInPage(),
          '/mapPage': (context) => MapPage(),
          '/diaryInfoPage': (context) => DiaryInfoPage(),
          '/diaryImagePage': (context) => DiaryImagePage(),
          '/geocodingPage': (context) => GeocodingPage(),
          '/userInfoPage': (context) => UserInfo(),
        },
      ),
    );
  }
}
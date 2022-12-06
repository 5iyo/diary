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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'controller/provider/diary_delete_provider.dart';
import 'controller/provider/diary_update_provider.dart';
import 'controller/provider/diarylist_provider.dart';
import 'controller/provider/travel_update_provider.dart';
import 'controller/provider/diary_write_provider.dart';
import 'package:my_diary_front/controller/provider/travel_delete_provider.dart';
import 'package:my_diary_front/controller/provider/travellist_provider.dart';
import 'package:my_diary_front/controller/provider/travel_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(nativeAppKey: dotenv.get("KAKAO_CLIENT_ID"));
  
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (BuildContext context) => TravelListProvider()),
    ChangeNotifierProvider(
        create: (BuildContext context) => TravelProvider()),
    ChangeNotifierProvider(
        create: (BuildContext context) => TravelUpdateProvider()),
    ChangeNotifierProvider(
        create: (BuildContext context) => TravelDeleteProvider()),
    ChangeNotifierProvider(
        create: (BuildContext context) => DiaryListProvider()),
    ChangeNotifierProvider(
        create: (BuildContext context) => DiaryWriteProvider()),
    ChangeNotifierProvider(
        create: (BuildContext context) => DiaryUpdateProvider()),
    ChangeNotifierProvider(
        create: (BuildContext context) => DiaryDeleteProvider()),
  ],
    child: const MyApp()));
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
            primaryColor: Colors.white,
            primarySwatch: Colors.grey,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                titleTextStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        initialRoute: '/homePage',
        routes: {
          '/homePage': (context) => HomePage(),
          '/signInPage': (context) => SignInPage(),
          '/mapPage': (context) => MapPage(),
          '/diaryInfoPage': (context) => DiaryInfoPage(),
          '/diaryImagePage': (context) => DiaryImagePage(),
          '/geocodingPage': (context) => GeocodingPage(),
          '/userInfoPage': (context) => UserInfo(),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        locale: const Locale('ko'),
      ),
    );
  }
}


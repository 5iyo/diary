import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:my_diary_front/data.dart';
import 'package:my_diary_front/signInPage.dart';
import 'package:my_diary_front/view/pages/post/mapPage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const storage = FlutterSecureStorage();
  String? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: /*Builder(
        builder: (BuildContext context) {
          if (user == null) {
            return const SignInPage();
          } else {
            return const MapPage();
          }
        },*/
        StreamBuilder(
            stream: Provider.of<DiaryStream>(context, listen: true).getStream(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (!snapshot.hasData) {
                return SignInPage();
              } else {
                print("homPage : ${snapshot.data}");
                return MapPage();
              }
            }
      ),
    );
  }

  _initStorage() async {
    user = await storage.read(key: "userInfo");
  }
}


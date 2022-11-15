/*
import 'package:flutter/material.dart';
import 'package:my_diary_front/signInPage.dart';
import 'package:my_diary_front/view/pages/post/mapPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (!snapshot.hasData) {
                return SignInPage();
              } else {
                return MapPage();
              }
            }),
      ),
    );
  }
}
*/

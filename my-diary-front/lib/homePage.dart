import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
          stream: Provider.of<MainViewModel>(context, listen: true)
              .getStream(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (!snapshot.hasData || snapshot.data == "") {
              return const SignInPage();
            } else {
              return const MapPage();
            }
          }),
    );
  }
}

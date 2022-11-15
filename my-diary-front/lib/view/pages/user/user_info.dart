import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("userInfo"),
          ],
        ),
      ),
    );
  }
}

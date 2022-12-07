import 'package:flutter/material.dart';

enum BackgroundType {
  none,
  login,
  write,
}

class UiViewModel {
  static double containerRatio = 0.6209286209286209;
  static double heightRatio = 0.7417322834645669;

  static String _matchBackground(BackgroundType pageType) {
    String base = "img/bg_";
    switch (pageType) {
      case BackgroundType.none:
        return "${base}none.png";
      case BackgroundType.login:
        return "${base}login.png";
      case BackgroundType.write:
        return "${base}write.png";
    }
  }

  static Container buildBackgroundContainer(
      BoxConstraints context, BackgroundType pageType) {
    String background = _matchBackground(pageType);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: Image.asset(background).image, fit: BoxFit.fitHeight)),
    );
  }

  static SizedBox buildLayout(BuildContext context,
      Function(BoxConstraints constraints) child) {
    double height = MediaQuery.of(context).size.height;
    double containerHeight = heightRatio * height;
    double containerWidth = containerRatio * containerHeight;
    return SizedBox(
      width: containerWidth,
      height: containerHeight,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            child(constraints),
      ),
    );
  }
}

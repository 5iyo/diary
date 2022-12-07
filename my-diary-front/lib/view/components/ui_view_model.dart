import 'package:flutter/material.dart';

enum BackgroundType {
  none,
  login,
  write,
}

class UiViewModel {
  static const double _containerRatio = 0.6209286209286209;
  static const double _heightRatio = 0.7417322834645669;

  static String _matchBackground(BackgroundType backgroundType) {
    String base = "img/bg_";
    switch (backgroundType) {
      case BackgroundType.none:
        return "${base}none.png";
      case BackgroundType.login:
        return "${base}login.png";
      case BackgroundType.write:
        return "${base}write.png";
    }
  }

  static Container buildBackgroundContainer(
      {required BuildContext context,
      required BackgroundType backgroundType,
      required Widget child}) {
    String background = _matchBackground(backgroundType);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: Image.asset(background).image, fit: BoxFit.fitHeight)),
      width: width,
      height: height,
      child: child,
    );
  }

  static SizedBox buildLayout(BuildContext context,
      Widget Function(BoxConstraints constraints) layoutBuilder) {
    double height = MediaQuery.of(context).size.height;
    double containerHeight = _heightRatio * height;
    double containerWidth = _containerRatio * containerHeight;
    return SizedBox(
      width: containerWidth,
      height: containerHeight,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            layoutBuilder(constraints),
      ),
    );
  }
}

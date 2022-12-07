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
              image: Image.asset(background).image, fit: BoxFit.cover)),
      width: width,
      height: height,
      child: child,
    );
  }

  static Widget buildSizedLayout(BuildContext context, Widget child) {
    double height = MediaQuery.of(context).size.height;
    double containerHeight = _heightRatio * height;
    double containerWidth = _containerRatio * containerHeight;

    print("buildSizedLayout context height : $height");
    print("buildSizedLayout context containerHeight : $containerHeight");
    return Column(
      children: [
        const Spacer(),
        Wrap(
          children: [
            SizedBox(
              width: containerWidth,
              height: containerHeight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    containerWidth * 0.05, 0.0, containerWidth * 0.05, 0.0),
                child: child,
              ),
            )
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

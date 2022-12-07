import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';

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

  static Size getSizedLayoutSize (BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double containerHeight = _heightRatio * height;
    double containerWidth = _containerRatio * containerHeight;
    return Size(containerWidth, containerHeight);
  }

  static Widget buildSizedLayout(BuildContext context, Widget child) {
    Size sizedLayoutSize = getSizedLayoutSize(context);
    double containerHeight = sizedLayoutSize.height;
    double containerWidth = sizedLayoutSize.width;

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
                    containerWidth * 0.05, containerHeight * 0.05, containerWidth * 0.05, 0.0),
                child: child,
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      verticalDirection: verticalDirection,
      separatorBuilder: (context, index) {
        return Divider();
      },
      includeOuterSeparators: true,
      children:
      List.generate(itemCount, (index) => itemBuilder(context, index)).toList(),
    );
  }
}
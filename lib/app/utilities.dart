import 'package:flutter/material.dart';

class Utilities {

  static final Utilities _utilities = new Utilities._internal();
  Utilities._internal();

  static Utilities get() {
    return _utilities;
  }

  double getAppBarHeight(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = screenHeight / 2.5;
    return appBarHeight;
  }

  double getAppBarTopPosition(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    final double position = statusbarHeight + 20;
    return position;
  }

}
import 'package:flutter/material.dart';

class AppColors {
  const AppColors();
  static const Color primaryColor = const Color.fromRGBO(0, 128, 129, 1.0);
  static const Color secondaryColor = const Color.fromRGBO(79, 151, 163, 1.0);
  static const Color pinkColor = const Color.fromRGBO(255, 64, 108, 1.0);
  static const Color whiteColor = const Color.fromRGBO(255, 255, 255, 1.0);
  static const Color blackColor = const Color.fromRGBO(0, 0, 0, 1.0);
  static const Color greyColor = const Color(0xffE8E8E8);
}

class AppTextStyles {
  const AppTextStyles();

  static const TextStyle appTitle = const TextStyle(fontSize: 25.0, color: AppColors.whiteColor);
  static const TextStyle movieCardTitle = const TextStyle(fontSize: 22.0, color: AppColors.blackColor);
  static const TextStyle movieCardGeners = const TextStyle(fontSize: 16.0, color: AppColors.blackColor);
}

ThemeData themeData = new ThemeData(
    primaryColor: AppColors.primaryColor,
    fontFamily: 'Oxygen'
);
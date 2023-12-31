import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color borderColor = Color(0xFFEBEBEB);
  static const Color gray = Color(0xffB3B3B3);
  static const Color grayscaleMedium = Color(0xff999BA4);
  static const Color grayscaleLight = Color(0xffECECEC);
  static const Color black = Color(0xFF11181E);
  static const Color white = Colors.white;
  static const Color darkPurple = Color(0xFFD0A2F7);
  static const Color mediumDarkPurple = Color(0xFFDCBFFF);
  static const Color darkPink = Color(0xFFE5D4FF);
  static const Color lightPink = Color(0xFFF1EAFF);
  static const Color darkGray = Color(0xFF0B131E);
  static const Color lightGray = Color(0xFF202B3B);

  static const Color lightShimmerGray = Color(0xffe0e0e0);
  static const Color darkShimmerGray = Color(0xff757575);

  static Color shimmerBaseColor = lightShimmerGray.withOpacity(0.5);
  static Color shimmerHighlightColor = lightShimmerGray.withOpacity(0.2);

  static Color shimmerBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? AppColors.lightShimmerGray : AppColors.darkShimmerGray.withOpacity(0.5);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  AppSizes.init();
  static double size2 = _AppSizeConstants.size2.sp;
  static double size4 = _AppSizeConstants.size4.sp;
  static double size6 = _AppSizeConstants.size6.sp;
  static double size8 = _AppSizeConstants.size8.sp;
  static double size10 = _AppSizeConstants.size10.sp;
  static double size12 = _AppSizeConstants.size12.sp;
  static double size14 = _AppSizeConstants.size14.sp;
  static double size16 = _AppSizeConstants.size16.sp;
  static double size18 = _AppSizeConstants.size18.sp;
  static double size20 = _AppSizeConstants.size20.sp;
  static double size22 = _AppSizeConstants.size22.sp;
  static double size24 = _AppSizeConstants.size24.sp;
  static double size26 = _AppSizeConstants.size26.sp;
  static double size28 = _AppSizeConstants.size28.sp;
  static double size30 = _AppSizeConstants.size30.sp;
  static double size32 = _AppSizeConstants.size32.sp;
  static double size36 = _AppSizeConstants.size36.sp;
  static double size40 = _AppSizeConstants.size40.sp;
  static double size44 = _AppSizeConstants.size44.sp;
  static double size48 = _AppSizeConstants.size48.sp;
  static double size52 = _AppSizeConstants.size52.sp;
  static double size64 = _AppSizeConstants.size64.sp;
  static double size70 = _AppSizeConstants.size70.sp;
  static double size80 = _AppSizeConstants.size80.sp;
  static double size84 = _AppSizeConstants.size84.sp;
  static double size96 = _AppSizeConstants.size96.sp;
  static double size128 = _AppSizeConstants.size128.sp;
}

class _AppSizeConstants {
  _AppSizeConstants._();

  static const double size2 = 2.0;
  static const double size4 = 4.0;
  static const double size6 = 6.0;
  static const double size8 = 8.0;
  static const double size10 = 10.0;
  static const double size12 = 12.0;
  static const double size14 = 14.0;
  static const double size16 = 16.0;
  static const double size18 = 18.0;
  static const double size20 = 20.0;
  static const double size22 = 22.0;
  static const double size24 = 24.0;
  static const double size26 = 26.0;
  static const double size28 = 28.0;
  static const double size30 = 30.0;
  static const double size32 = 32.0;
  static const double size36 = 36.0;
  static const double size40 = 40.0;
  static const double size44 = 44.0;
  static const double size48 = 48.0;
  static const double size52 = 52.0;
  static const double size64 = 64.0;
  static const double size70 = 70.0;
  static const double size80 = 80.0;
  static const double size84 = 84.0;
  static const double size96 = 96.0;
  static const double size128 = 128.0;
}

class AppWeights {
  AppWeights._();

  static const FontWeight lighter = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight normal = FontWeight.w400;
  static const FontWeight bold = FontWeight.w500;
  static const FontWeight bolder = FontWeight.w600;
}

enum AppPadding {
  p4(4.0),
  p6(6.0),
  p8(8.0),
  p10(10.0),
  p12(12.0),
  p14(14.0),
  p16(16.0),
  p20(20.0),
  p24(24.0),
  p32(32.0),
  p50(50.0),
  p64(64.0),
  p80(80.0),
  p128(128.0);

  final double _padding;

  const AppPadding(this._padding);
}

extension PaddingExtension on AppPadding {
  // EdgeInsets All
  EdgeInsets all() => EdgeInsets.all(_padding.sp);

  // EdgeInsets Symetric Horizontal
  EdgeInsets horizontal() => EdgeInsets.symmetric(horizontal: _padding.sp);

  // EdgeInsets Symetric Vertical
  EdgeInsets vertical() => EdgeInsets.symmetric(vertical: _padding.sp);

  // EdgeInsets Only Top
  EdgeInsets onlyTop() => EdgeInsets.only(top: _padding.sp);

  // EdgeInsets Only Bottom
  EdgeInsets onlyBottom() => EdgeInsets.only(bottom: _padding.sp);

  // EdgeInsets Only Left
  EdgeInsets onlyLeft() => EdgeInsets.only(left: _padding.sp);

  // EdgeInsets Only Right
  EdgeInsets onlyRight() => EdgeInsets.only(right: _padding.sp);

  EdgeInsets customPadding({double? top, double? right, double? bottom, double? left}) {
    return EdgeInsets.only(
      top: (top ?? _padding).sp,
      right: (right ?? _padding).sp,
      bottom: (bottom ?? _padding).sp,
      left: (left ?? _padding).sp,
    );
  }
}

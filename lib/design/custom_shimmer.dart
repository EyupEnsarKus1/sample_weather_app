import 'package:flutter/material.dart';
import 'package:sample_weather_app/design/app_colors.dart';
import 'package:sample_weather_app/design/app_sizes.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double? radius;
  const ShimmerContainer({
    Key? key,
    required this.width,
    required this.height,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + padding.horizontal,
      height: height + padding.vertical,
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.shimmerBackgroundColor(Theme.of(context).brightness),
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
        ),
      ),
    );
  }
}

Size getTextSize(String text, TextStyle style, int numberOfLines) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: numberOfLines, textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

class TextShimmer extends StatelessWidget {
  final int numberOfLines;
  final TextStyle textStyle;
  final int textLength;
  const TextShimmer({Key? key, required this.textStyle, this.numberOfLines = 1, this.textLength = 10}) : super(key: key);

  String get buildString {
    String text = "";

    for (int k = 0; k < textLength; k++) {
      text += "a";
    }

    return text.substring(0, text.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    Size _txtSize;
    _txtSize = getTextSize(buildString, textStyle, numberOfLines);
    final double paddingAmount = AppSizes.size4 / 4;
    if (numberOfLines > 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          numberOfLines,
          (index) {
            return ShimmerContainer(
              margin: EdgeInsets.symmetric(
                vertical: paddingAmount,
                horizontal: paddingAmount,
              ),
              width: index == numberOfLines - 1 ? (_txtSize.width - paddingAmount * 2) : (MediaQuery.of(context).size.width - paddingAmount * 2),
              height: _txtSize.height - paddingAmount * 2,
            );
          },
        ),
      );
    }

    return ShimmerContainer(
      margin: EdgeInsets.symmetric(
        vertical: paddingAmount,
        horizontal: paddingAmount,
      ),
      width: _txtSize.width - paddingAmount * 2,
      height: _txtSize.height - paddingAmount * 2,
    );
  }
}

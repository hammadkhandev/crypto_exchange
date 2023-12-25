import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'colors.dart';

decorationBackgroundGradient() => BoxDecoration(
    gradient: LinearGradient(
        colors: gIsDarkMode ? bgGradientDarkColors : bgGradientColors,
        stops: const [-0.5, -0.9, 0.25, 0.6, 1.5, 2],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft),
    borderRadius: const BorderRadius.all(Radius.circular(5)));

boxDecorationRoundCorner({Color? color, double radius = 7}) {
  color = color ?? (gIsDarkMode ? Get.theme.colorScheme.background : Get.theme.dividerColor.withOpacity(0.25));
  return BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(radius)));
}

boxDecorationRoundBorder({Color? color, Color? borderColor, double radius = 7}) {
  color = color ?? Get.theme.scaffoldBackgroundColor;
  borderColor = borderColor ?? Get.theme.secondaryHeaderColor;
  return BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(radius)), border: Border.all(color: borderColor, width: 1));
}

boxDecorationWithShadow({Color? color, double radius = 7}) {
  color = color ?? Get.theme.scaffoldBackgroundColor;
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    boxShadow: [
      BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 0, blurRadius: 1, offset: const Offset(1, 1) // Shadow position
          ),
    ],
  );
}

boxDecorationTopRound({Color? color, bool isGradient = false, double radius = 7}) {
  color = color ?? Get.theme.scaffoldBackgroundColor;
  return BoxDecoration(
      color: isGradient ? null : color,
      gradient: isGradient ? linearGradient(color) : null,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius)));
}

boxDecorationImage({required String imagePath, Color? color}) {
  ColorFilter? colorFilter;
  if (color != null) colorFilter = ColorFilter.mode(color, BlendMode.dstATop);

  return BoxDecoration(image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover, colorFilter: colorFilter));
}

getRoundCornerWithShadow({Color color = cWhite}) {
  return BoxDecoration(
    color: color,
    borderRadius: const BorderRadius.all(Radius.circular(7)),
    boxShadow: [
      BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 0, blurRadius: 1, offset: const Offset(1, 1)),
    ],
  );

  ///Offset is the Shadow position
}

getRoundCornerBorderOnlyTop({Color bgColor = cWhite}) {
  return BoxDecoration(
    color: bgColor,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
  );
}

decorationRoundCornerBox({Color color = cWhite}) {
  return BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(7)));
}

getRoundCornerBorderOnlyBottom() {
  return const BoxDecoration(
    color: cWhite,
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(7)),
  );
}

getRoundSoftTransparentBox() {
  return BoxDecoration(color: Get.theme.primaryColor.withOpacity(0.03), borderRadius: const BorderRadius.all(Radius.circular(7)));
}

boxDecorationUnselectedTab({Color borderColor = cSlateGray, double radius = 15}) {
  return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(radius)), border: Border.all(color: borderColor, width: 0.25));
}

boxDecoration({Color color = cCharleston, bool isGradient = false, double radius = 0}) {
  return BoxDecoration(
    color: isGradient ? null : color,
    gradient: isGradient ? linearGradient(color) : null,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

boxDecorationLeftRound({Color color = cCharleston, double radius = 7}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    ),
  );
}

linearGradient(Color color) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [color.withOpacity(0.9), color],
  );
}

decorationBottomBorder() {
  return BoxDecoration(
    border: Border(bottom: BorderSide(color: Get.theme.secondaryHeaderColor.withOpacity(.5), width: 1)),
  );
}

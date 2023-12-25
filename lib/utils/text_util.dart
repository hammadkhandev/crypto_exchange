import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'common_utils.dart';
import 'decorations.dart';
import 'dimens.dart';

Widget textAutoSizeTitle(String text, {int maxLines = 2, Color? color, double? fontSize, TextAlign textAlign = TextAlign.center}) {
  return AutoSizeText(text,
      maxLines: maxLines,
      minFontSize: 10,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      //Font: dmSans
      style: Get.theme.textTheme.titleSmall!.copyWith(color: color, fontSize: fontSize));
}

Widget textAutoSizePoppins(String text,
    {int maxLines = 1,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.center,
    double? fontSize,
    TextDecoration? decoration}) {
  return AutoSizeText(text,
      maxLines: maxLines,
      minFontSize: 10,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: Get.theme.textTheme.labelSmall!.copyWith(color: color, fontWeight: fontWeight, fontSize: fontSize, decoration: decoration));
}

Widget textAutoSizeKarla(String text,
    {int maxLines = 1, Color? color, FontWeight? fontWeight, TextAlign textAlign = TextAlign.center, double? fontSize, double minFontSize = 10}) {
  return AutoSizeText(text,
      maxLines: maxLines,
      minFontSize: minFontSize,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: Get.theme.textTheme.bodyLarge!.copyWith(color: color, fontWeight: fontWeight, fontSize: fontSize));
}

Widget textAutoSizeRoboto(String text,
    {int maxLines = 1,
      Color? color,
      FontWeight? fontWeight,
      TextAlign? textAlign,
      double? fontSize,
      TextDecoration? decoration}) {
  return AutoSizeText(text,
      maxLines: maxLines,
      minFontSize: 10,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: Get.theme.textTheme.bodySmall!.copyWith(color: color, fontWeight: fontWeight, fontSize: fontSize, decoration: decoration));
}

Widget textDecoration(String text,
    {VoidCallback? onTap,
    double hMargin = 10,
    int maxLines = 1,
    Color? color,
    double? width,
    TextDecoration decoration = TextDecoration.underline,
    TextAlign textAlign = TextAlign.end,
    double fontSize = 12}) {
  var colorL = color ?? Get.theme.primaryColor;
  var widthL = width ?? Get.width;
  return Container(
    margin: EdgeInsets.only(left: hMargin, right: hMargin),
    width: widthL,
    child: InkWell(
      onTap: onTap,
      child: AutoSizeText(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        minFontSize: 10,
        textAlign: textAlign,
        style: Get.textTheme.labelSmall!.copyWith(color: colorL, decoration: decoration, fontSize: fontSize),
      ),
    ),
  );
}

Widget textSpanWithAction(String main, String clickAble, VoidCallback onTap,
    {int maxLines = 1,
    double? fontSize,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight = FontWeight.bold,
    Color? mainColor,
    Color? subColor}) {
  mainColor = mainColor ?? Get.theme.primaryColorLight;
  subColor = subColor ?? Get.theme.colorScheme.secondary;
  return AutoSizeText.rich(
    TextSpan(
      text: main,
      style: Get.theme.textTheme.bodyMedium!.copyWith(fontSize: fontSize, fontWeight: fontWeight, color: mainColor),
      children: <TextSpan>[
        TextSpan(
            text: " $clickAble",
            style: Get.theme.textTheme.bodyMedium!.copyWith(fontSize: fontSize, color: subColor, fontWeight: fontWeight),
            recognizer: TapGestureRecognizer()..onTap = onTap),
      ],
    ),
    maxLines: maxLines,
    textAlign: textAlign,
  );
}

Widget textWithCopyButton(String text) {
  return Container(
      padding: const EdgeInsets.all(5),
      decoration: boxDecorationRoundCorner(color: Get.theme.colorScheme.background),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Align(alignment: Alignment.center, child: AutoSizeText(text, style: Get.theme.textTheme.bodyMedium, maxLines: 2))),
          buttonOnlyIcon(iconPath: AssetConstants.icCopy, iconColor: Get.theme.colorScheme.secondary, onPressCallback: () => copyToClipboard(text))
        ],
      ));
}

textWithCopyView(String text) {
  return Row(
    children: [
      textAutoSizeKarla(text, fontSize: Dimens.regularFontSizeMid, maxLines: 2),
        buttonOnlyIcon(
            iconPath: AssetConstants.icCopy,
            visualDensity: minimumVisualDensity,
            iconColor: Get.theme.colorScheme.secondary,
            onPressCallback: () => copyToClipboard(text))
    ],
  );
}


Widget textWithBackground(String text, {double? width, double? height, int maxLines = 4, Color bgColor = Colors.green, Color? textColor}) {
  return Container(
    padding: const EdgeInsets.all(10),
    width: width ?? Get.width,
    height: height,
    decoration: boxDecorationRoundCorner(color: bgColor),
    child: textAutoSizePoppins(text,
        color: textColor ?? Get.theme.primaryColor, maxLines: maxLines, textAlign: TextAlign.start, fontWeight: FontWeight.bold),
  );
}

// Here it is!
Size getTextSize(String text, TextStyle style, {int? maxLine, double? width, double? scale}) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style), maxLines: maxLine ?? 100, textDirection: TextDirection.ltr, textScaleFactor: scale ?? 1)
    ..layout(minWidth: 0, maxWidth: width ?? Get.width);
  return textPainter.size;
}



import 'package:flutter/material.dart';

const Color cWhite = Color(0xffffffff);
const Color cSnow = Color(0xffFAFAFA);
const Color cAccent = cSunGlow;//chotMagenta;
const Color cUfoGreen = Color(0xff32D777);
const Color cCharleston = cBlack;//Color(0xff23262F);
const Color cOnyx = cBlack;//Color(0xff353945);
const Color cMintCream = Color(0xffF5FFF9);
const Color cCultured = Color(0xffF7F7F8);
const Color cSlateGray = Color(0xff777E90);
const Color cSonicSilver = Color(0xffBBBBBC);
const Color cDeepCarminePink = Color(0xffFF2E2E);
const Color cGainsboro = Color(0xffDDDDDD);
const Color cBlack = Color(0xff000000);
const Color cRedPigment = Color(0xffF31629);
const Color cSunGlow = Color(0xffff0bc8);//ff0bc8//#FD21CB
const Color cSunGlowDark = Color(0xff7A005E);//#7A005E
const Color cBoldYellow = Color(0xFFEAC41C);

const Color cOrange = Color(0xFFFFA400);

const List<Color> bgGradientColors = <Color>[
  Color(0xFFfe86e2),
  Color(0xFFfe72dd),
  Color(0xFFfd5dd8),
  Color(0xFFfd49d3),
  Color(0xFFfd35ce),
  Color(0xFFff0bc8)//FD21CB
];
const List<Color> bgGradientDarkColors = <Color>[
  Color(0xFFE1D0DE),
  Color(0xFFDFCDDC),
  Color(0xFFCFB4CA),
  Color(0xFFBF9BB9),
  Color(0xFFAF83A8),
  Color(0xFF7C5075)//#895881
];

int getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return int.parse(hexColor, radix: 16);
}

const List<Color> bsColorFresh = <Color>[Color(0xFF32d777), Color(0xFFd63031)];
const List<Color> bsColorTradition = <Color>[Color(0xFF3498db), Color(0xFF9b59b6)];
const List<Color> bsColorVisionD = <Color>[Color(0xFFf39c12), Color(0xFFd35400)];
const List<List<Color>> bsColorList = [bsColorFresh, bsColorTradition, bsColorVisionD];

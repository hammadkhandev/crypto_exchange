import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import '../data/local/constants.dart';
import 'colors.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    textTheme: lightTextTheme,
    colorScheme: ThemeData.light().colorScheme.copyWith(secondary: cAccent, background: cWhite),
    primaryColor: cCharleston,
    primaryColorLight: cSlateGray,
    primaryColorDark: cBlack,
    scaffoldBackgroundColor: cSnow,
    secondaryHeaderColor: cSlateGray,
    dividerColor: cGainsboro,
    focusColor: cAccent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: cWhite, selectedItemColor: cAccent, unselectedItemColor: cSlateGray),
    buttonTheme: const ButtonThemeData(buttonColor: cAccent, disabledColor: cSlateGray),
  );

  static final lightTextTheme = TextTheme(
    titleSmall: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: cCharleston, fontSize: Dimens.titleFontSizeSmall),
    labelSmall: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: cSlateGray, fontSize: Dimens.regularFontSizeSmall),
    bodyLarge: GoogleFonts.karla(fontWeight: FontWeight.bold, color: cCharleston, fontSize: Dimens.titleFontSizeSmall),
    //for button
    labelLarge: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: cWhite, fontSize: Dimens.buttonFontSize),
    //For TextField
    bodyMedium: GoogleFonts.karla(fontWeight: FontWeight.normal, color: cCharleston, fontSize: Dimens.regularFontSizeMid),
    //For Support currency symbol
    bodySmall: GoogleFonts.roboto(fontWeight: FontWeight.normal, color: cSlateGray, fontSize: Dimens.regularFontSizeSmall),


  );

  static final dark = ThemeData.dark().copyWith(
    textTheme: darkTextTheme,
    colorScheme: ThemeData.light().colorScheme.copyWith(secondary: cAccent, background: cOnyx),
    primaryColor: cWhite,
    primaryColorLight: cSnow,
    primaryColorDark: cGainsboro,
    scaffoldBackgroundColor: cCharleston,
    secondaryHeaderColor: cSlateGray,
    dividerColor: cGainsboro,
    focusColor: cAccent,
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: cSonicSilver, selectedItemColor: cAccent, unselectedItemColor: cSnow),
    buttonTheme: const ButtonThemeData(buttonColor: cAccent, disabledColor: cSlateGray),
  );

  static final darkTextTheme = TextTheme(
    titleSmall: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: cWhite, fontSize: Dimens.titleFontSizeSmall),
    labelSmall: GoogleFonts.roboto(fontWeight: FontWeight.normal, color: cSonicSilver, fontSize: Dimens.regularFontSizeSmall),
    bodyLarge: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: cWhite, fontSize: Dimens.titleFontSizeSmall),
    //for button
    labelLarge: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: cWhite, fontSize: Dimens.buttonFontSize),
    //For TextField
    bodyMedium: GoogleFonts.roboto(fontWeight: FontWeight.normal, color: cWhite, fontSize: Dimens.regularFontSizeMid),
    //For Support currency symbol
    bodySmall: GoogleFonts.roboto(fontWeight: FontWeight.normal, color: cSonicSilver, fontSize: Dimens.regularFontSizeSmall),
  );
}

/// *** NOTE: get the view main colors by context (like background) *** ///
class ThemeService {
  ThemeMode get theme => loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool loadThemeFromBox() => GetStorage().read(PreferenceKey.isDark) ?? !false;

  _saveThemeToBox(bool isDarkMode) => GetStorage().write(PreferenceKey.isDark, isDarkMode);

  void switchTheme() {
    var isDark = loadThemeFromBox();
    gIsDarkMode = !gIsDarkMode;
    Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!isDark);
  }
}

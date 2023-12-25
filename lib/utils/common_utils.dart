import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/language_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';

void showToast(String? text, {bool isError = true, bool isLong = false, BuildContext? context}) {
  if (text.isValid) {
    context = context ?? currentContext;
    if (context != null) {
      Widget toast = Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: boxDecorationRoundCorner(radius: 25, color: isError ? Colors.red : Theme.of(context).primaryColor),
          child: textAutoSizePoppins(text!, color: isError ? Colors.white : Theme.of(context).colorScheme.background, maxLines: 10));
      FToast().init(context).showToast(child: toast, gravity: ToastGravity.BOTTOM, toastDuration: Duration(seconds: isLong ? 5 : 2));
    } else {
      Fluttertoast.showToast(
          msg: text!,
          toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: isError ? Colors.red : Get.theme.primaryColor,
          textColor: isError ? Colors.white : Get.theme.colorScheme.background);
    }
  }
}

void showLoadingDialog({bool isDismissible = false}) {
  if (Get.isDialogOpen == null || !Get.isDialogOpen!) {
    Get.dialog(Center(child: CircularProgressIndicator(color: Get.theme.focusColor)), barrierDismissible: isDismissible);
  }
}

VisualDensity get minimumVisualDensity => const VisualDensity(horizontal: -4, vertical: -4);

void hideLoadingDialog() {
  if (Get.isDialogOpen != null && Get.isDialogOpen!) {
    Get.back();
  }
}

void hideKeyboard({BuildContext? context}) {
  if (context == null) {
    FocusManager.instance.primaryFocus?.unfocus();
  } else if (FocusScope.of(context).canRequestFocus) {
    FocusScope.of(context).unfocus();
  }
}

void printFunction(String tag, dynamic data) {
  if (kDebugMode) GetUtils.printFunction("$tag => ", data, "");
}

void clearStorage() {
  var storage = GetStorage();
  storage.write(PreferenceKey.accessToken, "");
  storage.write(PreferenceKey.accessTokenEvm, "");
  storage.write(PreferenceKey.isLoggedIn, false);
  storage.write(PreferenceKey.userObject, {});
}

void editTextFocusDisable(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

String getEnumString(dynamic enumValue) {
  String string = enumValue.toString();
  try {
    string = string.split(".").last;
    return string;
  } catch (_) {}
  return "";
}

void callToNumber(String number) async {
  if (number.isEmpty) {
    showToast("The phone number has not been available".tr, isError: true);
    return;
  }
  String url = "tel:$number";
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    showToast("The phone number is invalid".tr, isError: true);
  }
}

void smsToNumber(String number) async {
  if (number.isEmpty) {
    showToast("The phone number has not been available".tr, isError: true);
    return;
  }
  String url = "sms:$number";
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    showToast("The phone number is invalid".tr, isError: true);
  }
}

void shareText(String? text) => Share.share(text ?? "");

bool systemThemIsDark() => true;//SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

void copyToClipboard(String string) {
  Clipboard.setData(ClipboardData(text: string)).then((_) {
    showToast("Text copied to clipboard".tr, isError: false);
  });
}

void openUrlInBrowser(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    showToast("The URL is invalid".tr, isError: true);
  }
}

bool isValidPassword(String value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{6,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

String removeSpecialChar(String? text) {
  if (text != null && text.isNotEmpty) {
    return text.replaceAll(RegExp(r'[^\w\s]+'), '');
  }
  return "";
}

Future<String> htmlString(String path) async {
  String fileText = await rootBundle.loadString(path);
  String htmlStr = Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString();
  return htmlStr;
}

Widget dividerHorizontal({Color? color, double height = 20, double? indent, double? width}) {
  return SizedBox(
    width: width,
    child: Divider(height: height, color: color, thickness: 1, endIndent: indent, indent: indent),
  );
}

Widget dividerVertical({Color? color, double width = 10, double? height, double? indent}) {
  return SizedBox(
    height: height,
    child: VerticalDivider(width: width, color: color, thickness: 2, endIndent: indent, indent: indent),
  );
}

double getContentHeight({bool withBottomNav = false, bool withToolbar = false}) {
  var padding = Get.statusBarHeight + Get.bottomBarHeight;
  if (withBottomNav) {
    padding = padding + kBottomNavigationBarHeight;
  }
  if (withToolbar) {
    padding = padding + kToolbarHeight;
  }
  return Get.height - padding;
}

String getMapKey(String? value, Map? map) {
  if (!value.isValid || map == null) return "";
  final key = map.keys.firstWhere((k) => map[k] == value, orElse: () => "");
  return key;
}

void showCountriesPicker(BuildContext context, Function(Country) onChange) {
  showCountryPicker(
    context: context,
    showPhoneCode: false,
    onSelect: onChange,
  );
}

///fk_user_agent: ^2.1.0
Future<String> getUserAgent() async {
  try {
    await FkUserAgent.init();
    var platformVersion = FkUserAgent.userAgent!;
    return platformVersion;
  } on PlatformException {
    printFunction("getUserAgent", 'Failed to get platform version.');
    return "";
  }
}

//package_info_plus: ^3.0.1
Future<String> getAppId() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.packageName;
}

void openDatePicker(BuildContext context,
    {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate, Function(DateTime)? onPicked, DatePickerEntryMode? initialEntryMode}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    locale: LanguageUtil.getCurrentLocal(),
    initialEntryMode: initialEntryMode ?? DatePickerEntryMode.calendarOnly,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime.now().add(const Duration(days: 1000)),
    builder: (context, Widget? child) => Theme(
        data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
                primary: context.theme.focusColor, onPrimary: context.theme.scaffoldBackgroundColor, onSurface: context.theme.primaryColor),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: context.theme.primaryColor))),
        child: child!),
  );
  if (picked != null && onPicked != null) onPicked(picked);
}

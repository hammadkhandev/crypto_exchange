import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';

const dateFormatYyyyMMDd = "yyyy-MM-dd";
const dateTimeFormatYyyyMMDdHhMm = "yyyy-MM-dd kk:mm";
const dateFormatMMDdYyyy = "MM/dd/yyyy";
const dateFormatMMDdYyyyHhMmSs = "MM:dd:yyyy hh:mm:ss";
const dateFormatMMDdYyyy2 = "MM:dd:yyyy";
const dateFormatMMMMDddYyy = "MMMM dd, yyyy";
const dateTimeFormatDdMMMMYyyyHhMm = "dd MMMM yyyy | hh:mm a";


String formatDate(DateTime? dateTime, {String format = dateFormatYyyyMMDd}) {
  if (dateTime != null) {
    String formatStr = DateFormat(format).format(dateTime.toLocal());
    return formatStr;
  } else {
    return "";
  }
}

DateTime? stringToDate(String date, {String format = dateFormatYyyyMMDd} ) {
  try {
    DateTime tempDate = DateFormat(format).parse(date);
    return tempDate;
  } catch (e) {
    return null;
  }
}

String formatDateForInbox(DateTime? dateTime) {
  if (dateTime != null) {
    String formatStr = "";
    DateTime now = DateTime.now();
    var diffDt = now.difference(dateTime);
    if (diffDt.inDays > 0) {
      formatStr = formatDate(dateTime, format: dateTimeFormatDdMMMMYyyyHhMm);
    } else if (diffDt.inHours > 0) {
      formatStr = "${diffDt.inHours}" " Hours ago".tr;
    } else if (diffDt.inMinutes > 0) {
      formatStr = "${diffDt.inMinutes}" " Minutes ago".tr;
    } else {
      formatStr = "Just now".tr;
    }
    return formatStr;
  }
  return "";
}

String getVerboseDateTimeRepresentation(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime justNow = now.subtract(const Duration(minutes: 1));
  DateTime localDateTime = dateTime.toLocal();

  if (!localDateTime.difference(justNow).isNegative) {
    return 'Just Now'.tr;
  }

  String roughTimeString = DateFormat('jm').format(dateTime);
  if (localDateTime.day == now.day && localDateTime.month == now.month && localDateTime.year == now.year) {
    return 'Today, $roughTimeString';
  }

  DateTime yesterday = now.subtract(const Duration(days: 1));

  if (localDateTime.day == yesterday.day && localDateTime.month == now.month && localDateTime.year == now.year) {
    return 'Yesterday, $roughTimeString';
  }

  if (now.difference(localDateTime).inDays < 4) {
    String weekday = DateFormat('EEEE').format(localDateTime);

    return '$weekday, $roughTimeString';
  }

  return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
}

DateTime? makesDate(Map<String, dynamic> json, String key, {bool isDefault = false}) {
  if (json.containsKey(key)) {
    var value = json[key];
    if (value is String && value.isNotEmpty) {
      if (!value.contains("z") && !value.contains("Z")) {
        value = "${value}Z";
      }
      return DateTime.parse(value);
    }
  }
  if (isDefault) {
    return DateTime.now();
  }
  return null;
}

String dateDifference(DateTime? start, DateTime? end) {
  var startDate = start ?? DateTime.now();
  var endDate = end ?? DateTime.now();
  var difference = endDate.difference(startDate);
  if (difference.inDays > 364) {
    return "${difference.inDays / 365} ${"Years".tr}";
  } else if (difference.inDays > 29) {
    return "${difference.inDays / 30} ${"Months".tr}";
  } else {
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return "${difference.inMinutes} ${"Minutes".tr}";
      } else {
        return "${difference.inHours} ${"Hours".tr}";
      }
    } else {
      return "${difference.inDays} ${"Days".tr}";
    }
  }
}

int dateInSecond(DateTime? dateTime){
  if(dateTime != null){
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }
  return 0;
}

DateTime dateFromSecond(int? time){
  if(time != null){
    final date = DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true);
    return date.toLocal();
  }
  return DateTime.now();
}

///  flutter_datetime_picker: ^1.5.1
// void showDateTimePicker(BuildContext context, Function(DateTime) onSelect) {
//   DatePicker.showDateTimePicker(context, showTitleActions: true, onConfirm: (date) {
//     onSelect(date);
//   }, minTime: DateTime.now(), maxTime: DateTime.now().add(const Duration(days: 180)));
// }

bool datePastInDay(DateTime dateTime, int days) {
  var startDate = DateTime.now();
  var difference = dateTime.difference(startDate);
  if (difference.inDays >= days) {
    return true;
  }
  return false;
}

DateTime? getDateWithTime(String? time){
  if(time.isValid){
    var dateStr = formatDate(DateTime.now().toUtc(), format: dateFormatMMDdYyyy2);
    dateStr = "$dateStr $time";
    final date = stringToDate(dateStr, format: dateFormatMMDdYyyyHhMmSs);
    return date;
  }
  return null;
}



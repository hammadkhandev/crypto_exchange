import 'dart:convert';

import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

///final socketResponse = socketResponseFromJson(jsonString);
SocketResponse socketResponseFromJson(String str) => SocketResponse.fromJson(json.decode(str));

String socketResponseToJson(SocketResponse data) => json.encode(data.toJson());

class SocketResponse {
  SocketResponse({this.channel, this.event, this.data});

  String? channel;
  String? event;
  String? data;

  factory SocketResponse.fromJson(Map<String, dynamic> json) => SocketResponse(channel: json["channel"], event: json["event"], data: json["data"]);

  Map<String, dynamic> toJson() => {"channel": channel, "event": event, "data": data};
}

/// *** App Notification *** ///
NotificationData notificationDataFromJson(String str) => NotificationData.fromJson(json.decode(str));

class NotificationData {
  NotificationData({this.success, this.userId, this.message, this.title});

  bool? success;
  int? userId;
  String? message;
  String? title;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(success: json["success"], userId: json["user_id"], message: json["message"], title: json["title"]);

  Map<String, dynamic> toJson() => {"success": success, "user_id": userId, "message": message, "title": title};

  String notifyMessage() {
    if (message.isValid) return message!;
    if (title.isValid) return title!;
    return "";
  }
}

/// *** ORDER Remove *** ///
OrderRemove orderRemoveFromJson(String str) => OrderRemove.fromJson(json.decode(str));

class OrderRemove {
  OrderRemove({this.orderType, this.price, this.amount, this.mySize, this.total, this.baseCoinId, this.tradeCoinId});

  String? orderType;
  double? price;
  double? amount;
  double? mySize;
  double? total;
  int? baseCoinId;
  int? tradeCoinId;

  factory OrderRemove.fromJson(Map<String, dynamic> json) => OrderRemove(
      orderType: json["orderType"],
      price: makeDouble(json["price"]),
      amount: makeDouble(json["amount"]),
      mySize: makeDouble(json["my_size"]),
      total: makeDouble(json["total"]),
      baseCoinId: makeInt(json["base_coin_id"]),
      tradeCoinId: makeInt(json["trade_coin_id"]));
}

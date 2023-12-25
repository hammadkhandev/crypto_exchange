
import 'dart:convert';
import '../../utils/date_util.dart';
import '../../utils/number_util.dart';

//final pixeerNotification = pixeerNotificationFromJson(jsonString);
AppNotification pixeerNotificationFromJson(String str) => AppNotification.fromJson(json.decode(str));

String pixeerNotificationToJson(AppNotification data) => json.encode(data.toJson());

class AppNotification {
  AppNotification({
    required this.id,
    this.userId,
    this.title,
    this.notificationBody,
    this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int? userId;
  String? title;
  String? notificationBody;
  int? status;
  int? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json["id"],
    userId: makeInt(json["user_id"]),
    title: json["title"],
    notificationBody: json["notification_body"],
    status: makeInt(json["status"]),
    type: makeInt(json["type"]),
    createdAt: makesDate(json, "created_at"),
    updatedAt: makesDate(json, "updated_at"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "notification_body": notificationBody,
    "status": status,
    "type": type,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

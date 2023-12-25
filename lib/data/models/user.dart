import 'dart:convert';

import 'package:tradexpro_flutter/data/models/referral.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    this.firstName,
    this.lastName,
    this.nickName,
    this.email,
    this.country,
    this.google2FaSecret,
    this.phoneVerified,
    this.phone,
    this.gender,
    this.birthDate,
    this.photo,
    this.status,
    this.role,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.countryName,
    this.language,
    this.deviceId,
    this.deviceType,
    this.pushNotificationStatus,
    this.emailNotificationStatus,
    this.google2Fa,
    this.g2FEnabled,
    this.affiliate,
  });

  int id;
  String? firstName;
  String? lastName;
  String? nickName;
  String? email;
  String? country;
  String? phone;
  int? gender;
  DateTime? birthDate;
  String? photo;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? currency;
  String? countryName;

  int? role;
  int? status;
  int? isVerified;
  int? g2FEnabled;
  String? google2FaSecret;
  int? phoneVerified;
  String? language;
  String? deviceId;
  int? deviceType;
  int? pushNotificationStatus;
  int? emailNotificationStatus;
  int? google2Fa;
  Affiliate? affiliate;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        nickName: json["nickname"],
        email: json["email"],
        country: json["country"],
        google2FaSecret: json["google2fa_secret"],
        phoneVerified: json["phone_verified"],
        phone: json["phone"],
        gender: json["gender"],
        birthDate: json["birth_date"] == null ? null : DateTime.parse(json["birth_date"]),
        photo: json["photo"],
        status: json["status"],
        role: json["role"],
        isVerified: json["is_verified"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        currency: json["currency"],
        countryName: json["country_name"],
        language: json["language"],
        deviceId: json["device_id"],
        deviceType: json["device_type"],
        pushNotificationStatus: json["push_notification_status"],
        emailNotificationStatus: json["email_notification_status"],
        google2Fa: json["google2fa"],
        g2FEnabled: makeInt(json["g2f_enabled"]),
        affiliate: json["affiliate"] == null ? null : Affiliate.fromJson(json["affiliate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "nickname": nickName,
        "email": email,
        "country": country,
        "google2fa_secret": google2FaSecret,
        "phone_verified": phoneVerified,
        "phone": phone,
        "gender": gender,
        "birth_date": birthDate,
        "photo": photo,
        "status": status,
        "role": role,
        "is_verified": isVerified,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "currency": currency,
        "country_name": countryName,
        "language": language,
        "device_id": deviceId,
        "device_type": deviceType,
        "push_notification_status": pushNotificationStatus,
        "email_notification_status": emailNotificationStatus,
        "google2fa": google2Fa,
        "g2f_enabled": g2FEnabled,
        "affiliate": affiliate == null ? null : affiliate!.toJson(),
      };

  User createNewInstance() {
    var userMap = toJson();
    return User.fromJson(userMap);
  }
}

//// final userActivity = userActivityFromJson(jsonString);

UserActivity userActivityFromJson(String str) => UserActivity.fromJson(json.decode(str));

String userActivityToJson(UserActivity data) => json.encode(data.toJson());

class UserActivity {
  UserActivity({
    required this.id,
    required this.userId,
    this.action,
    this.source,
    this.ipAddress,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  String? action;
  String? source;
  String? ipAddress;
  String? location;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserActivity.fromJson(Map<String, dynamic> json) => UserActivity(
        id: json["id"],
        userId: json["user_id"],
        action: json["action"],
        source: json["source"],
        ipAddress: json["ip_address"],
        location: json["location"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "action": action,
        "source": source,
        "ip_address": ipAddress,
        "location": location,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

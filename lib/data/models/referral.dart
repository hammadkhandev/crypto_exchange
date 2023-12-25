import 'dart:convert';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

ReferralData referralFromJson(String str) => ReferralData.fromJson(json.decode(str));

String referralToJson(ReferralData data) => json.encode(data.toJson());

class ReferralData {
  ReferralData({
    this.title,
    this.user,
    this.referrals,
    this.url,
    this.referralLevel,
    this.select,
    this.maxReferralLevel,
    this.totalReward,
    this.monthlyEarningHistories,
    this.countReferrals,
  });

  String? title;
  User? user;
  List<Referral>? referrals;
  String? url;
  Map<String, int>? referralLevel;
  String? select;
  int? maxReferralLevel;
  int? totalReward;
  List<Earning>? monthlyEarningHistories;
  int? countReferrals;

  factory ReferralData.fromJson(Map<String, dynamic> json) => ReferralData(
        title: json["title"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        referrals: json["referrals"] == null ? null : List<Referral>.from(json["referrals"].map((x) => Referral.fromJson(x))),
        url: json["url"],
        referralLevel: json["referralLevel"] == null ? null : Map.from(json["referralLevel"]).map((k, v) => MapEntry<String, int>(k, v)),
        select: json["select"],
        maxReferralLevel: json["max_referral_level"],
        totalReward: json["total_reward"],
        monthlyEarningHistories:
            json["monthlyEarningHistories"] == null ? null : List<Earning>.from(json["monthlyEarningHistories"].map((x) => Earning.fromJson(x))),
        countReferrals: json["count_referrals"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "user": user == null ? null : user!.toJson(),
        "referrals": referrals == null ? null : List<dynamic>.from(referrals!.map((x) => x.toJson())),
        "url": url,
        "referralLevel": referralLevel == null ? null : Map.from(referralLevel!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "select": select,
        "max_referral_level": maxReferralLevel,
        "total_reward": totalReward,
        "monthlyEarningHistories": monthlyEarningHistories == null ? null : List<Earning>.from(monthlyEarningHistories!.map((x) => x.toJson())),
        "count_referrals": countReferrals,
      };
}

class Referral {
  Referral({
    this.id,
    this.fullName,
    this.email,
    this.joiningDate,
    this.level,
  });

  int? id;
  String? fullName;
  String? email;
  DateTime? joiningDate;
  String? level;

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        joiningDate: json["joining_date"] == null ? null : DateTime.parse(json["joining_date"]),
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "joining_date": joiningDate?.toIso8601String(),
        "level": level,
      };
}

class Affiliate {
  Affiliate({
    required this.id,
    this.userId,
    this.code,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int? userId;
  String? code;
  int? status;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Affiliate.fromJson(Map<String, dynamic> json) => Affiliate(
        id: json["id"],
        userId: json["user_id"],
        code: json["code"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "code": code,
        "status": status,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

Earning earningFromJson(String str) => Earning.fromJson(json.decode(str));

String earningToJson(Earning data) => json.encode(data.toJson());

class Earning {
  Earning({
    required this.id,
    this.coinType,
    this.transactionId,
    this.amount,
    this.level,
  });

  int id;
  String? coinType;
  String? transactionId;
  double? amount;
  int? level;

  factory Earning.fromJson(Map<String, dynamic> json) => Earning(
        id: json["id"],
        coinType: json["coin_type"],
        transactionId: json["transaction_id"],
        level: json["level"],
        amount: makeDouble(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coin_type": coinType,
        "transaction_id": transactionId,
        "amount": amount,
        "level": level,
      };
}

ReferralHistory referralHistoryFromJson(String str) => ReferralHistory.fromJson(json.decode(str));

String referralHistoryToJson(ReferralHistory data) => json.encode(data.toJson());

class ReferralHistory {
  ReferralHistory({
    required this.id,
    this.tradeBy,
    this.userId,
    this.childId,
    this.amount,
    this.percentageAmount,
    this.transactionId,
    this.level,
    this.coinType,
    this.walletId,
    this.createdAt,
    this.updatedAt,
    this.referenceUserEmail,
    this.referralUserEmail,
  });

  int id;
  int? tradeBy;
  int? userId;
  int? childId;
  double? amount;
  double? percentageAmount;
  String? transactionId;
  int? level;
  String? coinType;
  int? walletId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? referenceUserEmail;
  String? referralUserEmail;

  factory ReferralHistory.fromJson(Map<String, dynamic> json) => ReferralHistory(
        id: json["id"],
        tradeBy: json["trade_by"],
        userId: json["user_id"],
        childId: json["child_ id"],
        amount: makeDouble(json["amount"]),
        percentageAmount: makeDouble(json["percentage amount"]),
        transactionId: json["transaction_id"],
        level: json["level"],
        coinType: json["coin_type"],
        walletId: json["wallet_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        referenceUserEmail: json["reference_user_email"],
        referralUserEmail: json["referral_user_email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trade_by": tradeBy,
        "user_id": userId,
        "child_ id": childId,
        "amount": amount,
        "percentage amount": percentageAmount,
        "transaction_id": transactionId,
        "level": level,
        "coin_type": coinType,
        "wallet_id": walletId,
        "created_at": createdAt,
        "updated at": updatedAt,
        "reference_user_email": referenceUserEmail,
        "referral_user_email": referralUserEmail,
      };
}

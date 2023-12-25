import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

class StakingOffersData {
  List<String>? coinType;
  Map<String, List<StakingOffer>>? offerList;

  StakingOffersData({this.coinType, this.offerList});

  factory StakingOffersData.fromJson(Map<String, dynamic> json) => StakingOffersData(
        coinType: json["coin_type"] == null ? null : List<String>.from(json["coin_type"].map((x) => x)),
        offerList: (json["offer_list"] == null || json["offer_list"] is! Map)
            ? null
            : Map.from(json["offer_list"])
                .map((k, v) => MapEntry<String, List<StakingOffer>>(k, List<StakingOffer>.from(v.map((x) => StakingOffer.fromJson(x))))),
      );
}

class StakingOffer {
  int? id;
  String? uid;
  int? createdBy;
  String? coinType;
  int? period;
  double? offerPercentage;
  double? minimumInvestment;
  double? maximumInvestment;
  int? termsType;
  int? minimumMaturityPeriod;
  String? termsCondition;
  int? registrationBefore;
  int? phoneVerification;
  int? kycVerification;
  double? userMinimumHoldingAmount;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? totalInvestmentAmount;
  String? coinIcon;
  int? soldStatus;

  StakingOffer({
    this.id,
    this.uid,
    this.createdBy,
    this.coinType,
    this.period,
    this.offerPercentage,
    this.minimumInvestment,
    this.maximumInvestment,
    this.termsType,
    this.minimumMaturityPeriod,
    this.termsCondition,
    this.registrationBefore,
    this.phoneVerification,
    this.kycVerification,
    this.userMinimumHoldingAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalInvestmentAmount,
    this.coinIcon,
    this.soldStatus,
  });

  factory StakingOffer.fromJson(Map<String, dynamic> json) => StakingOffer(
        id: json["id"],
        uid: json["uid"],
        createdBy: json["created_by"],
        coinType: json["coin_type"],
        period: json["period"],
        offerPercentage: makeDouble(json["offer_percentage"]),
        minimumInvestment: makeDouble(json["minimum_investment"]),
        maximumInvestment: makeDouble(json["maximum_investment"]),
        termsType: json["terms_type"],
        minimumMaturityPeriod: json["minimum_maturity_period"],
        termsCondition: json["terms_condition"],
        registrationBefore: json["registration_before"],
        phoneVerification: json["phone_verification"],
        kycVerification: json["kyc_verification"],
        userMinimumHoldingAmount: makeDouble(json["user_minimum_holding_amount"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        totalInvestmentAmount: makeDouble(json["total_investment_amount"]),
        coinIcon: json["coin_icon"],
        soldStatus: json["sold_status"],
      );
}

class StakingOfferDetails {
  int? id;
  String? uid;
  int? createdBy;
  String? coinType;
  int? period;
  double? offerPercentage;
  double? minimumInvestment;
  double? maximumInvestment;
  int? termsType;
  int? minimumMaturityPeriod;
  String? termsCondition;
  int? registrationBefore;
  int? phoneVerification;
  int? kycVerification;
  double? userMinimumHoldingAmount;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? totalInvestmentAmount;
  String? coinIcon;
  DateTime? stakeDate;
  DateTime? valueDate;
  int? interestPeriod;
  DateTime? interestEndDate;

  StakingOfferDetails({
    this.id,
    this.uid,
    this.createdBy,
    this.coinType,
    this.period,
    this.offerPercentage,
    this.minimumInvestment,
    this.maximumInvestment,
    this.termsType,
    this.minimumMaturityPeriod,
    this.termsCondition,
    this.registrationBefore,
    this.phoneVerification,
    this.kycVerification,
    this.userMinimumHoldingAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalInvestmentAmount,
    this.coinIcon,
    this.stakeDate,
    this.valueDate,
    this.interestPeriod,
    this.interestEndDate,
  });

  factory StakingOfferDetails.fromJson(Map<String, dynamic> json) => StakingOfferDetails(
        id: json["id"],
        uid: json["uid"],
        createdBy: json["created_by"],
        coinType: json["coin_type"],
        period: json["period"],
        offerPercentage: makeDouble(json["offer_percentage"]),
        minimumInvestment: makeDouble(json["minimum_investment"]),
        maximumInvestment: makeDouble(json["maximum_investment"]),
        termsType: json["terms_type"],
        minimumMaturityPeriod: json["minimum_maturity_period"],
        termsCondition: json["terms_condition"],
        registrationBefore: json["registration_before"],
        phoneVerification: json["phone_verification"],
        kycVerification: json["kyc_verification"],
        userMinimumHoldingAmount: makeDouble(json["user_minimum_holding_amount"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        totalInvestmentAmount: makeDouble(json["total_investment_amount"]),
        coinIcon: json["coin_icon"],
        stakeDate: json["stake_date"] == null ? null : DateTime.parse(json["stake_date"]),
        valueDate: json["value_date"] == null ? null : DateTime.parse(json["value_date"]),
        interestPeriod: json["interest_period"],
        interestEndDate: json["interest_end_date"] == null ? null : DateTime.parse(json["interest_end_date"]),
      );
}

class StakingDetailsData {
  StakingOfferDetails? offerDetails;
  List<StakingOffer>? offerList;

  StakingDetailsData({this.offerDetails, this.offerList});

  factory StakingDetailsData.fromJson(Map<String, dynamic> json) => StakingDetailsData(
        offerDetails: json["offer_details"] == null ? null : StakingOfferDetails.fromJson(json["offer_details"]),
        offerList: json["offer_list"] == null ? null : List<StakingOffer>.from(json["offer_list"].map((x) => StakingOffer.fromJson(x))),
      );
}

class StakingInvestmentStatistics {
  List<Statistics>? totalInvestment;
  List<Statistics>? totalRunningInvestment;
  List<Statistics>? totalPaidInvestment;
  List<Statistics>? totalUnpaidInvestment;
  List<Statistics>? totalCancelInvestment;

  StakingInvestmentStatistics(
      {this.totalInvestment, this.totalRunningInvestment, this.totalPaidInvestment, this.totalUnpaidInvestment, this.totalCancelInvestment});

  factory StakingInvestmentStatistics.fromJson(Map<String, dynamic> json) => StakingInvestmentStatistics(
        totalInvestment: json["total_investment"] == null ? null : List<Statistics>.from(json["total_investment"].map((x) => Statistics.fromJson(x))),
        totalRunningInvestment: json["total_running_investment"] == null
            ? null
            : List<Statistics>.from(json["total_running_investment"].map((x) => Statistics.fromJson(x))),
        totalPaidInvestment:
            json["total_paid_investment"] == null ? null : List<Statistics>.from(json["total_paid_investment"].map((x) => Statistics.fromJson(x))),
        totalUnpaidInvestment: json["total_unpaid_investment"] == null
            ? null
            : List<Statistics>.from(json["total_unpaid_investment"].map((x) => Statistics.fromJson(x))),
        totalCancelInvestment: json["total_cancel_investment"] == null
            ? null
            : List<Statistics>.from(json["total_cancel_investment"].map((x) => Statistics.fromJson(x))),
      );
}

class Statistics {
  String? coinType;
  double? totalInvestment;

  Statistics({this.coinType, this.totalInvestment});

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      Statistics(coinType: json["coin_type"], totalInvestment: makeDouble(json["total_investment"]));
}

class Investment {
  int? id;
  String? uid;
  int? stakingOfferId;
  int? userId;
  String? coinType;
  int? period;
  double? offerPercentage;
  int? termsType;
  int? minimumMaturityPeriod;
  int? autoRenewStatus;
  int? status;
  double? investmentAmount;
  double? earnDailyBonus;
  double? totalBonus;
  dynamic autoRenewFrom;
  int? isAutoRenew;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? endDate;
  int? remainInterestDay;

  Investment({
    this.id,
    this.uid,
    this.stakingOfferId,
    this.userId,
    this.coinType,
    this.period,
    this.offerPercentage,
    this.termsType,
    this.minimumMaturityPeriod,
    this.autoRenewStatus,
    this.status,
    this.investmentAmount,
    this.earnDailyBonus,
    this.totalBonus,
    this.autoRenewFrom,
    this.isAutoRenew,
    this.createdAt,
    this.updatedAt,
    this.endDate,
    this.remainInterestDay,
  });

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
        id: json["id"],
        uid: json["uid"],
        stakingOfferId: json["staking_offer_id"],
        userId: json["user_id"],
        coinType: json["coin_type"],
        period: json["period"],
        offerPercentage: makeDouble(json["offer_percentage"]),
        termsType: json["terms_type"],
        minimumMaturityPeriod: json["minimum_maturity_period"],
        autoRenewStatus: json["auto_renew_status"],
        status: json["status"],
        investmentAmount: makeDouble(json["investment_amount"]),
        earnDailyBonus: makeDouble(json["earn_daily_bonus"]),
        totalBonus: makeDouble(json["total_bonus"]),
        autoRenewFrom: json["auto_renew_from"],
        isAutoRenew: json["is_auto_renew"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        remainInterestDay: json["remain_interest_day"],
      );
}

class StakingEarning {
  int? id;
  String? uid;
  int? userId;
  int? stakingInvestmentId;
  int? walletId;
  String? coinType;
  int? isAutoRenew;
  double? totalInvestment;
  double? totalBonus;
  double? totalAmount;
  int? investmentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  StakingEarning({
    this.id,
    this.uid,
    this.userId,
    this.stakingInvestmentId,
    this.walletId,
    this.coinType,
    this.isAutoRenew,
    this.totalInvestment,
    this.totalBonus,
    this.totalAmount,
    this.investmentStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory StakingEarning.fromJson(Map<String, dynamic> json) => StakingEarning(
        id: json["id"],
        uid: json["uid"],
        userId: json["user_id"],
        stakingInvestmentId: json["staking_investment_id"],
        walletId: json["wallet_id"],
        coinType: json["coin_type"],
        isAutoRenew: json["is_auto_renew"],
        totalInvestment: makeDouble(json["total_investment"]),
        totalBonus: makeDouble(json["total_bonus"]),
        totalAmount: makeDouble(json["total_amount"]),
        investmentStatus: json["investment_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class StakingLandingData {
  String? stakingLandingTitle;
  String? stakingLandingDescription;
  String? stakingLandingCoverImage;
  List<FAQ>? faqList;

  StakingLandingData({
    this.stakingLandingTitle,
    this.stakingLandingDescription,
    this.stakingLandingCoverImage,
    this.faqList,
  });

  factory StakingLandingData.fromJson(Map<String, dynamic> json) => StakingLandingData(
        stakingLandingTitle: json["staking_landing_title"],
        stakingLandingDescription: json["staking_landing_description"],
        stakingLandingCoverImage: json["staking_landing_cover_image"],
        faqList: json["faq_list"] == null ? null : List<FAQ>.from(json["faq_list"].map((x) => FAQ.fromJson(x))),
      );
}

import 'dart:convert';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

GiftCardsData giftCardsDataFromJson(String str) => GiftCardsData.fromJson(json.decode(str));

class GiftCardsData {
  String? header;
  String? description;
  String? banner;
  String? secondHeader;
  String? secondDescription;
  String? secondBanner;
  String? gifCardRedeemDescription;
  String? gifCardAddCardDescription;
  String? gifCardCheckCardDescription;
  List<GiftCardBanner>? banners;
  List<GiftCard>? myCards;
  List<FAQ>? faq;

  GiftCardsData({
    this.header,
    this.description,
    this.banner,
    this.secondHeader,
    this.secondDescription,
    this.secondBanner,
    this.gifCardRedeemDescription,
    this.gifCardAddCardDescription,
    this.gifCardCheckCardDescription,
    this.banners,
    this.myCards,
    this.faq,
  });

  factory GiftCardsData.fromJson(Map<String, dynamic> json) => GiftCardsData(
        header: json["header"],
        description: json["description"],
        banner: json["banner"],
        secondHeader: json["second_header"],
        secondDescription: json["second_description"],
        secondBanner: json["second_banner"],
        gifCardRedeemDescription: json["gif_card_redeem_description"],
        gifCardAddCardDescription: json["gif_card_add_card_description"],
        gifCardCheckCardDescription: json["gif_card_check_card_description"],
        banners: json["banners"] == null ? null : List<GiftCardBanner>.from(json["banners"].map((x) => GiftCardBanner.fromJson(x))),
        myCards: json["my_cards"] == null ? null : List<GiftCard>.from(json["my_cards"].map((x) => GiftCard.fromJson(x))),
        faq: json["faq"] == null ? null : List<FAQ>.from(json["faq"].map((x) => FAQ.fromJson(x))),
      );
}

class GiftCard {
  int? userId;
  dynamic walletType;
  double? fees;
  String? redeemCode;
  String? note;
  int? ownerId;
  int? isAdsCreated;
  DateTime? updatedAt;
  String? uid;
  String? giftCardBannerId;
  String? coinType;
  double? amount;
  DateTime? createdAt;
  GiftCardBanner? banner;

  String? lockText;
  String? statusText;
  int? lockStatus;
  int? lock;
  int? status;

  GiftCard({
    this.userId,
    this.walletType,
    this.fees,
    this.redeemCode,
    this.note,
    this.ownerId,
    this.isAdsCreated,
    this.updatedAt,
    this.uid,
    this.giftCardBannerId,
    this.coinType,
    this.amount,
    this.createdAt,
    this.banner,
    this.lockText,
    this.statusText,
    this.lockStatus,
    this.lock,
    this.status,
  });

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
        userId: json["user_id"],
        walletType: json["wallet_type"],
        fees: makeDouble(json["fees"]),
        redeemCode: json["redeem_code"],
        note: json["note"],
        ownerId: json["owner_id"],
        isAdsCreated: json["is_ads_created"],
        lockText: json["lock"].toString(),
        statusText: json["status"].toString(),
        lockStatus: json["lock_status"],
        lock: json["_lock"],
        status: json["_status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        uid: json["uid"],
        giftCardBannerId: json["gift_card_banner_id"],
        coinType: json["coin_type"],
        amount: makeDouble(json["amount"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        banner: json["banner"] == null ? null : GiftCardBanner.fromJson(json["banner"]),
      );
}

class GiftCardBanner {
  String? uid;
  String? categoryId;
  String? title;
  String? subTitle;
  String? banner;
  String? image;
  GiftCardCategory? category;

  GiftCardBanner({
    this.uid,
    this.categoryId,
    this.title,
    this.subTitle,
    this.banner,
    this.image,
    this.category,
  });

  factory GiftCardBanner.fromJson(Map<String, dynamic> json) => GiftCardBanner(
        uid: json["uid"],
        categoryId: json["category_id"],
        title: json["title"],
        subTitle: json["sub_title"],
        banner: json["banner"],
        image: json["image"],
        category: json["category"] == null ? null : GiftCardCategory.fromJson(json["category"]),
      );
}

class GiftCardThemeData {
  String? header;
  String? description;
  String? banner;
  List<GiftCardCategory>? categories;

  GiftCardThemeData({
    this.header,
    this.description,
    this.banner,
    this.categories,
  });

  factory GiftCardThemeData.fromJson(Map<String, dynamic> json) => GiftCardThemeData(
        header: json["header"],
        description: json["description"],
        banner: json["banner"],
        categories: json["categories"] == null ? null : List<GiftCardCategory>.from(json["categories"].map((x) => GiftCardCategory.fromJson(x))),
      );
}

class GiftCardSelfData {
  String? header;
  String? description;
  String? banner;

  GiftCardSelfData({this.header, this.description, this.banner});

  factory GiftCardSelfData.fromJson(Map<String, dynamic> json) =>
      GiftCardSelfData(header: json["header"], description: json["description"], banner: json["banner"]);
}

class GiftCardCategory {
  String? uid;
  String? name;
  String? label;
  String? value;

  GiftCardCategory({this.uid, this.name, this.label, this.value});

  factory GiftCardCategory.fromJson(Map<String, dynamic> json) =>
      GiftCardCategory(uid: json["uid"], name: json["name"], label: json["label"], value: json["value"]);
}

class GiftCardBuyData {
  String? header;
  String? description;
  String? banner;
  String? featureOne;
  String? featureOneIcon;
  String? featureTwo;
  String? featureTwoIcon;
  String? featureThree;
  String? featureThreeIcon;
  GiftCardBanner? selectedBanner;
  List<Coin>? coins;
  List<GiftCardBanner>? banners;

  GiftCardBuyData({
    this.header,
    this.description,
    this.banner,
    this.featureOne,
    this.featureOneIcon,
    this.featureTwo,
    this.featureTwoIcon,
    this.featureThree,
    this.featureThreeIcon,
    this.selectedBanner,
    this.coins,
    this.banners,
  });

  factory GiftCardBuyData.fromJson(Map<String, dynamic> json) => GiftCardBuyData(
        header: json["header"],
        description: json["description"],
        banner: json["banner"],
        featureOne: json["feature_one"],
        featureOneIcon: json["feature_one_icon"],
        featureTwo: json["feature_two"],
        featureTwoIcon: json["feature_two_icon"],
        featureThree: json["feature_three"],
        featureThreeIcon: json["feature_three_icon"],
        selectedBanner: json["selected_banner"] == null ? null : GiftCardBanner.fromJson(json["selected_banner"]),
        coins: json["coins"] == null ? null : List<Coin>.from(json["coins"].map((x) => Coin.fromJson(x))),
        banners: json["banners"] == null ? null : List<GiftCardBanner>.from(json["banners"].map((x) => GiftCardBanner.fromJson(x))),
      );
}

class Coin {
  String? name;
  String? coinType;
  String? label;
  String? value;

  Coin({this.name, this.coinType, this.label, this.value});

  factory Coin.fromJson(Map<String, dynamic> json) =>
      Coin(name: json["name"], coinType: json["coin_type"], label: json["label"], value: json["value"]);
}

class GiftCardWalletData {
  double? exchangeWalletBalance;
  double? p2PWalletBalance;

  GiftCardWalletData({this.exchangeWalletBalance, this.p2PWalletBalance});

  factory GiftCardWalletData.fromJson(Map<String, dynamic> json) => GiftCardWalletData(
      exchangeWalletBalance: makeDouble(json["exchange_wallet_balance"]), p2PWalletBalance: makeDouble(json["p2p_wallet_balance"]));
}

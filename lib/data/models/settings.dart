import 'dart:convert';

import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

import 'fiat_deposit.dart';

CommonSettings commonSettingsFromJson(String str) => CommonSettings.fromJson(json.decode(str));

class CommonSettings {
  CommonSettings({
    this.baseCurrency,
    this.currency,
    this.currencySymbol,
    this.currencyRate,
    this.appTitle,
    this.maintenanceMode,
    this.copyrightText,
    this.exchangeUrl,
    this.logo,
    this.loginBackground,
    this.favicon,
    this.cookieImage,
    this.cookieStatus,
    this.cookieHeader,
    this.cookieText,
    this.cookieButtonText,
    this.cookiePageKey,
    this.liveChatStatus,
    this.liveChatKey,
    this.swapStatus,
    this.maintenanceModeStatus,
    this.maintenanceModeTitle,
    this.maintenanceModeText,
    this.maintenanceModeImg,
    this.languageList,
    this.currencyDepositStatus,
    this.currencyDeposit2FaStatus,
    this.currencyDepositFaqStatus,
    this.faqTypeList,
    this.googleAnalyticsTrackingId,
    this.seoImage,
    this.seoMetaKeywords,
    this.seoMetaDescription,
    this.seoSocialTitle,
    this.seoSocialDescription,
    this.twoFactorWithdraw,
    this.exchangeLayoutView,
    this.publicChanelName,
    this.privateChanelName,
    this.p2pModule,
    this.enableGiftCard,
    this.enableFutureTrade,
    this.blogNewsModule,
    this.isEvmWallet,
    this.evmApiUrl,
    this.evmApiSecret,
    this.navbar,
  });

  String? baseCurrency;
  String? currency;
  String? currencySymbol;
  double? currencyRate;
  String? appTitle;
  String? maintenanceMode;
  String? copyrightText;
  String? exchangeUrl;
  String? logo;
  String? loginBackground;
  String? favicon;
  String? cookieImage;
  String? cookieStatus;
  String? cookieHeader;
  String? cookieText;
  String? cookieButtonText;
  String? cookiePageKey;
  String? liveChatStatus;
  String? liveChatKey;
  int? swapStatus;
  String? maintenanceModeStatus;
  String? maintenanceModeTitle;
  String? maintenanceModeText;
  String? maintenanceModeImg;
  List<AppLanguage>? languageList;
  String? currencyDepositStatus;
  String? currencyDeposit2FaStatus;
  String? currencyDepositFaqStatus;
  List<dynamic>? faqTypeList;
  String? googleAnalyticsTrackingId;
  String? seoImage;
  String? seoMetaKeywords;
  String? seoMetaDescription;
  String? seoSocialTitle;
  String? seoSocialDescription;
  String? twoFactorWithdraw;
  int? exchangeLayoutView;
  String? publicChanelName;
  String? privateChanelName;
  int? p2pModule;
  int? enableGiftCard;
  int? enableFutureTrade;
  int? blogNewsModule;
  bool? isEvmWallet;
  String? evmApiUrl;
  String? evmApiSecret;
  Map<String, NavMenu>? navbar;

  factory CommonSettings.fromJson(Map<String, dynamic> json) => CommonSettings(
        baseCurrency: json["base_currency"],
        currency: json["currency"],
        currencySymbol: json["currency_symbol"],
        currencyRate: makeDouble(json["currency_rate"]),
        appTitle: json["app_title"],
        maintenanceMode: json["maintenance_mode"],
        copyrightText: json["copyright_text"],
        exchangeUrl: json["exchange_url"],
        logo: json["logo"],
        loginBackground: json["login_background"],
        favicon: json["favicon"],
        cookieImage: json["cookie_image"],
        cookieStatus: json["cookie_status"],
        cookieHeader: json["cookie_header"],
        cookieText: json["cookie_text"],
        cookieButtonText: json["cookie_button_text"],
        cookiePageKey: json["cookie_page_key"],
        liveChatStatus: json["live_chat_status"],
        liveChatKey: json["live_chat_key"],
        swapStatus: makeInt(json["swap_status"]),
        maintenanceModeStatus: json["maintenance_mode_status"],
        maintenanceModeTitle: json["maintenance_mode_title"],
        maintenanceModeText: json["maintenance_mode_text"],
        maintenanceModeImg: json["maintenance_mode_img"],
        languageList: json["LanguageList"] == null ? null : List<AppLanguage>.from(json["LanguageList"].map((x) => AppLanguage.fromJson(x))),
        currencyDepositStatus: json["currency_deposit_status"],
        currencyDeposit2FaStatus: json["currency_deposit_2fa_status"],
        currencyDepositFaqStatus: json["currency_deposit_faq_status"],
        faqTypeList: json["FaqTypeList"] == null ? null : List<dynamic>.from(json["FaqTypeList"].map((x) => x)),
        googleAnalyticsTrackingId: json["google_analytics_tracking_id"],
        seoImage: json["seo_image"],
        seoMetaKeywords: json["seo_meta_keywords"],
        seoMetaDescription: json["seo_meta_description"],
        seoSocialTitle: json["seo_social_title"],
        seoSocialDescription: json["seo_social_description"],
        twoFactorWithdraw: json["two_factor_withdraw"],
        exchangeLayoutView: makeInt(json["exchange_layout_view"]),
        publicChanelName: json["public_chanel_name"],
        privateChanelName: json["private_chanel_name"],
        p2pModule: makeInt(json["p2p_module"]),
        enableGiftCard: makeInt(json["enable_gift_card"]),
        enableFutureTrade: makeInt(json["enable_future_trade"]),
        blogNewsModule: makeInt(json["blog_news_module"]),
        isEvmWallet: json["is_evm_wallet"] ?? false,
        evmApiUrl: json["evm_api_url"],
        evmApiSecret: json["evm_api_secret"],
        navbar: json["navbar"] == null ? null : Map.from(json["navbar"]).map((k, v) => MapEntry<String, NavMenu>(k, NavMenu.fromJson(v))),
      );
}

class AppLanguage {
  AppLanguage({
    required this.id,
    this.name,
    this.key,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String? name;
  String? key;
  int? status;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AppLanguage.fromJson(Map<String, dynamic> json) => AppLanguage(
        id: json["id"],
        name: json["name"],
        key: json["key"],
        status: json["status"],
        image: json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class UserSettings {
  UserSettings({this.fiatCurrency, this.user, this.google2faSecret, this.qrcode});

  List<FiatCurrency>? fiatCurrency;
  User? user;
  String? google2faSecret;
  String? qrcode;

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        fiatCurrency: json["fiat_currency"] == null ? null : List<FiatCurrency>.from(json["fiat_currency"].map((x) => FiatCurrency.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        google2faSecret: json["google2fa_secret"],
        qrcode: json["qrcode"],
      );
}

class NavMenu {
  String? name;
  bool? status;

  NavMenu({this.name, this.status});

  factory NavMenu.fromJson(Map<String, dynamic> json) => NavMenu(name: json["name"], status: json["status"]);
}

class LandingData {
  String? landingTitle;
  String? landingDescription;
  String? landingBannerImage;
  List<Announcement>? bannerList;
  List<Announcement>? announcementList;
  List<CoinPair>? assetCoinPairs;
  List<CoinPair>? hourlyCoinPairs;
  List<CoinPair>? latestCoinPairs;
  String? landingFirstSectionStatus;
  String? landingSecondSectionStatus;
  String? landingThirdSectionStatus;

  LandingData({
    this.landingTitle,
    this.landingDescription,
    this.landingBannerImage,
    this.bannerList,
    this.announcementList,
    this.assetCoinPairs,
    this.hourlyCoinPairs,
    this.latestCoinPairs,
    this.landingFirstSectionStatus,
    this.landingSecondSectionStatus,
    this.landingThirdSectionStatus,
  });

  factory LandingData.fromJson(Map<String, dynamic> json) => LandingData(
        landingTitle: json["landing_title"],
        landingDescription: json["landing_description"],
        landingBannerImage: json["landing_banner_image"],
        bannerList: json["banner_list"] == null ? null : List<Announcement>.from(json["banner_list"].map((x) => Announcement.fromJson(x))),
        announcementList:
            json["announcement_list"] == null ? null : List<Announcement>.from(json["announcement_list"].map((x) => Announcement.fromJson(x))),
        assetCoinPairs: json["asset_coin_pairs"] == null ? null : List<CoinPair>.from(json["asset_coin_pairs"].map((x) => CoinPair.fromJson(x))),
        hourlyCoinPairs: json["hourly_coin_pairs"] == null ? null : List<CoinPair>.from(json["hourly_coin_pairs"].map((x) => CoinPair.fromJson(x))),
        latestCoinPairs: json["latest_coin_pairs"] == null ? null : List<CoinPair>.from(json["latest_coin_pairs"].map((x) => CoinPair.fromJson(x))),
        landingFirstSectionStatus: json["landing_first_section_status"],
        landingSecondSectionStatus: json["landing_second_section_status"],
        landingThirdSectionStatus: json["landing_third_section_status"],
      );
}

class Announcement {
  int? id;
  String? title;
  String? slug;
  String? description;
  String? image;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Announcement({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class SocialMedia {
  int? id;
  String? mediaTitle;
  String? mediaLink;
  String? mediaIcon;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  SocialMedia({
    this.id,
    this.mediaTitle,
    this.mediaLink,
    this.mediaIcon,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) => SocialMedia(
        id: json["id"],
        mediaTitle: json["media_title"],
        mediaLink: json["media_link"],
        mediaIcon: json["media_icon"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

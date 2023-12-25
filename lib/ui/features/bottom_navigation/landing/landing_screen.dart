import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/settings.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/shimmer_loading/shimmer_view.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import '../../side_navigation/faq/faq_page.dart';
import '../../side_navigation/gift_cards/gift_cards_screen.dart';
import '../../side_navigation/profile/profile_screen.dart';
import '../../side_navigation/staking/staking_screen.dart';
import '../../side_navigation/support/crisp_chat.dart';
import 'landing_controller.dart';
import 'landing_widgets.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin {
  final _controller = Get.put(LandingController());
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    _controller.getLandingSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final lData = _controller.landingData.value;
      return _controller.isLoading.value
          ? const ShimmerViewLanding()
          : ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(Dimens.paddingMid),
              children: [
                vSpacer10(),
                if (lData.landingFirstSectionStatus == "1")
                  Column(
                    children: [
                      vSpacer10(),
                      if (lData.landingTitle.isValid) textAutoSizeKarla(lData.landingTitle ?? "", maxLines: 5, textAlign: TextAlign.start),
                      if (lData.landingDescription.isValid) vSpacer10(),
                      if (lData.landingDescription.isValid)
                        textAutoSizePoppins(lData.landingDescription ?? "", maxLines: 15, textAlign: TextAlign.start),
                      if (lData.landingBannerImage.isValid) vSpacer10(),
                      if (lData.landingBannerImage.isValid)
                        showImageNetwork(
                            imagePath: lData.landingBannerImage, width: context.width, height: context.width / 2, boxFit: BoxFit.fitWidth),
                    ],
                  ),
                vSpacer10(),
                if (lData.announcementList.isValid) _announcementListView(lData.announcementList!),
                if (lData.landingSecondSectionStatus == "1" && lData.bannerList.isValid) _bannerListView(lData.bannerList!),
                if (lData.landingThirdSectionStatus == "1") _marketTrendListView(),
                _exploreView()
              ],
            );
    });
  }

  _announcementListView(List<Announcement> list) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMid),
      child: Column(
        children: List.generate(list.length, (index) {
          return AnnouncementItemView(announcement: list[index], onTap: () => showDetailsView(list[index]));
        }),
      ),
    );
  }

  _bannerListView(List<Announcement> list) {
    final height = context.width / 3;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: CarouselSlider.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            final announcement = list[itemIndex];
            return InkWell(
              onTap: () => showDetailsView(announcement),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMin),
                  child: showCachedNetworkImage(announcement.image ?? "", size: height * 2)),
            );
          },
          options: CarouselOptions(height: height, viewportFraction: 0.6, autoPlay: true, autoPlayInterval: const Duration(seconds: 3))),
    );
  }

  void showDetailsView(Announcement announcement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vSpacer30(),
          buttonOnlyIcon(
              iconPath: AssetConstants.icCloseBox,
              size: Dimens.iconSizeMid,
              iconColor: context.theme.primaryColor,
              onPressCallback: () => Get.back()),
          AnnouncementDetailsView(announcement: announcement)
        ],
      ),
    );
  }

  _marketTrendListView() {
    final lData = _controller.landingData.value;
    final list = _controller.selectedTab.value == 0
        ? lData.assetCoinPairs
        : _controller.selectedTab.value == 1
            ? lData.hourlyCoinPairs
            : lData.latestCoinPairs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpacer15(),
        textAutoSizeKarla("Market Trend".tr, fontSize: Dimens.regularFontSizeLarge, textAlign: TextAlign.start),
        tabBarUnderline(["Core Assets".tr, "24H Gainer".tr, "New Listing".tr], _tabController,
            isScrollable: true, fontSize: Dimens.regularFontSizeMid, onTap: (index) => _controller.selectedTab.value = index),
        vSpacer5(),
        Row(children: [
          hSpacer10(),
          Expanded(flex: 2, child: textAutoSizePoppins("Market".tr, textAlign: TextAlign.start)),
          hSpacer5(),
          Expanded(flex: 2, child: textAutoSizePoppins("${"Price".tr}/\n${"Change (24h)".tr}", maxLines: 2)),
          hSpacer5(),
          Expanded(flex: 2, child: textAutoSizePoppins("${"Volume".tr}/\n${"Action".tr}", maxLines: 2, textAlign: TextAlign.end)),
          hSpacer10(),
        ]),
        vSpacer5(),
        list.isValid ? Column(children: List.generate(list?.length ?? 0, (index) => MarketTrendItemView(coin: list![index]))) : showEmptyView()
      ],
    );
  }

  _exploreView() {
    final pColor = context.theme.primaryColor;
    final settings = getSettingsLocal();
    final hasUser = gUserRx.value.id > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpacer15(),
        textAutoSizeKarla("Explore".tr, fontSize: Dimens.regularFontSizeLarge, textAlign: TextAlign.start),
        vSpacer10(),
        Wrap(
          spacing: Dimens.paddingMid,
          runSpacing: Dimens.paddingMin,
          children: [
            buttonText("Trade".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
              getRootController().changeBottomNavIndex(0, false);
            }),
            if (hasUser)
            buttonText("Wallet".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
              getRootController().changeBottomNavIndex(1, false);
            }),
            if (hasUser)
            buttonText("Fiat".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
              getRootController().changeBottomNavIndex(13, false);
            }),
            buttonText("Market".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
              getRootController().changeBottomNavIndex(2, false);
            }),
            if (hasUser)
              buttonText("Reports".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
                getRootController().changeBottomNavIndex(3, false);
              }),
            if (hasUser)
              buttonText("Profile".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
                Get.to(() => const ProfileScreen());
              }),
            buttonText("Staking".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
              Get.to(() => const StakingScreen());
            }),
            if (settings?.enableGiftCard == 1)
              buttonText("Gift Card".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
                Get.to(() => const GiftCardsScreen());
              }),
            buttonText("FAQ".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
              Get.to(() => const FAQPage());
            }),
            if (hasUser && settings?.liveChatStatus == "1")
              buttonText("Support".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
                Get.to(() => const CrispChat());
              }),
            //IF you have ICO addon, uncomment below section
            // if (settings?.navbar?["ico"]?.status == true)
            //   buttonText("ICO".tr, borderColor: pColor, textColor: pColor, bgColor: Colors.transparent, onPressCallback: () {
            //      Get.to(() => const ICOScreen());
            //   }),
          ],
        ),
        vSpacer10()
      ],
    );
  }
}

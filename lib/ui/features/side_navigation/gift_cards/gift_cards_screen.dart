import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';

import 'gift_cards_controller.dart';
import 'gift_cards_faq_screen.dart';
import 'gift_cards_self/gift_cards_self_screen.dart';
import 'gift_cards_themes/gift_cards_themes_screen.dart';
import 'gift_cards_widgets.dart';

class GiftCardsScreen extends StatefulWidget {
  const GiftCardsScreen({Key? key}) : super(key: key);

  @override
  GiftCardsScreenState createState() => GiftCardsScreenState();
}

class GiftCardsScreenState extends State<GiftCardsScreen> {
  final _controller = Get.put(GiftCardsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getGiftCardsLandingDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: Column(
              children: [
                appBarBackWithActions(
                    title: "Gift Cards".tr,
                    actionIcons: [AssetConstants.icInfoCircle],
                    onPress: (index) {
                      Get.to(() => GiftCardsFAQScreen(gcData: _controller.giftCardsData.value));
                    }),
                Obx(() {
                  final gcData = _controller.giftCardsData.value;
                  return _controller.isLoading.value
                      ? showLoading()
                      : Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(Dimens.paddingMid),
                            children: [
                              GiftCardTitleView(title: gcData.header, subTitle: gcData.description, image: gcData.banner),
                              vSpacer20(),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                      height: Dimens.iconSizeLarge,
                                      child: buttonRoundedWithIcon(
                                          text: "Send Crypto Gift Card".tr,
                                          textColor: Colors.white,
                                          onPressCallback: () => checkLoggedInStatus(context, () => Get.to(() => const GiftCardSelfScreen()))))),
                              vSpacer20(),
                              GiftCardCheckView(gcData: gcData),
                              vSpacer20(),
                              ListHeaderView(
                                  title: "Themed Gift Cards".tr,
                                  subtitle: "Send a crypto gift card for any occasion".tr,
                                  onViewAll: () => Get.to(() => const GiftCardThemesScreen())),
                              vSpacer10(),
                              gcData.banners.isValid
                                  ? Wrap(
                                      spacing: Dimens.paddingMid,
                                      runSpacing: Dimens.paddingMid,
                                      children: List.generate(gcData.banners!.length, (index) => GiftBannerItemView(gBanner: gcData.banners![index])))
                                  : showEmptyView(height: Dimens.menuHeight),
                              vSpacer10(),
                              if (gcData.banners.isValid)
                                Align(
                                    alignment: Alignment.center,
                                    child: buttonRoundedWithIcon(
                                        text: "View More Themed Card".tr,
                                        bgColor: Get.theme.focusColor,
                                        textColor: Get.theme.scaffoldBackgroundColor,
                                        onPressCallback: () => checkLoggedInStatus(context, () => Get.to(() => const GiftCardThemesScreen())))),
                              vSpacer30(),
                              if (gUserRx.value.id > 0)
                                Column(
                                  children: [
                                    ListHeaderView(title: "My Cards".tr, subtitle: "".tr, onViewAll: () => Get.to(() => const GiftCardSelfScreen())),
                                    vSpacer10(),
                                    gcData.myCards.isValid
                                        ? GridView.count(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            crossAxisCount: 2,
                                            childAspectRatio: MediaQuery.of(context).textScaleFactor > 1 ? 0.9 : 1,
                                            children: List.generate(gcData.myCards!.length,
                                                (index) => GiftCardItemView(gCard: gcData.myCards![index], from: FromKey.home)))
                                        : showEmptyView(height: Dimens.menuHeight, message: "Your cards will appear here".tr),
                                    vSpacer10(),
                                  ],
                                )
                            ],
                          ),
                        );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/gift_card.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/gift_cards/gift_card_details_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/gift_cards/gift_cards_controller.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'gift_cards_buy/gift_cards_buy_screen.dart';

class GiftCardTitleView extends StatelessWidget {
  const GiftCardTitleView({super.key, this.title, this.subTitle, this.image});

  final String? title;
  final String? subTitle;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 4;
    return Row(
      children: [
        if (image.isValid) showImageNetwork(imagePath: image, height: width, width: width, boxFit: BoxFit.cover),
        if (image.isValid) hSpacer10(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title.isValid) textAutoSizeKarla(title!, maxLines: 2, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
              if (subTitle.isValid) vSpacer5(),
              if (subTitle.isValid) textAutoSizePoppins(subTitle!, maxLines: 5, textAlign: TextAlign.start),
            ],
          ),
        ),
      ],
    );
  }
}

//ignore: must_be_immutable
class GiftCardCheckView extends StatelessWidget {
  GiftCardCheckView({super.key, required this.gcData});

  final GiftCardsData gcData;
  RxInt selectedType = GiftCardCheckStatus.redeem.obs;
  final _codeEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: boxDecorationRoundCorner(),
        padding: const EdgeInsets.all(Dimens.paddingMid),
        child: Obx(() {
          String? desc = gcData.gifCardRedeemDescription, btnTitle = "Redeem".tr;
          if (selectedType.value == GiftCardCheckStatus.add) {
            desc = gcData.gifCardAddCardDescription;
            btnTitle = "Add".tr;
          } else if (selectedType.value == GiftCardCheckStatus.check) {
            desc = gcData.gifCardCheckCardDescription;
            btnTitle = "Check".tr;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _tabButton("Redeem".tr, GiftCardCheckStatus.redeem),
                  hSpacer5(),
                  _tabButton("Add Card".tr, GiftCardCheckStatus.add),
                  hSpacer5(),
                  _tabButton("Check Card", GiftCardCheckStatus.check)
                ],
              ),
              vSpacer15(),
              textAutoSizePoppins("Redemption Code".tr, color: Get.theme.primaryColor),
              vSpacer5(),
              textFieldWithSuffixIcon(controller: _codeEditController),
              vSpacer2(),
              textAutoSizePoppins((desc ?? "").replaceAll("\n", ""), maxLines: 5, textAlign: TextAlign.start),
              vSpacer15(),
              Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      width: Dimens.toolBarWideMid,
                      child: buttonText(btnTitle, textColor: Get.theme.scaffoldBackgroundColor, onPressCallback: () {
                        checkLoggedInStatus(context, () {
                          final code = _codeEditController.text.trim();
                          if (code.isEmpty) {
                            showToast("Input the redemption code".tr, context: context);
                            return;
                          }
                          hideKeyboard(context: context);
                          Get.find<GiftCardsController>().getGiftCardCheck(code, (card) {
                            showBottomSheetFullScreen(context, GiftCardDetailsScreen(gCard: card, checkType: selectedType.value),
                                title: "Gift Card Details".tr);
                          });
                        });
                      })))
            ],
          );
        }));
  }

  _tabButton(String title, int index) {
    final isSelected = selectedType.value == index;
    return buttonText(title,
        textColor: isSelected ? Get.theme.scaffoldBackgroundColor : Get.theme.primaryColor,
        bgColor: isSelected ? null : Colors.transparent, onPressCallback: () {
      selectedType.value = index;
      _codeEditController.text = "";
    });
  }
}

class ListHeaderView extends StatelessWidget {
  const ListHeaderView({super.key, required this.title, required this.subtitle, required this.onViewAll});

  final String title;
  final String subtitle;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textAutoSizeKarla(title, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
              textAutoSizePoppins(subtitle, maxLines: 2, textAlign: TextAlign.start)
            ],
          ),
        ),
        // buttonText("View All".tr, bgColor: Colors.transparent, textColor: Get.theme.primaryColor, onPressCallback: onViewAll)
        buttonText("View All".tr, bgColor: Colors.transparent, textColor: Get.theme.primaryColor, onPressCallback: () {
          checkLoggedInStatus(context, () => onViewAll());
        })
      ],
    );
  }
}

class GiftBannerItemView extends StatelessWidget {
  const GiftBannerItemView({super.key, required this.gBanner, this.isSelected = false, this.onTap});

  final GiftCardBanner gBanner;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final cWidth = (MediaQuery.of(context).size.width - 30) / 2;
    return showImageNetwork(
        imagePath: gBanner.banner,
        width: cWidth,
        height: cWidth * 0.5,
        boxFit: BoxFit.fitWidth,
        padding: isSelected ? 2 : 0,
        bgColor: isSelected ? Get.theme.focusColor : null,
        onPressCallback: () =>
            onTap == null ? checkLoggedInStatus(context, () => Get.to(() => GiftCardBuyScreen(uid: gBanner.uid ?? ""))) : onTap!());
  }
}

class GiftCardItemView extends StatelessWidget {
  const GiftCardItemView({super.key, required this.gCard, required this.from});

  final GiftCard gCard;
  final String from;

  @override
  Widget build(BuildContext context) {
    final cWidth = (MediaQuery.of(context).size.width - 30) / 2;
    return InkWell(
      onTap: () {
        showBottomSheetFullScreen(context, GiftCardDetailsScreen(gCard: gCard, from: from), title: "Gift Card Details".tr);
      },
      radius: Dimens.radiusCorner,
      child: Container(
        width: cWidth,
        // height: cWidth - 10,
        decoration: boxDecorationRoundCorner(),
        padding: const EdgeInsets.all(Dimens.paddingMid),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showImageNetwork(imagePath: gCard.banner?.image, width: cWidth, height: cWidth / 2, boxFit: BoxFit.cover),
            vSpacer5(),
            textAutoSizeKarla(gCard.banner?.title ?? "", textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
            vSpacer5(),
            textAutoSizePoppins(gCard.banner?.subTitle ?? "", textAlign: TextAlign.start, maxLines: 2)
          ],
        ),
      ),
    );
  }
}

class GiftCardImageAndTag extends StatelessWidget {
  final String? imagePath;
  final String? amountText;

  const GiftCardImageAndTag({super.key, this.imagePath, this.amountText});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: Dimens.paddingLargeExtra),
        child: showImageNetwork(imagePath: imagePath, boxFit: BoxFit.fitWidth),
      ),
      Positioned(
        bottom: 0,
        right: 20,
        child: SizedBox(
          height: Dimens.btnHeightMid,
          child: buttonRoundedWithIcon(
              text: amountText,
              iconPath: AssetConstants.icGift,
              textDirection: TextDirection.ltr,
              bgColor: Get.theme.focusColor,
              textColor: Get.theme.scaffoldBackgroundColor),
        ),
      )
    ]);
  }
}

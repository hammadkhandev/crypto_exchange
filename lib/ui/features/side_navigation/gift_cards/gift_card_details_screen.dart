import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/gift_card.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/gift_cards/gift_cards_controller.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/gift_cards/gift_cards_self/gift_cards_self_controller.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'gift_cards_widgets.dart';

//ignore: must_be_immutable
class GiftCardDetailsScreen extends StatelessWidget {
  GiftCardDetailsScreen({super.key, required this.gCard, this.checkType, this.from});

  final GiftCard gCard;
  final int? checkType;
  final String? from;
  RxString redeemCode = "".obs;
  final bgColor = Get.theme.scaffoldBackgroundColor;

  @override
  Widget build(BuildContext context) {
    String? imagePath = gCard.banner?.banner;
    if (imagePath == null || !imagePath.contains(APIURLConstants.baseUrl)) imagePath = gCard.banner?.image;
    String amountText = "${gCard.amount ?? 0} ${gCard.coinType ?? ""}";

    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
        children: [
          GiftCardImageAndTag(imagePath: imagePath, amountText: amountText),
          vSpacer20(),
          textAutoSizeKarla(gCard.banner?.title ?? "", maxLines: 5, textAlign: TextAlign.start),
          vSpacer10(),
          textAutoSizePoppins(gCard.banner?.subTitle ?? "", maxLines: 10, textAlign: TextAlign.start, color: Get.theme.primaryColor),
          vSpacer20(),
          checkType == null ? _cardDetailsView(context) : Align(alignment: Alignment.centerRight, child: _cardCheckView()),
          vSpacer10(),
        ],
      ),
    );
  }

  _cardDetailsView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        twoTextView("${"Coin Type".tr}: ", gCard.coinType ?? ""),
        vSpacer2(),
        twoTextView("${"Category".tr}: ", gCard.banner?.category?.name ?? ""),
        vSpacer2(),
        twoTextView("${"Lock".tr}: ", gCard.lockText ?? ""),
        vSpacer2(),
        twoTextView("${"Status".tr}: ", gCard.statusText ?? ""),
        vSpacer10(),
        Row(
          children: [
            textAutoSizeKarla("${"Redeem Code".tr}: ", fontSize: Dimens.regularFontSizeMid),
            hSpacer5(),
            Obx(() => redeemCode.value.isEmpty
                ? SizedBox(
                    height: Dimens.btnHeightMin, child: buttonText("See Code".tr, textColor: bgColor, onPressCallback: () => _getRedeemCode(context)))
                : textWithCopyView(redeemCode.value))
          ],
        ),
        vSpacer30(),
        Wrap(
          spacing: Dimens.paddingMid,
          runSpacing: Dimens.paddingMid,
          alignment: WrapAlignment.end,
          children: [
            if (gCard.lockStatus == 1)
              buttonText(gCard.lock == 0 ? "Locked".tr : "Unlocked".tr, textColor: bgColor, onPressCallback: () {
                from == FromKey.home
                    ? Get.find<GiftCardsController>().giftCardUpdate(gCard)
                    : Get.find<GiftCardSelfController>().giftCardUpdate(gCard);
              }),
            if (gCard.status == 1)
              buttonText("Send Crypto Gift Card".tr, textColor: bgColor, onPressCallback: () {
                Get.back();
                showBottomSheetFullScreen(context, GiftCardSendView(gCard: gCard), title: "Send Crypto Gift Card".tr);
              }),
          ],
        ),
      ],
    );
  }

  _cardCheckView() {
    if (checkType == GiftCardCheckStatus.check) {
      return vSpacer0();
    } else {
      final btnText = checkType == GiftCardCheckStatus.redeem ? "Redeem".tr : "Add".tr;
      return buttonText(btnText, textColor: bgColor, onPressCallback: () {
        if (checkType == GiftCardCheckStatus.redeem) {
          Get.find<GiftCardsController>().giftCardRedeem(gCard.redeemCode ?? "");
        } else if (checkType == GiftCardCheckStatus.add) {
          Get.find<GiftCardsController>().giftCardAdd(gCard.redeemCode ?? "");
        }
      });
    }
  }

  void _getRedeemCode(BuildContext context) {
    final passEditController = TextEditingController();
    final view = Column(
      children: [
        vSpacer10(),
        textAutoSizeKarla("Enter your login password".tr, fontSize: Dimens.regularFontSizeMid, maxLines: 2),
        vSpacer10(),
        textFieldWithSuffixIcon(controller: passEditController, hint: "Write Your Password".tr),
        vSpacer10(),
        Align(
            alignment: Alignment.centerRight,
            child: buttonText("Get Code".tr, textColor: bgColor, onPressCallback: () {
              final password = passEditController.text;
              if (password.length < DefaultValue.kPasswordLength) {
                showToast("Password_invalid_length".trParams({"count": DefaultValue.kPasswordLength.toString()}), isError: true);
                return;
              }
              hideKeyboard(context: context);
              Get.find<GiftCardsController>().getGiftCardCode(gCard.uid ?? "", password, (code) => redeemCode.value = code);
            })),
        vSpacer10(),
      ],
    );
    showModalSheetFullScreen(context, view);
  }
}

class GiftCardSendView extends StatefulWidget {
  const GiftCardSendView({super.key, required this.gCard});

  final GiftCard gCard;

  @override
  State<GiftCardSendView> createState() => _GiftCardSendViewState();
}

class _GiftCardSendViewState extends State<GiftCardSendView> {
  RxInt selectedType = 0.obs;
  final messageController = TextEditingController();
  final sendIdController = TextEditingController();

  @override
  void initState() {
    selectedType.value = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
        children: [
          vSpacer10(),
          textAutoSizeKarla("Send Type".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
          vSpacer2(),
          Obx(() {
            final type = selectedType.value == 0 ? "Email".tr : "Phone".tr;
            final inputType = selectedType.value == 0 ? TextInputType.emailAddress : TextInputType.phone;
            return Column(
              children: [
                dropDownListIndex(["Email".tr, "Phone".tr], selectedType.value, "Select Type".tr, hMargin: 0, (index) {
                  sendIdController.text = "";
                  selectedType.value = index;
                }),
                vSpacer20(),
                if (selectedType.value != -1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textAutoSizeKarla(type, fontSize: Dimens.regularFontSizeMid),
                      vSpacer2(),
                      textFieldWithSuffixIcon(controller: sendIdController, hint: "${"Enter your".tr} ${type.toLowerCase()}", type: inputType),
                      if (selectedType.value == 1)
                        textAutoSizePoppins("add phone number message".tr,
                            maxLines: 2, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMin),
                      vSpacer20(),
                      textAutoSizeKarla("Message".tr, fontSize: Dimens.regularFontSizeMid),
                      vSpacer2(),
                      textFieldWithSuffixIcon(controller: messageController, hint: "Write your message".tr, height: 80, maxLines: 3),
                      vSpacer20(),
                      Align(
                          alignment: Alignment.centerRight,
                          child: buttonText("Send".tr, onPressCallback: () {
                            final type = selectedType.value == 0 ? GiftCardSendType.email : GiftCardSendType.phone;
                            final id = sendIdController.text.trim();
                            if (type == GiftCardSendType.email && !GetUtils.isEmail(id)) {
                              showToast("Input a valid Email".tr);
                              return;
                            } else if (type == GiftCardSendType.phone) {
                              var number = removeSpecialChar(sendIdController.text.trim());
                              if (number.length < 5) {
                                showToast("Input a valid phone".tr);
                                return;
                              }
                            }
                            hideKeyboard(context: context);
                            Get.find<GiftCardsController>().giftCardSend(widget.gCard.uid ?? "", type, id, messageController.text.trim());
                          }))
                    ],
                  )
              ],
            );
          }),
          vSpacer10(),
        ],
      ),
    );
  }
}

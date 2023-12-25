import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'button_util.dart';
import 'common_utils.dart';
import 'decorations.dart';
import 'dimens.dart';

void alertForAction(BuildContext context,
    {String? title, String? subTitle, int? maxLinesSub, String? buttonTitle, VoidCallback? onOkAction, Color? buttonColor}) {
  final view = Column(
    children: [
      vSpacer10(),
      if (title.isValid) textAutoSizeKarla(title!, maxLines: 2, fontSize: Dimens.regularFontSizeLarge),
      vSpacer10(),
      if (subTitle.isValid) textAutoSizeKarla(subTitle!, maxLines: maxLinesSub ?? 5, fontSize: Dimens.regularFontSizeMid),
      vSpacer15(),
      if (buttonTitle.isValid) buttonRoundedMain(text: buttonTitle, onPressCallback: onOkAction, bgColor: buttonColor),
      vSpacer10(),
    ],
  );
  showModalSheetFullScreen(context, view);
}

showModalSheetFullScreen(BuildContext context, Widget customView, {Function? onClose}) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return KeyboardDismissOnTap(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  hSpacer10(),
                  buttonOnlyIcon(
                      iconPath: AssetConstants.icCloseBox,
                      size: Dimens.iconSizeMid,
                      iconColor: gIsDarkMode ? context.theme.primaryColor : context.theme.colorScheme.background,
                      onPressCallback: () {
                        Get.back();
                        if (onClose != null) onClose();
                      })
                ],
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid, horizontal: Dimens.paddingMid),
                  margin: const EdgeInsets.symmetric(vertical: Dimens.paddingLarge, horizontal: Dimens.paddingLarge),
                  decoration: boxDecorationRoundCorner(color: Get.theme.colorScheme.background),
                  child: customView)
            ],
          ),
        );
      });
}

void showBottomSheetFullScreen(BuildContext context, Widget customView, {Function? onClose, String? title, bool isScrollControlled = true}) {
  Get.bottomSheet(
      Container(
          alignment: Alignment.bottomCenter,
          height: getContentHeight(),
          decoration: boxDecorationTopRound(radius: Dimens.radiusCornerMid),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              vSpacer10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buttonOnlyIcon(
                      iconPath: AssetConstants.icCross,
                      size: Dimens.iconSizeMinExtra,
                      onPressCallback: () {
                        Get.back();
                        if (onClose != null) onClose();
                      }),
                  textAutoSizeTitle(title ?? "", fontSize: Dimens.regularFontSizeMid),
                  hSpacer20()
                ],
              ),
              dividerHorizontal(),
              customView
            ],
          )),
      isScrollControlled: isScrollControlled,
      isDismissible: true);
}

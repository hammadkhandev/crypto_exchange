import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/ui/features/auth/sign_in/sign_in_screen.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/ui/features/auth/sign_up/sign_up_screen.dart';
import 'package:tradexpro_flutter/ui/features/root/root_screen.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'app_helper.dart';

Widget viewTitleWithSubTitleText({String? title, String? subTitle, int? maxLines = 2}) {
  return Padding(
    padding: const EdgeInsets.only(top: Dimens.paddingLargeDouble, bottom: Dimens.paddingLargeDouble),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textAutoSizeKarla(title ?? ""),
        vSpacer10(),
        textAutoSizeKarla(subTitle ?? "", color: Get.theme.primaryColorLight, maxLines: maxLines!, fontSize: Dimens.regularFontSizeMid),
      ],
    ),
  );
}

Widget logoWithSkipView() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      hSpacer50(),
      showImageAsset(imagePath: AssetConstants.icLogo, height: Dimens.iconSizeLogo, width: Dimens.iconSizeLogo, color: Get.theme.primaryColor),
      InkWell(
          onTap: () => Get.offAll(() => const RootScreen()),
          child: SizedBox(width: 50, child: textAutoSizeKarla("Skip".tr, fontSize: Dimens.regularFontSizeMid))),
    ],
  );
}

Widget signInNeedView({bool isDrawer = false}) {
  final logoSize = isDrawer ? Dimens.iconSizeDrawerLogo : Dimens.iconSizeLogo;
  return Padding(
    padding: const EdgeInsets.all(Dimens.paddingMid),
    child: SizedBox(
      height: isDrawer ? 260 : getContentHeight(withBottomNav: true, withToolbar: true) - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          showImageAsset(imagePath: AssetConstants.icLogo, height: logoSize, width: logoSize, color: Get.theme.primaryColor),
          vSpacer20(),
          textAutoSizeKarla("Sign In to unlock".tr, maxLines: 3, fontSize: Dimens.regularFontSizeMid),
          isDrawer ? vSpacer10() : vSpacer20(),
          isDrawer
              ? buttonText("Sign In".tr, onPressCallback: () => Get.offAll(() => const SignInPage()))
              : buttonRoundedMain(text: "Sign In".tr, onPressCallback: () => Get.offAll(() => const SignInPage())),
          isDrawer ? vSpacer10() : vSpacer20(),
          textSpanWithAction('Do not have account'.tr, "Sign Up".tr, () => Get.offAll(() => const SignUpScreen())),
        ],
      ),
    ),
  );
}

Widget listHeaderView(String cFirst, String cSecond, String cThird) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      textAutoSizePoppins(cFirst, textAlign: TextAlign.start, color: Get.theme.primaryColor),
      textAutoSizePoppins(cSecond, color: Get.theme.primaryColor),
      textAutoSizePoppins(cThird, textAlign: TextAlign.end, color: Get.theme.primaryColor),
    ],
  );
}

Widget twoTextView(String text, String subText, {Color? subColor}) {
  return Row(
    children: [
      textAutoSizePoppins(text, fontSize: Dimens.regularFontSizeSmall, color: Get.theme.primaryColorLight),
      Expanded(child: textAutoSizeKarla(subText, fontSize: Dimens.regularFontSizeMid, color: subColor, maxLines: 1, textAlign: TextAlign.start)),
    ],
  );
}

Widget twoTextSpace(String text, String subText, {Color? subColor, Color? color}) {
  color = color ?? Get.theme.primaryColorLight;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      textAutoSizeKarla(text, fontSize: Dimens.regularFontSizeMid, color: color, textAlign: TextAlign.start),
      textAutoSizeKarla(subText, fontSize: Dimens.regularFontSizeMid, color: subColor, textAlign: TextAlign.end),
    ],
  );
}

Widget twoTextSpaceFixed(String text, String subText,
    {Color? subColor, Color? color, int maxLine = 1, int subMaxLine = 1, double? fontSize, int? flex}) {
  fontSize = fontSize ?? Dimens.regularFontSizeMid;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: flex ?? 3, child: textAutoSizeKarla(text, fontSize: fontSize, color: color, textAlign: TextAlign.start, maxLines: maxLine)),
      Expanded(
          flex: 6,
          child: textAutoSizeKarla(subText,
              fontSize: fontSize, color: subColor, textAlign: TextAlign.end, minFontSize: Dimens.regularFontSizeExtraMid, maxLines: subMaxLine)),
    ],
  );
}

Widget dropDownWallets(List<Wallet> items, Wallet selectedValue, String hint,
    {Function(Wallet value)? onChange, double? viewWidth, double height = 50, bool isEditable = true, Color? bgColor, double? hMargin}) {
  hMargin = hMargin ?? 0;
  return Container(
    margin: EdgeInsets.only(left: hMargin, top: 5, right: hMargin, bottom: 5),
    height: height,
    width: viewWidth,
    alignment: Alignment.center,
    child: DropdownButton<Wallet>(
      value: selectedValue.coinType.isValid ? selectedValue : null,
      hint: Text(hint, style: Get.textTheme.bodyMedium),
      icon: Icon(Icons.keyboard_arrow_down_outlined, color: isEditable ? Get.theme.primaryColor : Colors.transparent),
      elevation: 10,
      dropdownColor: gIsDarkMode ? Get.theme.colorScheme.background : Get.theme.dividerColor,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      underline: Container(height: 0, color: Colors.transparent),
      menuMaxHeight: Get.width,
      onChanged: (isEditable && onChange != null) ? (value) => onChange(value!) : null,
      items: items.map<DropdownMenuItem<Wallet>>((Wallet value) {
        return DropdownMenuItem<Wallet>(
          value: value,
          child: Row(
            children: [Text(value.coinType ?? "", style: Get.textTheme.bodyMedium!.copyWith())],
          ),
        );
      }).toList(),
    ),
  );
}

Widget historyItemView(History history, String type) {
  final statusData = getStatusData(history.status ?? 0);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid, horizontal: Dimens.paddingMid),
    child: Column(
      children: [
        twoTextSpace('Coin'.tr, history.coinType ?? ""),
        vSpacer5(),
        twoTextSpace('Amount'.tr, coinFormat(history.amount)),
        vSpacer5(),
        twoTextSpace('Fees'.tr, coinFormat(history.fees)),
        vSpacer5(),
        twoTextSpaceFixed('Address'.tr, history.address ?? "", color: Get.theme.primaryColorLight),
        vSpacer5(),
        twoTextSpace('Created At'.tr, formatDate(history.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
        vSpacer5(),
        twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
        dividerHorizontal()
      ],
    ),
  );
}

Widget dropDownNetworks(List<Network> items, Network selectedValue, String hint,
    {Function(Network value)? onChange, double? viewWidth, double height = 50, bool isEditable = true, Color? bgColor, double? hMargin}) {
  hMargin = hMargin ?? 0;
  viewWidth = viewWidth ?? Get.width;
  return Container(
    margin: EdgeInsets.only(left: hMargin, top: 5, right: hMargin, bottom: 5),
    height: height,
    width: viewWidth,
    alignment: Alignment.center,
    decoration: boxDecorationRoundBorder(color: bgColor),
    child: DropdownButton<Network>(
      value: selectedValue.id == 0 ? null : selectedValue,
      hint: SizedBox(width: (viewWidth - 90), child: Text(hint, style: Get.textTheme.bodyMedium)),
      icon: Icon(Icons.keyboard_arrow_down_outlined, color: isEditable ? Get.theme.primaryColor : Colors.transparent),
      elevation: 10,
      dropdownColor: gIsDarkMode ? Get.theme.colorScheme.background : Get.theme.dividerColor,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      underline: Container(height: 0, color: Colors.transparent),
      menuMaxHeight: Get.width,
      onChanged: (isEditable && onChange != null) ? (value) => onChange(value!) : null,
      items: items.map<DropdownMenuItem<Network>>((Network value) {
        return DropdownMenuItem<Network>(
          value: value,
          child: Text(value.networkName ?? "", style: Get.textTheme.bodyMedium!.copyWith()),
        );
      }).toList(),
    ),
  );
}

walletsSuffixView(List<Wallet> walletList, Wallet selected, {Function(Wallet value)? onChange, double? width}) {
  return SizedBox(
    width: width ?? Dimens.suffixWide,
    child: Row(
      children: [
        dividerVertical(indent: Dimens.paddingMid),
        hSpacer5(),
        Expanded(child: dropDownWallets(walletList, selected, "Select".tr, onChange: onChange))
      ],
    ),
  );
}

Widget walletTopView(Wallet wallet) {
  return Container(
    //decoration: boxDecorationWithShadow(color: Get.theme.backgroundColor),
    padding: const EdgeInsets.all(Dimens.paddingMid),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        showImageNetwork(imagePath: wallet.coinIcon, width: Dimens.iconSizeMid, height: Dimens.iconSizeMid),
        hSpacer10(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textAutoSizePoppins(wallet.coinType ?? "",
                color: Get.theme.primaryColor, fontWeight: FontWeight.bold, fontSize: Dimens.regularFontSizeMid),
            textAutoSizePoppins(wallet.name ?? "", fontSize: Dimens.regularFontSizeExtraMid),
          ],
        ),
      ],
    ),
  );
}

Widget twoTextSpaceBackground(String text, String subText, {Color? bgColor, Color? textColor, double height = Dimens.btnHeightMain}) {
  return Container(
    height: height,
    padding: const EdgeInsets.all(Dimens.paddingMin),
    decoration: boxDecorationRoundCorner(color: bgColor),
    child: Row(
      children: [
        Expanded(
            flex: 1,
            child: textAutoSizeKarla(text,
                fontSize: Dimens.regularFontSizeLarge, textAlign: TextAlign.start, color: textColor ?? Get.theme.colorScheme.secondary)),
        hSpacer10(),
        Expanded(
            flex: 1,
            child: textAutoSizeKarla(subText,
                fontSize: Dimens.regularFontSizeLarge, textAlign: TextAlign.end, color: textColor ?? Get.theme.colorScheme.secondary)),
      ],
    ),
  );
}

Widget coinDetailsItemView(String? title, String? subtitle, {bool isSwap = false, Color? subColor, String? fromKey}) {
  subColor = subColor ?? Get.theme.primaryColor;
  final mainColor = fromKey.isValid ? (fromKey == FromKey.up ? gBuyColor : gSellColor) : Get.theme.primaryColorLight;
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textAutoSizeKarla(title ?? "", color: mainColor, fontSize: isSwap ? Dimens.regularFontSizeMid : Dimens.regularFontSizeSmall),
          if (fromKey.isValid)
            Icon(fromKey == FromKey.up ? Icons.arrow_upward : Icons.arrow_downward, color: mainColor, size: Dimens.iconSizeMinExtra)
        ],
      ),
      textAutoSizeKarla((subtitle ?? 0).toString(), color: subColor, fontSize: isSwap ? Dimens.regularFontSizeSmall : Dimens.regularFontSizeMid),
    ],
  );
}

Widget faqItem(FAQ faq) {
  return Container(
    decoration: boxDecorationRoundCorner(),
    padding: const EdgeInsets.all(Dimens.paddingMid),
    margin: const EdgeInsets.all(Dimens.paddingMid),
    child: Theme(
      data: Get.theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: textAutoSizeKarla(faq.question ?? "", maxLines: 5, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
        backgroundColor: Colors.transparent,
        collapsedIconColor: Get.theme.primaryColor,
        iconColor: Get.theme.primaryColor,
        children: <Widget>[
          dividerHorizontal(color: Colors.grey.withOpacity(0.5), height: 1),
          vSpacer10(),
          textAutoSizeKarla(faq.answer ?? "", maxLines: 100, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
        ],
      ),
    ),
  );
}

Widget currencyView(BuildContext context, FiatCurrency selectedCurrency, List<FiatCurrency> cList, Function(FiatCurrency) onChange) {
  final text = selectedCurrency.code.isValid ? selectedCurrency.name! : "Select".tr;
  return InkWell(
    onTap: () => chooseCurrencyModal(context, cList, onChange),
    child: SizedBox(
      width: Dimens.suffixWide,
      child: Row(
        children: [
          dividerVertical(indent: Dimens.paddingMid),
          vSpacer5(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: AutoSizeText(text, style: Get.textTheme.bodyMedium, maxLines: 2, textAlign: TextAlign.center)),
                Icon(Icons.keyboard_arrow_down, size: Dimens.iconSizeMin, color: Get.theme.primaryColor),
                hSpacer10()
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void chooseCurrencyModal(BuildContext context, List<FiatCurrency> cList, Function(FiatCurrency) onChange) {
  showBottomSheetFullScreen(
      context,
      Expanded(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(Dimens.paddingMid),
            children: List.generate(cList.length, (index) {
              final currency = cList[index];
              return InkWell(
                onTap: () {
                  onChange(currency);
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.paddingMid),
                  child: textAutoSizeKarla(currency.name ?? "", textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
                ),
              );
            })),
      ),
      title: "Select currency".tr,
      isScrollControlled: false);
}



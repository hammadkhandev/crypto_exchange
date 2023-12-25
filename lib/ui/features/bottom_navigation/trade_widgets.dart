import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'dashboard/dashboard_widgets.dart';

class SelectedPairView extends StatelessWidget {
  const SelectedPairView({super.key, required this.coinPair, this.lastPData, this.coinType, required this.onTap});

  final CoinPair coinPair;
  final PriceData? lastPData;
  final String? coinType;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUp = (lastPData?.price ?? 0) >= (lastPData?.lastPrice ?? 0);
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                textAutoSizeTitle(coinPair.getCoinPairName(), fontSize: Dimens.regularFontSizeLarge),
                hSpacer5(),
                showImageAsset(icon: Icons.arrow_drop_down_outlined, color: context.theme.primaryColor)
              ],
            ),
          ),
          coinDetailsItemView(currencyFormat(lastPData?.price), "${currencyFormat(lastPData?.lastPrice)}(${coinType ?? ""})",
              isSwap: true, fromKey: isUp ? FromKey.up : FromKey.down)
        ],
      ),
    );
  }
}

class OrderBookSelectionView extends StatelessWidget {
  const OrderBookSelectionView({super.key, required this.selectedValue, required this.selected});

  final String selectedValue;
  final Function(String) selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textAutoSizeTitle("Order Book".tr, fontSize: Dimens.regularFontSizeMid),
        Row(
          children: [
            OrderBookIcon(FromKey.all, selectedValue, () => selected(FromKey.all)),
            hSpacer5(),
            OrderBookIcon(FromKey.sell, selectedValue, () => selected(FromKey.sell)),
            hSpacer5(),
            OrderBookIcon(FromKey.buy, selectedValue, () => selected(FromKey.buy)),
          ],
        )
      ],
    );
  }
}

class OrderBookMiddleView extends StatelessWidget {
  const OrderBookMiddleView({super.key, this.lastPData, this.coinType, required this.isSpot});

  final PriceData? lastPData;
  final String? coinType;
  final bool isSpot;

  @override
  Widget build(BuildContext context) {
    final isUp = (lastPData?.price ?? 0) >= (lastPData?.lastPrice ?? 0);
    final color = isUp ? gBuyColor : gSellColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            textAutoSizeKarla(coinFormat(lastPData?.price), fontSize: Dimens.regularFontSizeMid, color: color),
            Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward, color: color, size: Dimens.iconSizeMinExtra),
            hSpacer5(),
            textAutoSizeKarla("${coinFormat(lastPData?.lastPrice)}(${coinType ?? ""})", fontSize: Dimens.regularFontSizeSmall),
          ],
        ),
        InkWell(onTap: () => Get.to(() => OrdersBookAll(isSpot: isSpot)), child: textAutoSizePoppins("Show More".tr))
      ],
    );
  }
}

class BankDetailsView extends StatelessWidget {
  const BankDetailsView({super.key, required this.bank});

  final Bank bank;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        vSpacer5(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textAutoSizeKarla("Bank details".tr, fontSize: Dimens.regularFontSizeMid, color: context.theme.primaryColorLight),
            SizedBox(
                height: Dimens.iconSizeMid,
                child: buttonText("Copy", bgColor: Colors.grey, onPressCallback: () => copyToClipboard(bank.toCopy()))),
          ],
        ),
        vSpacer5(),
        Container(
          decoration: boxDecorationRoundBorder(),
          padding: const EdgeInsets.all(Dimens.paddingMid),
          child: Column(
            children: [
              twoTextSpaceFixed("Account Number".tr, bank.iban ?? "",
                  maxLine: 2, subMaxLine: 3, color: context.theme.primaryColorLight, fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed("Bank name".tr, bank.bankName ?? "",
                  maxLine: 2, subMaxLine: 3, color: context.theme.primaryColorLight, fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed("Bank address".tr, bank.bankAddress ?? "",
                  maxLine: 2, subMaxLine: 3, color: context.theme.primaryColorLight, fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed("Account holder name".tr, bank.accountHolderName ?? "",
                  maxLine: 2, subMaxLine: 3, color: context.theme.primaryColorLight, fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed("Account holder address".tr, bank.accountHolderAddress ?? "",
                  maxLine: 2, subMaxLine: 3, color: context.theme.primaryColorLight, fontSize: Dimens.regularFontSizeExtraMid),
              vSpacer5(),
              twoTextSpaceFixed("Swift code".tr, bank.swiftCode ?? "",
                  maxLine: 2, subMaxLine: 3, color: context.theme.primaryColorLight, fontSize: Dimens.regularFontSizeExtraMid),
            ],
          ),
        )
      ],
    );
  }
}




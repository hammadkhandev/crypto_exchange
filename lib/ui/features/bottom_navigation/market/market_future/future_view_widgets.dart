import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/future_data.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/future_trade/future_trade_controller.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

class OpenInterestView extends StatelessWidget {
  const OpenInterestView({super.key, required this.coinPair});

  final CoinPair coinPair;

  @override
  Widget build(BuildContext context) {
    final color = getNumberColor(coinPair.priceChange);
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      margin: const EdgeInsets.only(bottom: Dimens.paddingMin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textAndTagView("Open Interest".tr, "24H Change".tr),
          _twoTextView(coinPair.getCoinPairName(), "Perpetual".tr),
          Row(
            children: [
              textAutoSizeKarla("${coinFormat(coinPair.volume)} ${coinPair.parentCoinName ?? ""}", fontSize: Dimens.regularFontSizeMid),
              hSpacer10(),
              buttonText("${coinFormat(coinPair.priceChange)}%",
                  textColor: color, bgColor: color.withOpacity(0.25), visualDensity: VisualDensity.compact),
            ],
          )
        ],
      ),
    );
  }
}

class LongShortRatioView extends StatelessWidget {
  const LongShortRatioView({super.key, required this.pair});

  final HighestVolumePair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      margin: const EdgeInsets.only(bottom: Dimens.paddingMin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textAndTagView("Long/Short Ratio".tr, "24 hour".tr),
          _twoTextView(pair.coinPair ?? "", "Perpetual".tr),
          vSpacer5(),
          _accountView("Short Account".tr, "${pair.shortAccount ?? 0}%", gSellColor),
          vSpacer2(),
          _accountView("Long Account".tr, "${pair.longAccount ?? 0}%", gBuyColor),
          vSpacer2(),
          _accountView("Long/Short Ratio".tr, "${pair.ratio ?? 0}", context.theme.focusColor),
        ],
      ),
    );
  }

  _accountView(String text, String amount, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.square_rounded, size: Dimens.iconSizeMinExtra, color: color),
        hSpacer5(),
        textAutoSizePoppins(text),
        hSpacer5(),
        textAutoSizeKarla(amount, fontSize: Dimens.regularFontSizeMid),
      ],
    );
  }
}

class HighLowPNLView extends StatelessWidget {
  const HighLowPNLView({super.key, required this.pair});

  final ProfitLossByCoinPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      margin: const EdgeInsets.only(bottom: Dimens.paddingMin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textAndTagView("Highest/Lowest PNL".tr, "24 hour".tr),
          _twoTextView(pair.highestPnl?.symbol ?? "", "Perpetual".tr),
          textAutoSizeKarla("${pair.highestPnl?.totalAmount ?? 0} ${pair.highestPnl?.coinType ?? ""}",
              fontSize: Dimens.regularFontSizeMid, color: gBuyColor),
          vSpacer5(),
          _twoTextView(pair.lowestPnl?.symbol ?? "", "Perpetual".tr),
          textAutoSizeKarla("${pair.lowestPnl?.totalAmount ?? 0} ${pair.lowestPnl?.coinType ?? ""}",
              fontSize: Dimens.regularFontSizeMid, color: gSellColor),
        ],
      ),
    );
  }
}

_twoTextView(String first, String last) {
  return Row(
    children: [
      textAutoSizeKarla(first, fontSize: Dimens.regularFontSizeMid),
      hSpacer10(),
      textAutoSizePoppins(last),
    ],
  );
}

_textAndTagView(String text, String tag) {
  return Row(
    children: [
      textAutoSizePoppins(text),
      hSpacer10(),
      buttonText(tag, textColor: Get.theme.focusColor, bgColor: Colors.black, visualDensity: VisualDensity.compact)
    ],
  );
}

class MarketIndexView extends StatelessWidget {
  const MarketIndexView({super.key, required this.coinPair});

  final CoinPair coinPair;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (Get.width - 30) / 2,
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: textAutoSizeKarla(coinPair.getCoinPairName(), fontSize: Dimens.regularFontSizeMid)),
              hSpacer5(),
              Expanded(child: textAutoSizePoppins("Perpetual".tr)),
            ],
          ),
          vSpacer5(),
          textAutoSizeKarla("${coinFormat(coinPair.priceChange, fixed: 4)}%",
              fontSize: Dimens.regularFontSizeMid, color: getNumberColor(coinPair.priceChange)),
        ],
      ),
    );
  }
}

class CoinPairItemView extends StatelessWidget {
  const CoinPairItemView({super.key, required this.coinPair});

  final CoinPair coinPair;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      margin: const EdgeInsets.only(bottom: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                ClipOval(child: showImageNetwork(imagePath: coinPair.icon, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin)),
                hSpacer5(),
                textAutoSizeKarla(coinPair.getCoinPairName(), fontSize: Dimens.regularFontSizeMid),
              ]),
              Padding(
                padding: const EdgeInsets.only(left: Dimens.paddingMin),
                child: textAutoSizePoppins("${"Vol".tr} ${coinFormat(coinPair.volume)} ${coinPair.parentCoinName ?? ""}"),
              ),
            ]),
            buttonText("Trade".tr, visualDensity: VisualDensity.compact, onPressCallback: () {
              if (TemporaryData.isFutureTradeViewShowing == true) {
                Get.find<FutureTradeController>().selectCoinPair(coinPair);
              } else {
                TemporaryData.futureCoinPair = coinPair;
                getRootController().changeBottomNavIndex(0, false);
              }
            })
          ]),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            textAutoSizeKarla(coinPair.lastPrice ?? "", fontSize: Dimens.regularFontSizeLarge),
            hSpacer5(),
            buttonText("${coinFormat(coinPair.priceChange, fixed: 2)}%",
                bgColor: getNumberColor(coinPair.priceChange).withOpacity(0.75), visualDensity: VisualDensity.compact),
            hSpacer5(),
            textAutoSizePoppins("24H Change".tr),
          ]),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/referral.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/trade_widgets.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

class WalletFiatHistory extends StatelessWidget {
  const WalletFiatHistory({super.key, required this.history, required this.historyData, required this.type});

  final WalletCurrencyHistory history;
  final List historyData;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonRoundedMain(text: historyData.first, width: 100, buttonHeight: Dimens.btnHeightMin, bgColor: historyData.last),
              textAutoSizePoppins(history.coinType ?? "",
                  color: context.theme.primaryColor, fontWeight: FontWeight.bold, fontSize: Dimens.regularFontSizeMid),
            ],
          ),
          vSpacer5(),
          twoTextSpace('Amount'.tr, coinFormat(history.amount)),
          if (type == HistoryType.withdraw) vSpacer5(),
          if (type == HistoryType.withdraw) twoTextSpace('Fees'.tr, coinFormat(history.fees)),
          if (type == HistoryType.deposit) vSpacer5(),
          if (type == HistoryType.deposit) twoTextSpace('Payment Method'.tr, history.paymentType ?? ""),
          vSpacer5(),
          if (type == HistoryType.deposit) twoTextSpace('Payment Title'.tr, history.paymentTitle ?? ""),
          if (type == HistoryType.withdraw) twoTextSpace("Bank".tr, history.bank?.bankName ?? ""),
          vSpacer5(),
          twoTextSpace('Created At'.tr, formatDate(history.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          twoTextSpace('Status'.tr, history.status ?? "", subColor: getStatusColor(history.status)),
          if (history.bankReceipt.isValid) vSpacer5(),
          if (history.bankReceipt.isValid)
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              textAutoSizeKarla("Receipt".tr,
                  fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start, color: context.theme.primaryColorLight),
              showImageNetwork(
                  imagePath: history.bankReceipt,
                  width: Dimens.iconSizeMid,
                  height: Dimens.iconSizeMid,
                  boxFit: BoxFit.cover,
                  onPressCallback: () => openUrlInBrowser(history.bankReceipt ?? ""))
            ]),
          dividerHorizontal()
        ],
      ),
    );
  }
}

class TradeItemView extends StatelessWidget {
  const TradeItemView(this.tradeHistory, this.historyData, this.type, {super.key});

  final Trade tradeHistory;
  final List historyData;
  final String type;

  @override
  Widget build(BuildContext context) {
    final statusData = getStatusData(tradeHistory.status ?? 0);
    final pcl = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttonText(historyData.first, bgColor: historyData.last),
          vSpacer5(),
          if (type == HistoryType.transaction) twoTextSpaceFixed('Transaction Id'.tr, tradeHistory.transactionId ?? "", color: pcl),
          if (type == HistoryType.transaction) vSpacer5(),
          twoTextSpaceFixed("${'Base Coin'.tr}/${'Trade Coin'.tr}", "${tradeHistory.baseCoin ?? ""}/${tradeHistory.tradeCoin ?? ""}",
              color: pcl, flex: 7),
          vSpacer5(),
          twoTextSpace('Amount'.tr, coinFormat(tradeHistory.amount)),
          vSpacer5(),
          if (type != HistoryType.transaction) twoTextSpace('Processed'.tr, coinFormat(tradeHistory.processed)),
          if (type != HistoryType.transaction) vSpacer5(),
          twoTextSpace('Price'.tr, coinFormat(tradeHistory.price)),
          vSpacer5(),
          if (type == HistoryType.transaction) twoTextSpaceFixed('Fees'.tr, coinFormat(tradeHistory.fees), color: pcl),
          if (type == HistoryType.transaction) vSpacer5(),
          twoTextSpace('Date'.tr,
              type == HistoryType.transaction ? (tradeHistory.time ?? "") : formatDate(tradeHistory.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          if (type != HistoryType.transaction) twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
          dividerHorizontal()
        ],
      ),
    );
  }
}

class StopLimitItemView extends StatelessWidget {
  const StopLimitItemView(this.tradeHistory, this.historyData, {super.key});

  final Trade tradeHistory;
  final List historyData;

  @override
  Widget build(BuildContext context) {
    final pcl = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttonText(historyData.first, bgColor: historyData.last),
          vSpacer5(),
          twoTextSpaceFixed("${'Base Coin'.tr}/${'Trade Coin'.tr}", "${tradeHistory.baseCoin ?? ""}/${tradeHistory.tradeCoin ?? ""}",
              color: pcl, flex: 7),
          vSpacer5(),
          twoTextSpace('Amount'.tr, coinFormat(tradeHistory.amount)),
          vSpacer5(),
          twoTextSpace('Price'.tr, coinFormat(tradeHistory.price)),
          vSpacer5(),
          twoTextSpaceFixed('Order Type'.tr, tradeHistory.type ?? "", color: pcl),
          vSpacer5(),
          twoTextSpace('Date'.tr, formatDate(tradeHistory.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          dividerHorizontal()
        ],
      ),
    );
  }
}

class FiatHistoryItemView extends StatelessWidget {
  const FiatHistoryItemView(this.history, this.historyData, {super.key});

  final FiatHistory history;
  final List historyData;

  @override
  Widget build(BuildContext context) {
    final statusData = getStatusData(history.status ?? 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            buttonRoundedMain(text: historyData.first, width: 150, buttonHeight: Dimens.btnHeightMin, bgColor: historyData.last),
            (history.bank != null || history.paymentInfo.isValid)
                ? buttonOnlyIcon(
                    iconData: Icons.remove_red_eye_rounded,
                    size: Dimens.iconSizeMin,
                    iconColor: context.theme.primaryColor,
                    visualDensity: minimumVisualDensity,
                    onPressCallback: () => _showPaymentView(context))
                : hSpacer10()
          ]),
          vSpacer5(),
          twoTextSpace('Currency Amount'.tr, "${coinFormat(history.currencyAmount)} ${history.currency ?? ""}"),
          vSpacer5(),
          twoTextSpace('Coin Amount'.tr, "${coinFormat(history.coinAmount)} ${history.coinType ?? ""}"),
          vSpacer5(),
          twoTextSpace('Rate'.tr, "${coinFormat(history.rate)} ${history.coinType ?? ""}"),
          vSpacer5(),
          if (history.transactionId.isValid)
            twoTextSpaceFixed('Transaction ID'.tr, history.transactionId ?? "", color: context.theme.primaryColorLight),
          if (history.transactionId.isValid) vSpacer5(),
          twoTextSpace('Date'.tr, formatDate(history.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
          dividerHorizontal()
        ],
      ),
    );
  }

  _showPaymentView(BuildContext context) {
    final view = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpacer10(),
        textAutoSizeKarla("Payment Details".tr, fontSize: Dimens.regularFontSizeLarge),
        vSpacer20(),
        if (history.bank != null)
          BankDetailsView(bank: history.bank!)
        else if (history.paymentInfo.isValid)
          Container(
              decoration: boxDecorationRoundBorder(),
              width: Get.width,
              padding: const EdgeInsets.all(Dimens.paddingMid),
              child: textAutoSizeKarla(history.paymentInfo ?? "", fontSize: Dimens.regularFontSizeMid)),
        vSpacer20(),
      ],
    );
    showModalSheetFullScreen(context, view);
  }
}

class ReferralItemView extends StatelessWidget {
  const ReferralItemView(this.history, this.historyData, this.type, {super.key});

  final ReferralHistory history;
  final List historyData;
  final String type;

  @override
  Widget build(BuildContext context) {
    final pcl = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttonText(historyData.first, bgColor: historyData.last),
          vSpacer5(),
          twoTextSpaceFixed('Referral user mail'.tr, history.referralUserEmail ?? "", color: pcl),
          vSpacer5(),
          twoTextSpaceFixed('Transaction Id'.tr, history.transactionId ?? "", color: pcl),
          vSpacer5(),
          twoTextSpace('Amount'.tr, "${coinFormat(history.amount)} ${history.coinType}"),
          vSpacer5(),
          twoTextSpace('Date'.tr, formatDate(history.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          dividerHorizontal()
        ],
      ),
    );
  }
}

class HistoryItemView extends StatelessWidget {
  const HistoryItemView(this.history, this.historyData, this.type, {super.key});

  final History history;
  final List historyData;
  final String type;

  @override
  Widget build(BuildContext context) {
    final statusData =
        (type == HistoryType.deposit || type == HistoryType.withdraw) ? getActiveStatusData(history.status ?? 0) : getStatusData(history.status ?? 0);
    final pcl = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonRoundedMain(text: historyData.first, width: 100, buttonHeight: Dimens.btnHeightMin, bgColor: historyData.last),
              textAutoSizePoppins(history.coinType ?? "",
                  color: context.theme.primaryColor, fontWeight: FontWeight.bold, fontSize: Dimens.regularFontSizeMid),
            ],
          ),
          vSpacer5(),
          twoTextSpace('Amount'.tr, coinFormat(history.amount)),
          vSpacer5(),
          twoTextSpace('Fees'.tr, coinFormat(history.fees)),
          vSpacer5(),
          twoTextSpaceFixed('Address'.tr, history.address ?? "", color: pcl),
          vSpacer5(),
          if (type == HistoryType.deposit) twoTextSpaceFixed('Transaction ID'.tr, history.transactionId ?? "", color: pcl),
          if (type == HistoryType.withdraw) twoTextSpaceFixed('Transaction Hash'.tr, history.transactionHash ?? "", color: pcl),
          vSpacer5(),
          twoTextSpace('Created At'.tr, formatDate(history.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
          dividerHorizontal()
        ],
      ),
    );
  }
}

class SwapHistoryItemView extends StatelessWidget {
  const SwapHistoryItemView(this.swapHistory, this.historyData, {super.key});

  final SwapHistory swapHistory;
  final List historyData;

  @override
  Widget build(BuildContext context) {
    final statusData = getStatusData(swapHistory.status ?? 0);
    final pcl = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buttonRoundedMain(text: historyData.first, width: 100, buttonHeight: Dimens.btnHeightMin, bgColor: historyData.last),
          vSpacer5(),
          twoTextSpaceFixed('From Wallet'.tr, swapHistory.fromWallet ?? "", color: pcl),
          vSpacer5(),
          twoTextSpaceFixed('To Wallet'.tr, swapHistory.toWallet ?? "", color: pcl),
          vSpacer5(),
          twoTextSpace('Requested Amount'.tr, coinFormat(swapHistory.requestedAmount)),
          vSpacer5(),
          twoTextSpace('Converted Amount'.tr, coinFormat(swapHistory.convertedAmount)),
          vSpacer5(),
          twoTextSpace('Rate'.tr, coinFormat(swapHistory.rate), color: pcl),
          vSpacer5(),
          twoTextSpace('Created At'.tr, formatDate(swapHistory.createdAt, format: dateTimeFormatYyyyMMDdHhMm)),
          vSpacer5(),
          twoTextSpace('Status'.tr, statusData.first, subColor: statusData.last),
          dividerHorizontal()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/swap/swap_screen.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'wallet_controller.dart';
import 'wallet_deposit/currency_wallet_deposit_screen.dart';
import 'wallet_deposit/wallet_deposit_screen.dart';
import 'wallet_withdrawal/currency_wallet_withdrawal_page.dart';
import 'wallet_withdrawal/wallet_withdraw_screen.dart';

class WalletNameView extends StatelessWidget {
  const WalletNameView({super.key, required this.wallet, this.isExpanded = false});

  final Wallet wallet;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        showImageNetwork(imagePath: wallet.coinIcon, width: Dimens.iconSizeMid, height: Dimens.iconSizeMid),
        hSpacer10(),
        isExpanded ? Expanded(child: _nameView(context)) : _nameView(context),
      ],
    );
  }

  _nameView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textAutoSizeKarla(wallet.coinType ?? "", fontSize: Dimens.regularFontSizeMid),
        textAutoSizePoppins(wallet.name ?? "", color: context.theme.primaryColor),
      ],
    );
  }
}

class CommonWalletItem extends StatelessWidget {
  const CommonWalletItem({super.key, required this.wallet, required this.fromType});

  final Wallet wallet;
  final int fromType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      margin: const EdgeInsets.only(bottom: Dimens.paddingMid),
      child: Row(
        children: [
          Expanded(child: WalletNameView(wallet: wallet,isExpanded: true)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textAutoSizeTitle(coinFormat(wallet.balance), fontSize: Dimens.regularFontSizeMid),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buttonOnlyIcon(
                        iconData: Icons.send_outlined,
                        size: Dimens.iconSizeMin,
                        visualDensity: minimumVisualDensity,
                        iconColor: context.theme.primaryColor,
                        onPressCallback: () => _showTransferView(context, true)),
                    buttonOnlyIcon(
                        iconData: Icons.wallet_outlined,
                        size: Dimens.iconSizeMin,
                        visualDensity: minimumVisualDensity,
                        iconColor: context.theme.primaryColor,
                        onPressCallback: () => _showTransferView(context, false))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _showTransferView(BuildContext context, bool isSend) {
    final title = isSend ? "Send Balance".tr : "Receive Balance".tr;
    final name = fromType == WalletViewType.p2p ? "P2P" : "Future";
    final subtitle = isSend
        ? "sent_coin_to_spot_wallet".trParams({"coin": wallet.coinType ?? "", "name": name})
        : "receive_coin_from_spot_wallet".trParams({"coin": wallet.coinType ?? "", "name": name});
    final amountEditController = TextEditingController();
    RxString error = "".obs;

    showModalSheetFullScreen(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            vSpacer15(),
            textAutoSizeKarla(title, fontSize: Dimens.regularFontSizeMid),
            vSpacer5(),
            textAutoSizePoppins(subtitle, maxLines: 2),
            vSpacer20(),
            textFieldWithSuffixIcon(
                controller: amountEditController,
                labelText: "Amount".tr,
                hint: "Your amount".tr,
                type: const TextInputType.numberWithOptions(decimal: true),
                onTextChange: (text) => error.value = ""),
            Obx(() => error.value.isValid ? textAutoSizePoppins(error.value, color: Colors.red) : vSpacer0()),
            vSpacer20(),
            buttonRoundedMain(
                text: "Exchange".tr,
                onPressCallback: () {
                  final amount = makeDouble(amountEditController.text.trim());
                  if (amount <= 0) {
                    error.value = "amount_must_greater_than_0".tr;
                    return;
                  }
                  hideKeyboard(context: context);
                  Get.find<WalletController>().transferWalletAmount(wallet, fromType, amount, isSend);
                }),
            vSpacer15(),
          ],
        ));
  }
}

class SpotWalletView extends StatelessWidget {
  const SpotWalletView({super.key, required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    String currencyName = getSettingsLocal()?.currency ?? DefaultValue.currency;
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: InkWell(
        onTap: () => showModalSheetFullScreen(context, SpotWalletDetailsView(wallet: wallet)),
        child: Row(
          children: [
            Expanded(child: WalletNameView(wallet: wallet, isExpanded: true)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textAutoSizeTitle(coinFormat(wallet.availableBalance), fontSize: Dimens.regularFontSizeMid, maxLines: 1),
                  textAutoSizeRoboto(currencyFormat(wallet.availableBalanceUsd, name: currencyName), fontSize: Dimens.regularFontSizeExtraMid),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SpotWalletDetailsView extends StatelessWidget {
  SpotWalletDetailsView({super.key, required this.wallet});

  final Wallet wallet;

  final _controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    final pairList = _controller.getCoinPairList(wallet.coinType ?? "");
    final isSwapActive = getSettingsLocal()?.swapStatus == 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vSpacer10(),
        WalletNameView(wallet: wallet),
        vSpacer20(),
        WalletBalanceView(title: 'Total Balance'.tr, coin: wallet.total, currency: wallet.totalBalanceUsd),
        dividerHorizontal(),
        WalletBalanceView(title: 'On Order'.tr, coin: wallet.onOrder, currency: wallet.onOrderUsd),
        dividerHorizontal(),
        WalletBalanceView(title: 'Available Balance'.tr, coin: wallet.availableBalance, currency: wallet.availableBalanceUsd),
        dividerHorizontal(),
        Wrap(
          spacing: 10,
          children: [
            if (wallet.isDeposit == 1)
              buttonText("Deposit".tr, onPressCallback: () {
                Get.back();
                if (wallet.currencyType == CurrencyType.crypto) {
                  Get.to(() => WalletDepositScreen(wallet: wallet));
                } else if (wallet.currencyType == CurrencyType.fiat) {
                  Get.to(() => CurrencyWalletDepositScreen(wallet: wallet));
                }
              }),
            if (wallet.isWithdrawal == 1)
              buttonText("Withdraw".tr, onPressCallback: () {
                Get.back();
                if (wallet.currencyType == CurrencyType.crypto) {
                  Get.to(() => WalletWithdrawScreen(wallet: wallet));
                } else if (wallet.currencyType == CurrencyType.fiat) {
                  Get.to(() => CurrencyWalletWithdrawalScreen(wallet: wallet));
                }
              }),
            if (wallet.tradeStatus == 1 && pairList.isNotEmpty)
              popupMenu(pairList, child: buttonText("Trade".tr), onSelected: (selected) {
                Get.back();
                final pair = _controller.coinPairs.firstWhere((element) => element.coinPairName == selected);
                getDashboardController().selectedCoinPair.value = pair;
                getRootController().changeBottomNavIndex(0, false);
              }),
            if (isSwapActive)
              buttonText("Swap".tr, onPressCallback: () {
                Get.back();
                Get.to(() => SwapScreen(preWallet: wallet));
              }),
          ],
        ),
        vSpacer10(),
      ],
    );
  }
}

class WalletBalanceView extends StatelessWidget {
  const WalletBalanceView({super.key, required this.title, this.coin, this.currency});

  final String title;
  final double? coin;
  final double? currency;

  @override
  Widget build(BuildContext context) {
    String currencyName = getSettingsLocal()?.currency ?? DefaultValue.currency;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 2, child: textAutoSizeTitle(title, fontSize: Dimens.regularFontSizeMid, maxLines: 1, textAlign: TextAlign.start)),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textAutoSizeTitle(coinFormat(coin), fontSize: Dimens.regularFontSizeMid),
              textAutoSizeRoboto(currencyFormat(currency, name: currencyName), fontSize: Dimens.regularFontSizeExtraMid),
            ],
          ),
        ),
      ],
    );
  }
}

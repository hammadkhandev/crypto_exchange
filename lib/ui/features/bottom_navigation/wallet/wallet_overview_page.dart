import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'wallet_controller.dart';

class WalletOverviewPage extends StatefulWidget {
  const WalletOverviewPage({super.key});

  @override
  State<WalletOverviewPage> createState() => _WalletOverviewPageState();
}

class _WalletOverviewPageState extends State<WalletOverviewPage> {
  final _controller = Get.find<WalletController>();
  Rx<WalletOverview> wOverview = WalletOverview().obs;
  RxString selectedCoin = "".obs;

  Future<void> _getOverviewData() async {
    _controller.refreshController.callRefresh();
    _controller.getWalletOverviewData(coinType: selectedCoin.value, (overview) {
      wOverview.value = overview;
      selectedCoin.value = wOverview.value.selectedCoin ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: EasyRefresh(
        controller: _controller.refreshController,
        refreshOnStart: true,
        onRefresh: _getOverviewData,
        header: ClassicHeader(showText: false, iconTheme: const IconThemeData().copyWith(color: context.theme.colorScheme.secondary)),
        child: Obx(() {
          String currencyName = getSettingsLocal()?.currency ?? DefaultValue.currency;
          final data = wOverview.value;
          final coins = data.coins ?? [];
          final settings = getSettingsLocal();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid, vertical: Dimens.paddingMin),
            children: [
              Container(
                decoration: boxDecorationRoundCorner(),
                padding: const EdgeInsets.all(Dimens.paddingMid),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textAutoSizePoppins('Estimated Balance'.tr, color: context.theme.primaryColor),
                    vSpacer5(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        textAutoSizeKarla(coinFormat(data.total), fontSize: Dimens.regularFontSizeLarge),
                        hSpacer10(),
                        popupMenu(coins, child: _coinNameView(data.selectedCoin, coins.isNotEmpty), onSelected: (selected) {
                          selectedCoin.value = selected;
                          _getOverviewData();
                        }),
                      ],
                    ),
                    textAutoSizeRoboto(currencyFormat(data.totalUsd, name: currencyName), fontSize: Dimens.regularFontSizeExtraMid),
                  ],
                ),
              ),
              vSpacer20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textAutoSizeKarla('Asset'.tr, fontSize: Dimens.regularFontSizeLarge),
                  textAutoSizeKarla('Available Balance'.tr, fontSize: Dimens.regularFontSizeLarge)
                ],
              ),
              vSpacer5(),
              if (data.spotWallet != null)
                AssetItemView(
                    icon: Icons.dashboard_outlined,
                    name: "Spot".tr,
                    amount: data.spotWallet,
                    amountCurrency: data.spotWalletUsd,
                    coinType: data.selectedCoin,
                    onTap: () => _controller.changeWalletTab(WalletViewType.spot)),
              if (settings?.enableFutureTrade == 1 && data.futureWallet != null)
                AssetItemView(
                    icon: Icons.update_outlined,
                    name: "Future".tr,
                    amount: data.futureWallet,
                    amountCurrency: data.futureWalletUsd,
                    coinType: data.selectedCoin,
                    onTap: () => _controller.changeWalletTab(WalletViewType.future)),
              if (settings?.p2pModule == 1 && data.p2PWallet != null)
                AssetItemView(
                    icon: Icons.people_outline,
                    name: "P2P".tr,
                    amount: data.p2PWallet,
                    amountCurrency: data.p2PWalletUsd,
                    coinType: data.selectedCoin,
                    onTap: () => _controller.changeWalletTab(WalletViewType.p2p)),
              vSpacer20(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textAutoSizeKarla('Recent Transactions'.tr, fontSize: Dimens.regularFontSizeLarge),
                  buttonText("View All".tr, bgColor: Colors.grey, onPressCallback: () {
                    TemporaryData.activityType = HistoryType.transaction;
                    getRootController().changeBottomNavIndex(3, false);
                  }),
                ],
              ),
              vSpacer5(),
              if (data.withdraw.isValid)
                Column(
                    children: List.generate(data.withdraw!.length,
                        (index) => HistoryItemView(history: data.withdraw![index], isWithdraw: true, coinType: data.selectedCoin))),
              if (data.deposit.isValid)
                Column(
                    children: List.generate(data.deposit!.length,
                        (index) => HistoryItemView(history: data.deposit![index], isWithdraw: false, coinType: data.selectedCoin))),
              if (!data.deposit.isValid && !data.withdraw.isValid) showEmptyView(height: Dimens.paddingLargeDouble),
              vSpacer10()
            ],
          );
        }),
      ),
    );
  }

  _coinNameView(String? coinType, bool showIcon) {
    return Row(children: [
      textAutoSizeKarla(coinType ?? "", fontSize: Dimens.regularFontSizeLarge),
      if (showIcon) Icon(Icons.expand_more, size: Dimens.iconSizeMin, color: context.theme.primaryColor)
    ]);
  }
}

class AssetItemView extends StatelessWidget {
  const AssetItemView({super.key, required this.icon, required this.name, this.amount, this.amountCurrency, this.coinType, required this.onTap});

  final IconData icon;
  final String name;
  final double? amount;
  final double? amountCurrency;
  final String? coinType;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    String currencyName = getSettingsLocal()?.currency ?? DefaultValue.currency;
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      margin: const EdgeInsets.symmetric(vertical: Dimens.paddingMin),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  showImageAsset(icon: icon, width: Dimens.iconSizeMid, height: Dimens.iconSizeMid),
                  hSpacer5(),
                  textAutoSizeKarla(name, fontSize: Dimens.regularFontSizeLarge),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  textAutoSizeKarla(coinFormat(amount), fontSize: Dimens.regularFontSizeMid),
                  textAutoSizeRoboto(currencyFormat(amountCurrency, name: currencyName), fontSize: Dimens.regularFontSizeExtraMid),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HistoryItemView extends StatelessWidget {
  const HistoryItemView({super.key, required this.history, required this.isWithdraw, this.coinType});

  final History history;
  final bool isWithdraw;
  final String? coinType;

  @override
  Widget build(BuildContext context) {
    final icon = isWithdraw ? Icons.file_upload_outlined : Icons.file_download_outlined;
    final title = isWithdraw ? "Withdraw".tr : "Deposit".tr;
    final sign = isWithdraw ? "-" : "+";
    return Container(
      decoration: boxDecorationRoundBorder(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      margin: const EdgeInsets.symmetric(vertical: Dimens.paddingMin),
      child: InkWell(
        // onTap: () => showModalSheetFullScreen(context, _walletDetailsView(wallet)),
        child: Row(
          children: [
            showImageAsset(icon: icon, width: Dimens.iconSizeMid, height: Dimens.iconSizeMid),
            hSpacer5(),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textAutoSizeKarla(title, fontSize: Dimens.regularFontSizeMid),
                  vSpacer5(),
                  textAutoSizePoppins(formatDate(history.createdAt)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  textAutoSizeKarla("$sign${coinFormat(history.amount)} $coinType", fontSize: Dimens.regularFontSizeMid),
                  vSpacer5(),
                  textAutoSizePoppins("Completed".tr, color: Colors.green),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

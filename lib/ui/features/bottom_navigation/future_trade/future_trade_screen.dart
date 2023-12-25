import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/dashboard/dashboard_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';

import '../trade_widgets.dart';
import 'future_history_views.dart';
import 'future_trade_controller.dart';

class FutureTradeScreen extends StatefulWidget {
  const FutureTradeScreen({Key? key}) : super(key: key);

  @override
  FutureTradeScreenState createState() => FutureTradeScreenState();
}

class FutureTradeScreenState extends State<FutureTradeScreen> {
  final _controller = Get.put(FutureTradeController());
  final isMyOrders = true.obs;

  @override
  void initState() {
    super.initState();
    TemporaryData.isFutureTradeViewShowing = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (TemporaryData.futureCoinPair != null) {
        _controller.selectedCoinPair.value = TemporaryData.futureCoinPair!;
        TemporaryData.futureCoinPair = null;
      }
      _controller.getFutureTradeData();
    });
  }

  @override
  void dispose() {
    _controller.unSubscribeChannel(true);
    TemporaryData.isFutureTradeViewShowing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Column(
        children: [
          appBarMain(context, title: "Future Trading".tr),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
              shrinkWrap: true,
              children: [
                Obx(() {
                  final fdd = _controller.futureDashboardData.value;
                  return SelectedPairView(
                    coinPair: _controller.selectedCoinPair.value,
                    lastPData: fdd.lastPriceData.isValid ? fdd.lastPriceData?.first : PriceData(),
                    coinType: fdd.orderData?.baseCoin,
                    onTap: () => _chooseCoinPairModal(),
                  );
                }),
                vSpacer5(),
                Obx(() => SelectedCoinDetailsView(total: _controller.futureDashboardData.value.orderData?.total)),
                vSpacer5(),
                _oderBookView(),
                vSpacer5(),
                Obx(() => Row(
                      children: [
                        Expanded(
                            child: buttonText("My Orders".tr,
                                bgColor: isMyOrders.value ? null : Colors.transparent,
                                borderColor: Get.theme.colorScheme.secondary,
                                textColor: Get.theme.primaryColor,
                                onPressCallback: () => isMyOrders.value = true)),
                        hSpacer10(),
                        Expanded(
                            child: buttonText("Market Trades".tr,
                                bgColor: isMyOrders.value ? Colors.transparent : null,
                                borderColor: Get.theme.colorScheme.secondary,
                                textColor: Get.theme.primaryColor,
                                onPressCallback: () => isMyOrders.value = false)),
                      ],
                    )),
                Obx(() => isMyOrders.value ? const FutureHistoryViews() : _tradeListView()),
                vSpacer10(),
              ],
            ),
          ),
          const DashboardBottomButtonView(fromKey: FromKey.future)
        ],
      ),
    );
  }

  void _chooseCoinPairModal() {
    _controller.getCoinPairList("");
    Get.bottomSheet(
        Container(
            alignment: Alignment.bottomCenter,
            color: context.theme.scaffoldBackgroundColor,
            height: getContentHeight(),
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                textFieldSearch(controller: _controller.searchEditController, onTextChange: (value) => _controller.getCoinPairList(value)),
                vSpacer10(),
                listHeaderView("Coin".tr, "Last".tr, "Change".tr),
                dividerHorizontal(),
                Expanded(child: Obx(() {
                  return ListView(
                      shrinkWrap: true,
                      children: List.generate(_controller.coinPairs.length, (index) {
                        return CoinPairItemView(
                            coinPair: _controller.coinPairs[index],
                            onTap: () {
                              Get.back();
                              _controller.selectCoinPair(_controller.coinPairs[index]);
                            });
                      }));
                }))
              ],
            )),
        isDismissible: true);
  }

  _oderBookView() {
    return Container(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      decoration: boxDecorationRoundBorder(),
      child: Column(
        children: [
          Obx(() => OrderBookSelectionView(
              selectedValue: _controller.selectedOrderSort.value, selected: (select) => _controller.selectedOrderSort.value = select)),
          vSpacer5(),
          dividerHorizontal(height: Dimens.paddingMid),
          Obx(() {
            final total = _controller.futureDashboardData.value.orderData?.total;
            return listHeaderView(
                "${"Price".tr}(${total?.baseWallet?.coinType ?? ""})", "${"Amount".tr}(${total?.tradeWallet?.coinType ?? ""})", "Total".tr);
          }),
          dividerHorizontal(height: Dimens.paddingMid),
          Obx(() {
            return _controller.selectedOrderSort.value == FromKey.buy
                ? vSpacer0()
                : _controller.sellExchangeOrder.isEmpty
                    ? showEmptyView(height: Dimens.menuHeight)
                    : Column(
                        children: List.generate(_controller.getListLength(_controller.sellExchangeOrder),
                            (index) => OderBookItemView(exchangeOrder: _controller.sellExchangeOrder[index], type: FromKey.sell)),
                      );
          }),
          dividerHorizontal(height: Dimens.paddingMid),
          Obx(() {
            final fdd = _controller.futureDashboardData.value;
            PriceData? lastPData = fdd.lastPriceData.isValid ? fdd.lastPriceData?.first : PriceData();
            return OrderBookMiddleView(lastPData: lastPData, coinType: fdd.orderData?.baseCoin, isSpot: false);
          }),
          dividerHorizontal(height: Dimens.paddingMid),
          Obx(() {
            return _controller.selectedOrderSort.value == FromKey.sell
                ? vSpacer0()
                : _controller.buyExchangeOrder.isEmpty
                    ? showEmptyView(height: Dimens.menuHeight)
                    : Column(
                        children: List.generate(_controller.getListLength(_controller.buyExchangeOrder),
                            (index) => OderBookItemView(exchangeOrder: _controller.buyExchangeOrder[index], type: FromKey.buy)),
                      );
          }),
        ],
      ),
    );
  }

  _tradeListView() {
    return Container(
      padding: const EdgeInsets.all(Dimens.paddingMid),
      decoration: boxDecorationRoundBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final total = _controller.futureDashboardData.value.orderData?.total;
            return listHeaderView(
                "${"Price".tr}(${total?.baseWallet?.coinType ?? ""})", "${"Amount".tr}(${total?.tradeWallet?.coinType ?? ""})", "Time".tr);
          }),
          dividerHorizontal(),
          Obx(() {
            return _controller.exchangeTrades.isEmpty
                ? showEmptyView()
                : Column(
                    // shrinkWrap: true,
                    children:
                        List.generate(_controller.exchangeTrades.length, (index) => TradeItemView(exchangeTrade: _controller.exchangeTrades[index])),
                  );
          }),
        ],
      ),
    );
  }
}

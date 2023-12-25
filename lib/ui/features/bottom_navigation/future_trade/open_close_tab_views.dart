import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/future_data.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/ui/features/auth/sign_in/sign_in_screen.dart';
import 'future_trade_controller.dart';

class OpenCloseTabViews extends StatefulWidget {
  final String? fromPage;

  const OpenCloseTabViews({Key? key, this.fromPage}) : super(key: key);

  @override
  OpenCloseTabViewsState createState() => OpenCloseTabViewsState();
}

class OpenCloseTabViewsState extends State<OpenCloseTabViews> with SingleTickerProviderStateMixin {
  final _controller = Get.find<FutureTradeController>();
  TabController? tabController;
  RxInt selectedTabIndex = 0.obs;
  RxBool isIsolate = false.obs;
  RxBool isTpSlOpen = false.obs;
  RxInt selectedLeverageIndex = 0.obs;
  RxInt selectedSubTabIndexOpen = 0.obs;
  RxInt selectedSubTabIndexClose = 0.obs;
  RxInt selectedSizeCoinIndex = 0.obs;
  final priceEditController = TextEditingController();
  final stopPriceEditController = TextEditingController();
  final sizeEditController = TextEditingController();
  final takeProfitEditController = TextEditingController();
  final stopLossEditController = TextEditingController();
  Timer? _preDataTimer;
  Rx<FTPreOrderData> ftPreOrderData = FTPreOrderData().obs;

  @override
  void initState() {
    selectedTabIndex.value = (widget.fromPage == FromKey.open ? 0 : 1);
    tabController = TabController(vsync: this, length: 2, initialIndex: selectedTabIndex.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
        decoration: boxDecorationRoundBorder(),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 35,
              child: Obx(() {
                final selectedColor = selectedTabIndex.value == 0 ? gBuyColor : gSellColor;
                return tabBarUnderline(["Open".tr, "Close".tr], tabController, indicatorColor: selectedColor, onTap: (index) {
                  selectedTabIndex.value = index;
                  _clearInputViews();
                });
              }),
            ),
            dividerHorizontal(height: 0),
            Row(children: [
              Expanded(
                  flex: 1,
                  child: Obx(() => buttonText(isIsolate.value ? "Isolated".tr : "Cross".tr,
                          textColor: context.theme.primaryColor, bgColor: Colors.transparent, onPressCallback: () {
                        showModalSheetFullScreen(
                            context,
                            MarginModeView(
                                isIsolate: isIsolate.value,
                                coinPair: _controller.selectedCoinPair.value.getCoinPairName(),
                                onChange: (isolate) => isIsolate.value = isolate));
                      }))),
              dividerVertical(color: Colors.grey, height: 30),
              Expanded(
                  flex: 1,
                  child: Obx(() => buttonText("${ListConstants.leverages[selectedLeverageIndex.value]}x",
                          textColor: context.theme.primaryColor, bgColor: Colors.transparent, onPressCallback: () {
                        showModalSheetFullScreen(
                            context,
                            LeverageSelectionView(
                                selectedIndex: selectedLeverageIndex.value, onSelect: (index) => selectedLeverageIndex.value = index));
                      }))),
            ]),
            dividerHorizontal(height: 0),
            vSpacer10(),
            Obx(() {
              int subIndex = selectedTabIndex.value == 0 ? selectedSubTabIndexOpen.value : selectedSubTabIndexClose.value;
              final balance = _controller.futureDashboardData.value.orderData?.total?.baseWallet?.balance;
              if ((balance ?? 0) > 0) _controller.fBalance = balance!;
              return Column(
                children: [
                  tabBarText(["Limit".tr, "Market".tr, "Stop Limit".tr, "Stop Market".tr], subIndex, (index) {
                    _clearInputViews();
                    selectedTabIndex.value == 0 ? selectedSubTabIndexOpen.value = index : selectedSubTabIndexClose.value = index;
                  }, selectedColor: selectedTabIndex.value == 0 ? gBuyColor : gSellColor, fontSize: Dimens.regularFontSizeExtraMid),
                  vSpacer10(),
                  _inputViews(subIndex, _controller.fBalance)
                ],
              );
            })
            // Obx(() => _buySellTabView(selectedTabIndex.value))
          ],
        ),
      ),
    );
  }

  Widget _inputViews(int index, double? balance) {
    final baseCoinType = _controller.futureDashboardData.value.orderData?.total?.baseWallet?.coinType ?? "";
    final tradeCoinType = _controller.futureDashboardData.value.orderData?.total?.tradeWallet?.coinType ?? "";
    final price = _controller.futureDashboardData.value.orderData?.total?.tradeWallet?.lastPrice;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
      child: Column(
        children: [
          vSpacer5(),
          twoTextSpaceBackground('Available'.tr, "$balance $baseCoinType",
              bgColor: gIsDarkMode ? null : context.theme.primaryColorLight, height: Dimens.btnHeightMid),
          vSpacer10(),
          if (index == 2 || index == 3)
            textFieldWithPrefixSuffixText(
                controller: stopPriceEditController,
                prefixText: "Stop Price".tr,
                suffixText: "Mark".tr,
                suffixColor: context.theme.primaryColor,
                onTextChange: _onTextChanged),
          if (index == 2 || index == 3) vSpacer10(),
          if (index == 0 || index == 2)
            textFieldWithPrefixSuffixText(
                controller: priceEditController,
                prefixText: "Price".tr,
                text: coinFormat(price),
                suffixText: baseCoinType,
                onTextChange: _onTextChanged),
          if (index == 0 || index == 2) vSpacer10(),
          textFieldWithWidget(
              controller: sizeEditController,
              textAlign: TextAlign.end,
              type: const TextInputType.numberWithOptions(decimal: true),
              onTextChange: _onTextChanged,
              prefixWidget: textFieldTextWidget("Size".tr),
              suffixWidget: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.only(right: Dimens.paddingMin),
                  child: tabBarText([tradeCoinType, baseCoinType], selectedColor: context.theme.focusColor, selectedSizeCoinIndex.value, (p0) {
                    selectedSizeCoinIndex.value = p0;
                    _checkAndGetPreOrderData();
                  }),
                ),
              )),
          if (selectedTabIndex.value == 0) _tpSLView(),
          vSpacer10(),
          _buttonView(),
          vSpacer5(),
          Obx(() => PreOrderDataView(
              preData: ftPreOrderData.value,
              total: _controller.futureDashboardData.value.orderData?.total,
              isTrade: selectedSizeCoinIndex.value == 0))
        ],
      ),
    );
  }

  _buttonView() {
    bool isOpen = selectedTabIndex.value == 0;
    return gUserRx.value.id == 0
        ? buttonRoundedMain(
            text: "Login".tr, bgColor: Colors.red, width: context.width / 2, onPressCallback: () => Get.offAll(() => const SignInPage()))
        : Row(
            children: [
              Expanded(child: buttonText(isOpen ? "Open Long".tr : "Close Short".tr, onPressCallback: () => _checkInputData(isOpen ? true : null))),
              hSpacer10(),
              Expanded(child: buttonText(isOpen ? "Open Short".tr : "Close Long".tr, onPressCallback: () => _checkInputData(isOpen ? false : null))),
            ],
          );
  }

  _tpSLView() {
    return Obx(() => Column(
          children: [
            vSpacer10(),
            Row(children: [
              Checkbox(
                visualDensity: minimumVisualDensity,
                value: isTpSlOpen.value,
                onChanged: (bool? value) => isTpSlOpen.value = value ?? false,
              ),
              textAutoSizeKarla("TP/SL".tr, fontSize: Dimens.regularFontSizeMid),
              const Spacer(),
              textAutoSizePoppins("${"Advance".tr} %")
            ]),
            if (isTpSlOpen.value)
              Column(children: [
                vSpacer10(),
                textFieldWithPrefixSuffixText(
                    controller: takeProfitEditController,
                    prefixText: "Take Profit".tr,
                    suffixText: "Mark".tr,
                    suffixColor: context.theme.primaryColor),
                vSpacer10(),
                textFieldWithPrefixSuffixText(
                    controller: stopLossEditController, prefixText: "Stop Loss".tr, suffixText: "Mark".tr, suffixColor: context.theme.primaryColor),
              ])
          ],
        ));
  }

  void _clearInputViews() {
    takeProfitEditController.text = "";
    stopLossEditController.text = "";
    sizeEditController.text = "";
    priceEditController.text = "";
    stopPriceEditController.text = "";
    isTpSlOpen.value = false;
    ftPreOrderData.value = FTPreOrderData();
  }

  void _onTextChanged(String text) {
    if (_preDataTimer?.isActive ?? false) _preDataTimer?.cancel();
    _preDataTimer = Timer(const Duration(seconds: 1), () => _checkAndGetPreOrderData());
  }

  void _checkAndGetPreOrderData() {
    final fTrade = _setDataOnTrade();
    if (fTrade.orderType == OrderType.limit || fTrade.orderType == OrderType.stopLimit) {
      fTrade.price = makeDouble(priceEditController.text.trim());
    }
    if (fTrade.orderType == OrderType.stopLimit || fTrade.orderType == OrderType.stopMarket) {
      fTrade.stopPrice = makeDouble(stopPriceEditController.text.trim());
    }

    if (fTrade.orderType == OrderType.limit && ((fTrade.price ?? 0) <= 0 || (fTrade.amount ?? 0) <= 0)) {
      ftPreOrderData.value = FTPreOrderData();
      return;
    }

    if (fTrade.orderType == OrderType.market && (fTrade.amount ?? 0) <= 0) {
      ftPreOrderData.value = FTPreOrderData();
      return;
    }

    if (fTrade.orderType == OrderType.stopLimit && ((fTrade.price ?? 0) <= 0 || (fTrade.amount ?? 0) <= 0 || (fTrade.stopPrice ?? 0) <= 0)) {
      ftPreOrderData.value = FTPreOrderData();
      return;
    }

    if (fTrade.orderType == OrderType.stopMarket && ((fTrade.amount ?? 0) <= 0 || (fTrade.stopPrice ?? 0) <= 0)) {
      ftPreOrderData.value = FTPreOrderData();
      return;
    }
    _controller.prePlaceOrderData(fTrade, (data) => ftPreOrderData.value = data ?? FTPreOrderData());
  }

  CreateTrade _setDataOnTrade() {
    final fTrade = CreateTrade();
    fTrade.orderType = (selectedTabIndex.value == 0 ? selectedSubTabIndexOpen.value : selectedSubTabIndexClose.value) + 1;
    fTrade.amount = makeDouble(sizeEditController.text.trim());
    fTrade.tradeType = selectedTabIndex.value == 0 ? FutureTradeType.open : FutureTradeType.close;
    fTrade.marginMode = isIsolate.value ? MarginMode.isolate : MarginMode.cross;
    fTrade.leverageAmount = ListConstants.leverages[selectedLeverageIndex.value];
    fTrade.amountType = selectedSizeCoinIndex.value == 0 ? 2 : 1;
    if (isTpSlOpen.value) {
      final tp = makeDouble(takeProfitEditController.text.trim());
      if (tp > 0) fTrade.takeProfit = tp;
      final sl = makeDouble(stopLossEditController.text.trim());
      if (sl > 0) fTrade.stopLoss = tp;
    }
    return fTrade;
  }

  void _checkInputData(bool? isBuy) {
    final fTrade = _setDataOnTrade();
    if ((fTrade.amount ?? 0) <= 0) {
      showToast("amount_must_greater_than_0".tr);
      return;
    }

    if (fTrade.orderType == OrderType.limit || fTrade.orderType == OrderType.stopLimit) {
      fTrade.price = makeDouble(priceEditController.text.trim());
      if ((fTrade.price ?? 0) <= 0) {
        showToast("price_must_greater_than_0".tr);
        return;
      }
    }

    if (fTrade.orderType == OrderType.stopLimit || fTrade.orderType == OrderType.stopMarket) {
      fTrade.stopPrice = makeDouble(stopPriceEditController.text.trim());
      if ((fTrade.stopPrice ?? 0) <= 0) {
        showToast("stop_price_must_greater_than_0".tr);
        return;
      }
    }
    hideKeyboard(context: context);
    _controller.handlePlaceBuySellOrder(fTrade, isBuy);
  }
}

class MarginModeView extends StatelessWidget {
  const MarginModeView({super.key, required this.isIsolate, required this.coinPair, required this.onChange});

  final bool isIsolate;
  final String coinPair;
  final Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    RxBool isIsolateLocal = isIsolate.obs;
    final fColor = context.theme.focusColor;

    return Obx(() {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        vSpacer10(),
        textAutoSizeKarla("$coinPair ${"Perpetual Margin Mode".tr}", fontSize: Dimens.regularFontSizeMid),
        vSpacer15(),
        Row(children: [
          Expanded(
              flex: 1,
              child: buttonText("Isolated".tr,
                  textColor: context.theme.primaryColor,
                  bgColor: isIsolateLocal.value ? fColor : Colors.transparent,
                  borderColor: fColor, onPressCallback: () {
                isIsolateLocal.value = true;
                onChange(isIsolateLocal.value);
              })),
          Expanded(
              flex: 1,
              child: buttonText("Cross".tr,
                  textColor: context.theme.primaryColor,
                  bgColor: isIsolateLocal.value ? Colors.transparent : fColor,
                  borderColor: fColor, onPressCallback: () {
                isIsolateLocal.value = false;
                onChange(isIsolateLocal.value);
              })),
        ]),
        vSpacer15(),
        textAutoSizePoppins(isIsolateLocal.value ? "Isolated Margin Mode Description".tr : "Cross Margin Mode Description".tr,
            maxLines: 10, textAlign: TextAlign.start),
        vSpacer10(),
      ]);
    });
  }
}

class LeverageSelectionView extends StatelessWidget {
  const LeverageSelectionView({super.key, required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    RxInt selectedIndexLocal = selectedIndex.obs;
    final fColor = context.theme.focusColor;
    return Obx(() {
      return Column(children: [
        vSpacer10(),
        Align(alignment: Alignment.centerLeft, child: textAutoSizeKarla("Leverage".tr, fontSize: Dimens.regularFontSizeMid)),
        vSpacer15(),
        SizedBox(
            width: context.width,
            child: buttonText("${ListConstants.leverages[selectedIndexLocal.value]}x", textColor: context.theme.primaryColor, bgColor: fColor)),
        vSpacer10(),
        Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: Dimens.paddingMin,
            children: List.generate(
                ListConstants.leverages.length,
                (index) => buttonText("${ListConstants.leverages[index]}x",
                        borderColor: fColor, bgColor: Colors.transparent, textColor: context.theme.primaryColor, onPressCallback: () {
                      selectedIndexLocal.value = index;
                      onSelect(selectedIndexLocal.value);
                    }))),
        vSpacer10(),
      ]);
    });
  }
}

class PreOrderDataView extends StatelessWidget {
  const PreOrderDataView({super.key, required this.preData, required this.total, required this.isTrade});

  final FTPreOrderData preData;
  final Total? total;
  final bool isTrade;

  @override
  Widget build(BuildContext context) {
    final baseCoinType = total?.baseWallet?.coinType ?? "";
    final tradeCoinType = total?.tradeWallet?.coinType ?? "";

    return preData.longCost == null && preData.shortCost == null
        ? vSpacer30()
        : Column(children: [
            Row(children: [
              Expanded(child: _textWithSpan("Cost".tr, "${coinFormat(preData.longCost)} $baseCoinType")),
              hSpacer10(),
              Expanded(child: _textWithSpan("Cost".tr, "${coinFormat(preData.shortCost)} $baseCoinType", textAlign: TextAlign.end))
            ]),
            Row(children: [
              Expanded(
                  child: _textWithSpan("Max".tr,
                      "${coinFormat(isTrade ? preData.maxSizeOpenLongTrade : preData.maxSizeOpenLongBase)} ${isTrade ? tradeCoinType : baseCoinType}")),
              hSpacer10(),
              Expanded(
                  child: _textWithSpan("Max".tr,
                      "${coinFormat(isTrade ? preData.maxSizeOpenShortTrade : preData.maxSizeOpenShortBase)} ${isTrade ? tradeCoinType : baseCoinType}",
                      textAlign: TextAlign.end))
            ]),
            vSpacer10()
          ]);
  }

  _textWithSpan(String text, String details, {TextAlign? textAlign}) {
    return AutoSizeText.rich(
      TextSpan(
        text: "$text: ",
        style: Get.theme.textTheme.labelSmall!.copyWith(),
        children: <TextSpan>[
          TextSpan(text: " $details", style: Get.theme.textTheme.labelSmall!.copyWith(color: Get.theme.primaryColor)),
        ],
      ),
      maxLines: 1,
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

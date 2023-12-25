import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import '../../../../data/models/user.dart';
import '../../../../utils/appbar_util.dart';
import '../../auth/sign_in/sign_in_screen.dart';
import 'dashboard_controller.dart';

class BuySellTabViews extends StatefulWidget {
  final String? fromPage;

  const BuySellTabViews({Key? key, this.fromPage}) : super(key: key);

  @override
  BuySellTabViewsState createState() => BuySellTabViewsState();
}

class BuySellTabViewsState extends State<BuySellTabViews> with SingleTickerProviderStateMixin {
  final _controller = Get.find<DashboardController>();
  final priceEditController = TextEditingController();
  final amountEditController = TextEditingController();
  final totalEditController = TextEditingController();
  final limitEditController = TextEditingController();
  TabController? buySellTabController;
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedBuySubTabIndex = 0.obs;
  RxInt selectedSellSubTabIndex = 0.obs;

  @override
  void initState() {
    selectedTabIndex.value = (widget.fromPage == FromKey.buy ? 0 : 1);
    buySellTabController = TabController(vsync: this, length: 2, initialIndex: selectedTabIndex.value);
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
              child: tabBarUnderline(["Buy".tr, "Sell".tr], buySellTabController, onTap: (index) {
                selectedTabIndex.value = index;
                _clearInputViews();
              }),
            ),
            dividerHorizontal(height: 0),
            vSpacer10(),
            Obx(() => _buySellTabView(selectedTabIndex.value))
          ],
        ),
      ),
    );
  }

  Widget _buySellTabView(int tabIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
      child: Obx(() {
        int subIndex = tabIndex == 0 ? selectedBuySubTabIndex.value : selectedSellSubTabIndex.value;
        return Column(
          children: [
            tabBarText(["Limit".tr, "Market".tr, "Stop-limit".tr], subIndex, (index) {
              tabIndex == 0 ? selectedBuySubTabIndex.value = index : selectedSellSubTabIndex.value = index;
              _clearInputViews();
            }, selectedColor: selectedTabIndex.value == 0 ? gBuyColor : gSellColor),
            vSpacer10(),
            _inputViews(subIndex, _controller.selfBalance.value)
          ],
        );
      }),
    );
  }

  Widget _inputViews(int index, SelfBalance? selfBalance) {
    bool isBuy = selectedTabIndex.value == 0;
    final total = selfBalance?.total;
    final baseCType = total?.baseWallet?.coinType ?? "";
    final tradeCType = total?.tradeWallet?.coinType ?? "";
    final balance = isBuy ? "${coinFormat(total?.baseWallet?.balance)} $baseCType" : "${coinFormat(total?.tradeWallet?.balance)} $tradeCType";
    final price = (isBuy ? selfBalance?.sellPrice : selfBalance?.buyPrice) ?? 0;

    return Column(
      children: [
        twoTextSpace('Total'.tr, 'Available'.tr, color: context.theme.primaryColor),
        vSpacer5(),
        twoTextSpaceBackground(balance, balance, bgColor: gIsDarkMode ? null : context.theme.primaryColorLight, height: 30),
        vSpacer10(),
        textFieldWithPrefixSuffixText(
            controller: priceEditController,
            prefixText: index == 2 ? "Stop".tr : "Price".tr,
            text: index == 2 ? "" : price.toString(),
            suffixText: baseCType,
            isEnable: index != 1,
            onTextChange: _onInputAmount),
        vSpacer10(),
        if (index == 2) textFieldWithPrefixSuffixText(controller: limitEditController, prefixText: "Limit".tr, suffixText: baseCType),
        if (index == 2) vSpacer10(),
        textFieldWithPrefixSuffixText(
            controller: amountEditController, prefixText: "Amount".tr, suffixText: tradeCType, onTextChange: _onInputAmount),
        vSpacer10(),
        if (index != 1)
          textFieldWithPrefixSuffixText(controller: totalEditController, prefixText: "Total Amount".tr, suffixText: baseCType, isEnable: false),
        if (index != 1) vSpacer10(),
        _buttonView(gUserRx.value)
      ],
    );
  }

  Widget _buttonView(User user) {
    return user.id == 0
        ? buttonRoundedMain(
            text: "Login".tr, bgColor: Colors.red, width: context.width / 2, onPressCallback: () => Get.offAll(() => const SignInPage()))
        : Column(
            children: [
              Table(
                border: TableBorder.all(color: context.theme.colorScheme.secondary),
                children: [
                  TableRow(
                      children: List.generate(
                          ListConstants.percents.length,
                          (index) => InkWell(
                                onTap: () => _tapOnPercentItem(ListConstants.percents[index]),
                                child: Container(
                                    height: Dimens.btnHeightMin,
                                    alignment: Alignment.center,
                                    child: textAutoSizeKarla("${ListConstants.percents[index]}%", fontSize: Dimens.regularFontSizeMid)),
                              )))
                ],
              ),
              vSpacer10(),
              buttonRoundedMain(
                  text: "Place Order".tr, bgColor: selectedTabIndex.value == 0 ? gBuyColor: gSellColor, onPressCallback: () => _checkInputData())
            ],
          );
  }

  void _onInputAmount(String amountStr) {
    if (selectedBuySubTabIndex.value == 1 || selectedSellSubTabIndex.value == 1) return;
    var price = makeDouble(priceEditController.text.trim());
    if (selectedBuySubTabIndex.value == 2 || selectedSellSubTabIndex.value == 2) {
      price = selectedTabIndex.value == 0
          ? _controller.dashboardData.value.orderData?.sellPrice ?? 0
          : _controller.dashboardData.value.orderData?.buyPrice ?? 0;
    }
    final amount = makeDouble(amountEditController.text.trim());
    totalEditController.text = (amount * price).toString();
  }

  void _tapOnPercentItem(String percentStr) {
    final percent = double.parse(percentStr) / 100;
    final dData = _controller.dashboardData.value;
    final isBuy = selectedTabIndex.value == 0;
    var price = makeDouble(priceEditController.text.trim());

    if (isBuy) {
      if (selectedBuySubTabIndex.value == 2) {
        price = makeDouble(limitEditController.text.trim());
      }
      if (price <= 0) {
        showToast(selectedBuySubTabIndex.value == 2 ? "Please input your limit".tr : "Please input your price".tr);
        return;
      }

      //final amount = (dData.orderData?.total?.baseWallet?.balance ?? 0) / price;
      final amount = (_controller.selfBalance.value.total?.baseWallet?.balance ?? 0) / price;
      final feesPercentage = ((dData.feesSettings?.makerFees ?? 0) > (dData.feesSettings?.takerFees ?? 0)
              ? dData.feesSettings?.makerFees
              : dData.feesSettings?.takerFees) ??
          0;
      final total = amount * percent * price;
      final fees = (total * feesPercentage) / 100;

      amountEditController.text = coinFormat((total - fees) / price);
      if (selectedBuySubTabIndex.value != 1) {
        totalEditController.text = coinFormat(total - fees);
      }
    } else {
      if (selectedSellSubTabIndex.value == 2) {
        price = makeDouble(limitEditController.text.trim());
      }
      if (price <= 0) {
        showToast(selectedSellSubTabIndex.value == 2 ? "Please input your limit".tr : "Please input your price".tr);
        return;
      }
      // final amountPercentage = (dData.orderData?.total?.tradeWallet?.balance ?? 0) * percent;
      final amountPercentage = (_controller.selfBalance.value.total?.tradeWallet?.balance ?? 0) * percent;
      amountEditController.text = coinFormat(amountPercentage);
      if (selectedSellSubTabIndex.value != 1) {
        totalEditController.text = coinFormat(amountPercentage * price);
      }
    }
  }

  void _clearInputViews() {
    amountEditController.text = "";
    totalEditController.text = "";
    limitEditController.text = "";
    //hideKeyboard(context);
  }

  void _checkInputData() {
    final dData = _controller.dashboardData.value;
    final isBuy = selectedTabIndex.value == 0;

    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      showToast("Please input your amount".tr);
      return;
    }

    if (selectedBuySubTabIndex.value == 2 || selectedSellSubTabIndex.value == 2) {
      final stop = makeDouble(priceEditController.text.trim());
      if (stop <= 0) {
        showToast("Please input your stop".tr);
        return;
      }
      final limit = makeDouble(limitEditController.text.trim());
      if (limit <= 0) {
        showToast("Please input your limit".tr);
        return;
      }
      if (stop >= limit) {
        showToast("stop value must be less than limit".tr);
        return;
      }
      hideKeyboard(context: context);
      _controller.placeOrderStopMarket(
          isBuy, dData.orderData?.baseCoinId ?? 0, dData.orderData?.tradeCoinId ?? 0, amount, limit, stop, () => _clearInputViews());
    } else {
      final price = makeDouble(priceEditController.text.trim());
      if (price <= 0) {
        showToast("Please input your price".tr);
        return;
      }
      hideKeyboard(context: context);
      if (selectedBuySubTabIndex.value == 0 || selectedSellSubTabIndex.value == 0) {
        _controller.placeOrderLimit(
            isBuy, dData.orderData?.baseCoinId ?? 0, dData.orderData?.tradeCoinId ?? 0, price, amount, () => _clearInputViews());
      } else if (selectedBuySubTabIndex.value == 1 || selectedSellSubTabIndex.value == 2) {
        _controller.placeOrderMarket(
            isBuy, dData.orderData?.baseCoinId ?? 0, dData.orderData?.tradeCoinId ?? 0, price, amount, () => _clearInputViews());
      }
    }
  }
}

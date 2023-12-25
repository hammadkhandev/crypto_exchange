import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';

import 'swap_controller.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({Key? key, this.preWallet}) : super(key: key);
  final Wallet? preWallet;

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  final _controller = Get.put(SwapController());
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getCoinSwapApp(widget.preWallet);
      _controller.fromEditController.text = 1.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
                child: Column(
                  children: [
                    appBarBackWithActions(title: "Swap".tr),
                    Expanded(child: Obx(() {
                      final fCoin = _controller.selectedFromCoin.value;
                      final tCoin = _controller.selectedToCoin.value;
                      return ListView(
                        padding: const EdgeInsets.all(Dimens.paddingMid),
                        children: [
                          Align(alignment: Alignment.centerLeft, child: textAutoSizeTitle('Swap Coin'.tr)),
                          vSpacer20(),
                          twoTextSpace("From".tr, "${"Available".tr} ${coinFormat(fCoin.availableBalance)} ${fCoin.coinType ?? ""}"),
                          vSpacer5(),
                          textFieldWithWidget(
                              controller: _controller.fromEditController,
                              type: const TextInputType.numberWithOptions(decimal: true),
                              onTextChange: _onTextChanged,
                              suffixWidget: walletsSuffixView(_controller.walletList, fCoin, onChange: (selected) {
                                _controller.selectedFromCoin.value = selected;
                                _controller.getAndSetCoinRate();
                              })),
                          vSpacer10(),
                          buttonOnlyIcon(
                              iconData: Icons.swap_vert_circle_outlined, size: Dimens.iconSizeMid, onPressCallback: () => _swapCoinSelectView()),
                          vSpacer10(),
                          twoTextSpace("To".tr, "${"Available".tr} ${coinFormat(tCoin.availableBalance)} ${tCoin.coinType ?? ""}"),
                          vSpacer5(),
                          textFieldWithWidget(
                              controller: _controller.toEditController,
                              readOnly: true,
                              suffixWidget: walletsSuffixView(_controller.walletList, tCoin, onChange: (selected) {
                                _controller.selectedFromCoin.value = selected;
                                _controller.getAndSetCoinRate();
                              })),
                          _coinRateView(),
                          vSpacer20(),
                          buttonRoundedMain(text: "Convert".tr, onPressCallback: () => _checkInputData())
                        ],
                      );
                    }))
                  ],
                ))),
      ),
    );
  }

  void _swapCoinSelectView() {
    final fromCoin = _controller.selectedFromCoin.value;
    final toCoin = _controller.selectedToCoin.value;
    _controller.selectedToCoin.value = fromCoin;
    _controller.selectedFromCoin.value = toCoin;
    _controller.getAndSetCoinRate();
  }

  Widget _coinRateView() {
    return Obx(() => Column(children: [
          vSpacer10(),
          twoTextSpace("Price".tr,
              "1 ${_controller.selectedFromCoin.value.coinType ?? ""} = ${_controller.rate.value} ${_controller.selectedToCoin.value.coinType ?? ""}"),
          twoTextSpace("You will spend".tr, "${_controller.convertRate.value} ${_controller.selectedToCoin.value.coinType ?? ""}",
              subColor: context.theme.colorScheme.secondary),
          vSpacer10(),
        ]));
  }

  void _onTextChanged(String amount) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _controller.getAndSetCoinRate();
    });
  }

  void _checkInputData() {
    var amount = makeDouble(_controller.fromEditController.text.trim());
    if (amount <= 0) {
      showToast("Invalid amount".tr);
      return;
    }
    final subTitle =
        "${"You will swap".tr} $amount ${_controller.selectedFromCoin.value.coinType ?? ""} ${"To".tr.toLowerCase()} ${_controller.selectedToCoin.value.coinType ?? ""}";
    alertForAction(context,
        title: "Swap Coin".tr,
        subTitle: subTitle,
        buttonTitle: "Convert".tr,
        onOkAction: () => _controller.swapCoinProcess(_controller.selectedFromCoin.value.id, _controller.selectedToCoin.value.id, amount));
  }
}

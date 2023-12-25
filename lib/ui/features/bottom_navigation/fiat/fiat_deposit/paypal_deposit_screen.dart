import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/paypal_util/paypal_payment.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'fiat_deposit_controller.dart';

class PaypalDepositScreen extends StatefulWidget {
  const PaypalDepositScreen({Key? key}) : super(key: key);

  @override
  State<PaypalDepositScreen> createState() => _PaypalDepositScreenState();
}

class _PaypalDepositScreenState extends State<PaypalDepositScreen> {
  final _controller = Get.find<FiatDepositController>();
  TextEditingController amountEditController = TextEditingController();
  TextEditingController coinEditController = TextEditingController();
  Timer? _timer;
  Rx<Wallet> selectedWallet = Wallet(id: 0).obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        vSpacer10(),
        twoTextSpace("Enter amount".tr, "Currency(USD)".tr),
        vSpacer5(),
        textFieldWithWidget(
            controller: amountEditController,
            hint: "Enter amount".tr,
            onTextChange: _onTextChanged,
            type: const TextInputType.numberWithOptions(decimal: true)),
        vSpacer20(),
        twoTextSpace("Converted amount".tr, "Select Wallet".tr),
        vSpacer5(),
        textFieldWithWidget(
            controller: coinEditController,
            hint: "0",
            readOnly: true,
            suffixWidget: Obx(() => walletsSuffixView(_controller.fiatDepositData.value.walletList ?? [], selectedWallet.value, onChange: (selected) {
                  selectedWallet.value = selected;
                  _getAndSetCoinRate();
                }))),
        vSpacer20(),
        buttonRoundedMain(text: "Deposit".tr, onPressCallback: () => _checkInputData())
      ],
    );
  }

  void _onTextChanged(String amount) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      _getAndSetCoinRate();
    });
  }

  void _getAndSetCoinRate() {
    if (selectedWallet.value.id == 0) return;
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      coinEditController.text = "0";
    } else {
      _controller.getCurrencyDepositRate(
          selectedWallet.value.id, amount, currency: "USD", (rate) => coinEditController.text = coinFormat(rate, fixed: 10));
    }
  }

  void _checkInputData() {
    if (selectedWallet.value.id == 0) {
      showToast("select your wallet".tr);
      return;
    }
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      showToast("Amount_less_then".trParams({"amount": "0"}));
      return;
    }
    Get.to(() => PaypalPayment(
        totalAmount: amount,
        onFinish: (token) {
          Future.delayed(const Duration(seconds: 1), () {
            final deposit = CreateDeposit(walletId: selectedWallet.value.id, amount: amount, paypalToken: token, currency: "USD");
            _controller.currencyDepositProcess(deposit, () => _clearView());
          });
        }));
  }

  void _clearView() {
    selectedWallet.value = Wallet(id: 0);
    amountEditController.text = "";
    coinEditController.text = "";
  }
}

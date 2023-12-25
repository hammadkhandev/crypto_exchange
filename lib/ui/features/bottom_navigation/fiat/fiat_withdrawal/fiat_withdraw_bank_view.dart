import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';

import 'fiat_withdrawal_controller.dart';

class FiatWithdrawBankPage extends StatefulWidget {
  const FiatWithdrawBankPage({Key? key, required this.paymentType}) : super(key: key);
  final int? paymentType;

  @override
  FiatWithdrawalPageState createState() => FiatWithdrawalPageState();
}

class FiatWithdrawalPageState extends State<FiatWithdrawBankPage> {
  final _controller = Get.find<FiatWithdrawalController>();
  Rx<Wallet> selectedWallet = Wallet(id: 0).obs;
  Rx<FiatCurrency> selectedCurrency = FiatCurrency(id: 0).obs;
  RxInt selectedBankIndex = 0.obs;
  Timer? _timer;
  Rx<FiatWithdrawalRate> fiatWithdrawalRate = FiatWithdrawalRate().obs;
  final amountEditController = TextEditingController();
  final currencyEditController = TextEditingController();
  final infoEditController = TextEditingController();

  @override
  void initState() {
    selectedBankIndex.value = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        vSpacer10(),
        twoTextSpace("Amount".tr, "Select Wallet".tr, color: context.theme.primaryColor),
        vSpacer5(),
        textFieldWithWidget(
            controller: amountEditController,
            hint: "Enter Amount".tr,
            onTextChange: _onTextChanged,
            type: const TextInputType.numberWithOptions(decimal: true),
            suffixWidget:
                Obx(() => walletsSuffixView(_controller.fiatWithdrawalData.value.myWallet ?? [], selectedWallet.value, onChange: (selected) {
                      selectedWallet.value = selected;
                      _getAndSetCoinRate();
                    }))),
        vSpacer20(),
        twoTextSpace("Convert Price".tr, "Select Currency".tr, color: context.theme.primaryColor),
        vSpacer5(),
        textFieldWithWidget(
          controller: currencyEditController,
          hint: "0",
          readOnly: true,
          suffixWidget: Obx(() {
            final list = _controller.fiatWithdrawalData.value.currency ?? [];
            return currencyView(context, selectedCurrency.value, list, (selected) {
              selectedCurrency.value = selected;
              _getAndSetCoinRate();
            });
          }),
        ),
        vSpacer5(),
        Obx(() {
          final fee = "${"Fees".tr}: ${currencyFormat(fiatWithdrawalRate.value.fees)}";
          final netAmount = "${"Net Amount".tr}: ${currencyFormat(fiatWithdrawalRate.value.netAmount)} ${fiatWithdrawalRate.value.currency ?? ""}";
          return twoTextSpaceFixed(fee, netAmount, color: context.theme.primaryColor);
        }),
        vSpacer20(),
        widget.paymentType == PaymentMethodType.bank
            ? Column(
                children: [
                  twoTextSpace("Select Bank".tr, "", color: context.theme.primaryColor),
                  vSpacer5(),
                  Obx(
                    () => dropDownListIndex(_controller.getBankList(_controller.fiatWithdrawalData.value), selectedBankIndex.value, "Select Bank".tr,
                        (index) {
                      selectedBankIndex.value = index;
                    }, hMargin: 0),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  twoTextSpace("Payment Info".tr, ""),
                  vSpacer5(),
                  textFieldWithSuffixIcon(controller: infoEditController, hint: "Write summary of your payment info".tr, maxLines: 3, height: 80),
                ],
              ),
        vSpacer20(),
        buttonRoundedMain(text: "Submit Withdrawal".tr, onPressCallback: () => _checkInputData())
      ],
    );
  }

  void _onTextChanged(String amount) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () => _getAndSetCoinRate());
  }

  void _getAndSetCoinRate() {
    if (!selectedCurrency.value.code.isValid || !selectedWallet.value.coinType.isValid) return;
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      fiatWithdrawalRate.value = FiatWithdrawalRate();
      currencyEditController.text = "0";
    } else {
      _controller.getAndSetCoinRate(selectedWallet.value.encryptId!, selectedCurrency.value.code!, amount, (rate) {
        fiatWithdrawalRate.value = rate;
        currencyEditController.text = (fiatWithdrawalRate.value.convertAmount ?? 0).toString();
      });
    }
  }

  void _checkInputData() {
    if (!selectedWallet.value.coinType.isValid) {
      showToast("select your wallet".tr);
      return;
    }

    if (!selectedCurrency.value.code.isValid) {
      showToast("select your currency".tr);
      return;
    }

    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      showToast("Amount_less_then".trParams({"amount": "0"}));
      return;
    }
    int? bankId;
    String? payInfo;
    if (widget.paymentType == PaymentMethodType.bank) {
      if (selectedBankIndex.value == -1) {
        showToast("select your bank".tr);
        return;
      }
      final bank = _controller.fiatWithdrawalData.value.myBank![selectedBankIndex.value];
      bankId = bank.id;
    } else {
      payInfo = infoEditController.text.trim();
      if (payInfo.isEmpty) {
        showToast("enter bank info".tr);
        return;
      }
    }

    hideKeyboard(context: context);
    final withdraw = CreateWithdrawal(
        walletId: selectedWallet.value.encryptId, currency: selectedCurrency.value.code, amount: amount, bankId: bankId, paymentInfo: payInfo);
    _controller.fiatWithdrawalProcess(withdraw, () => _clearView());
  }

  void _clearView() {
    selectedCurrency.value = FiatCurrency(id: 0);
    selectedWallet.value = Wallet(id: 0);
    amountEditController.text = "";
    currencyEditController.text = "";
    infoEditController.text = "";
    selectedBankIndex.value = -1;
    fiatWithdrawalRate.value = FiatWithdrawalRate();
  }
}

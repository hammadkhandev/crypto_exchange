import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';

import 'wallet_withdrawal_controller.dart';

class CurrencyWalletWithdrawViews extends StatefulWidget {
  const CurrencyWalletWithdrawViews({Key? key, required this.paymentType}) : super(key: key);
  final int? paymentType;

  @override
  CurrencyWalletWithdrawViewsState createState() => CurrencyWalletWithdrawViewsState();
}

class CurrencyWalletWithdrawViewsState extends State<CurrencyWalletWithdrawViews> {
  final _controller = Get.find<WalletWithdrawalController>();
  RxInt selectedBankIndex = 0.obs;
  final amountEditController = TextEditingController();
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
        twoTextSpace("Amount".tr, "${"Wallet".tr} (${_controller.wallet.coinType ?? ""})", color: context.theme.primaryColor),
        vSpacer5(),
        textFieldWithWidget(controller: amountEditController, hint: "Enter Amount".tr, type: const TextInputType.numberWithOptions(decimal: true)),
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

  void _checkInputData() {
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
    final withdraw = CreateWithdrawal(currency: _controller.wallet.coinType, amount: amount, bankId: bankId, paymentInfo: payInfo);
    _controller.walletCurrencyWithdraw(withdraw, () => _clearView());
  }

  void _clearView() {
    amountEditController.text = "";
    infoEditController.text = "";
    selectedBankIndex.value = -1;
  }
}

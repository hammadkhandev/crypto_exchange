import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/trade_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'wallet_deposit_controller.dart';

class CurrencyWalletBankDepositView extends StatefulWidget {
  const CurrencyWalletBankDepositView({Key? key}) : super(key: key);

  @override
  State<CurrencyWalletBankDepositView> createState() => _CurrencyWalletBankDepositViewState();
}

class _CurrencyWalletBankDepositViewState extends State<CurrencyWalletBankDepositView> {
  final _controller = Get.find<WalletDepositController>();
  TextEditingController amountEditController = TextEditingController();
  RxInt selectedBankIndex = 0.obs;
  Rx<File> selectedFile = File("").obs;

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
        twoTextSpace("Enter amount".tr, _controller.wallet.coinType ?? ""),
        vSpacer5(),
        textFieldWithWidget(
          controller: amountEditController,
          type: const TextInputType.numberWithOptions(decimal: true),
          hint: "Enter amount".tr,
        ),
        vSpacer20(),
        twoTextSpace("Select Bank".tr, ""),
        vSpacer5(),
        Obx(() {
          return dropDownListIndex(_controller.getBankList(_controller.fiatDepositData.value), selectedBankIndex.value, "Select Bank".tr, (index) {
            selectedBankIndex.value = index;
          }, hMargin: 0);
        }),
        Obx(() {
          final bank = selectedBankIndex.value == -1 ? null : _controller.fiatDepositData.value.banks?[selectedBankIndex.value];
          return bank == null ? vSpacer0() : BankDetailsView(bank: bank);
        }),
        vSpacer20(),
        _documentView(),
        vSpacer20(),
        buttonRoundedMain(text: "Deposit".tr, onPressCallback: () => _checkInputData())
      ],
    );
  }

  Widget _documentView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: 150,
            child: buttonText("Select document".tr, onPressCallback: () {
              showImageChooser(context, (chooseFile, isGallery) {
                selectedFile.value = chooseFile;
              }, isCrop: false);
            })),
        Obx(() {
          final text = selectedFile.value.path.isEmpty ? "No document selected".tr : selectedFile.value.name;
          return Expanded(child: textAutoSizePoppins(text, maxLines: 2));
        })
      ],
    );
  }

  void _checkInputData() {
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      showToast("Amount_less_then".trParams({"amount": "0"}));
      return;
    }
    if (selectedBankIndex.value == -1) {
      showToast("select your bank".tr);
      return;
    }
    if (selectedFile.value.path.isEmpty) {
      showToast("select bank document".tr);
      return;
    }

    final bank = _controller.fiatDepositData.value.banks?[selectedBankIndex.value];
    final currency = _controller.wallet.coinType ?? "";
    final deposit = CreateDeposit(walletId: _controller.wallet.id, amount: amount, bankId: bank?.id, file: selectedFile.value, currency: currency);
    _controller.walletCurrencyDeposit(deposit, () => _clearView());
  }

  void _clearView() {
    amountEditController.text = "";
    selectedBankIndex.value = -1;
    selectedFile.value = File("");
  }
}

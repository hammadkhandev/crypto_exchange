import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
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
import 'fiat_deposit_controller.dart';

class BankDepositScreen extends StatefulWidget {
  const BankDepositScreen({Key? key}) : super(key: key);

  @override
  State<BankDepositScreen> createState() => _BankDepositScreenState();
}

class _BankDepositScreenState extends State<BankDepositScreen> {
  final _controller = Get.find<FiatDepositController>();
  TextEditingController amountEditController = TextEditingController();
  TextEditingController coinEditController = TextEditingController();
  Timer? _timer;
  Rx<Wallet> selectedWallet = Wallet(id: 0).obs;
  Rx<FiatCurrency> selectedCurrency = FiatCurrency(id: 0).obs;
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
        twoTextSpace("Enter amount".tr, "Select currency".tr),
        vSpacer5(),
        textFieldWithWidget(
          controller: amountEditController,
          type: const TextInputType.numberWithOptions(decimal: true),
          hint: "Enter amount".tr,
          onTextChange: _onTextChanged,
          suffixWidget: Obx(() {
            return currencyView(context, selectedCurrency.value, _controller.fiatDepositData.value.currencyList ?? [], (selected) {
              selectedCurrency.value = selected;
              _getAndSetCoinRate();
            });
          }),
        ),
        vSpacer20(),
        twoTextSpace("Converted amount".tr, "Select Wallet".tr),
        vSpacer5(),
        textFieldWithWidget(
            controller: coinEditController,
            readOnly: true,
            hint: "0",
            suffixWidget:Obx(() => walletsSuffixView(_controller.fiatDepositData.value.walletList ?? [], selectedWallet.value, onChange: (selected) {
              selectedWallet.value = selected;
              _getAndSetCoinRate();
            }))
        ),
        vSpacer20(),
        twoTextSpace("Select Bank".tr, ""),
        vSpacer5(),
        Obx(() {
          return dropDownListIndex(_controller.getBankList(_controller.fiatDepositData.value), selectedBankIndex.value, "Select Bank".tr, (index) {
            selectedBankIndex.value = index;
            _getAndSetCoinRate();
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

  void _onTextChanged(String amount) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      _getAndSetCoinRate();
    });
  }

  void _getAndSetCoinRate() {
    if (selectedCurrency.value.id == 0 || selectedWallet.value.id == 0) return;
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      coinEditController.text = "0";
    } else {
      final bank = selectedBankIndex.value == -1 ? null : _controller.fiatDepositData.value.banks?[selectedBankIndex.value];
      _controller.getCurrencyDepositRate(
          selectedWallet.value.id,
          amount,
          currency: selectedCurrency.value.code ?? "",
          bankId: bank?.id,
          (rate) => coinEditController.text = coinFormat(rate, fixed: 10));
    }
  }

  void _checkInputData() {
    if (selectedCurrency.value.id == 0) {
      showToast("select your currency".tr);
      return;
    }
    if (selectedWallet.value.id == 0) {
      showToast("select your wallet".tr);
      return;
    }
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
    final deposit = CreateDeposit(
        walletId: selectedWallet.value.id, amount: amount, bankId: bank?.id, file: selectedFile.value, currency: selectedCurrency.value.code ?? "");
    _controller.currencyDepositProcess(deposit, () => _clearView());
  }

  void _clearView() {
    selectedCurrency.value = FiatCurrency(id: 0);
    selectedWallet.value = Wallet(id: 0);
    amountEditController.text = "";
    coinEditController.text = "";
    selectedBankIndex.value = -1;
    selectedFile.value = File("");
  }
}

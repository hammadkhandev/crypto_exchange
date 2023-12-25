import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';

import 'currency_wallet_bank_deposit_view.dart';
import 'currency_wallet_card_deposit_view.dart';
import 'wallet_deposit_controller.dart';
import 'currency_wallet_paypal_deposit_view.dart';

class CurrencyWalletDepositScreen extends StatefulWidget {
  const CurrencyWalletDepositScreen({Key? key, required this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  CurrencyWalletDepositScreenState createState() => CurrencyWalletDepositScreenState();
}

class CurrencyWalletDepositScreenState extends State<CurrencyWalletDepositScreen> with TickerProviderStateMixin {
  final _controller = Get.put(WalletDepositController());

  @override
  void initState() {
    _controller.wallet = widget.wallet;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getFiatDepositData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
              child: Column(children: [
                appBarBackWithActions(title: "Fiat Deposit".tr),
                Obx(() {
                  final methodList = _controller.getMethodList(_controller.fiatDepositData.value);
                  return _controller.isLoading.value
                      ? showLoading()
                      : methodList.isEmpty
                          ? showEmptyView(message: "Payment methods not available".tr, height: Dimens.mainContendGapTop)
                          : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                                      child: textAutoSizePoppins("Select Method".tr, color: context.theme.primaryColor, textAlign: TextAlign.start)),
                                  dropDownListIndex(methodList, _controller.selectedMethodIndex.value, "Select Method".tr,
                                      (value) => _controller.selectedMethodIndex.value = value),
                                  Expanded(
                                    child: ListView(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(Dimens.paddingMid),
                                      children: [
                                        _openPaymentView(_controller.selectedMethodIndex.value),
                                        vSpacer20(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                })
              ])),
        ),
      ),
    );
  }

  Widget _openPaymentView(int selected) {
    final methods = _controller.fiatDepositData.value.paymentMethods?[selected];
    switch (methods?.paymentMethod) {
      case PaymentMethodType.bank:
        return const CurrencyWalletBankDepositView();
      case PaymentMethodType.card:
        return const CurrencyWalletCardDepositView();
      case PaymentMethodType.paypal:
        return const CurrencyWalletPaypalDepositView();
      default:
        return Container();
    }
  }
}

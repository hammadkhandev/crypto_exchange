import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'currency_wallet_withdraw_views.dart';
import 'wallet_withdrawal_controller.dart';

class CurrencyWalletWithdrawalScreen extends StatefulWidget {
  const CurrencyWalletWithdrawalScreen({Key? key, required this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  CurrencyWalletWithdrawalScreenState createState() => CurrencyWalletWithdrawalScreenState();
}

class CurrencyWalletWithdrawalScreenState extends State<CurrencyWalletWithdrawalScreen> {
  final _controller = Get.put(WalletWithdrawalController());

  @override
  void initState() {
    _controller.wallet = widget.wallet;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (gUserRx.value.id > 0) _controller.getFiatWithdrawal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
              child: Column(children: [
                appBarBackWithActions(title: "Fiat Withdraw".tr),
                Obx(() {
                  final methodList = _controller.getMethodList(_controller.fiatWithdrawalData.value);
                  final method = _controller.fiatWithdrawalData.value.paymentMethodList?[_controller.selectedMethodIndex.value];
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
                                        CurrencyWalletWithdrawViews(paymentType: method?.paymentMethod),
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
}

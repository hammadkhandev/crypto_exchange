import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'bank_deposit_screen.dart';
import 'card_deposit_screen.dart';
import 'fiat_deposit_controller.dart';
import 'paypal_deposit_screen.dart';
import 'wallet_deposit_screen.dart';

class FiatDepositScreen extends StatefulWidget {
  const FiatDepositScreen({Key? key}) : super(key: key);

  @override
  FiatDepositScreenState createState() => FiatDepositScreenState();
}

class FiatDepositScreenState extends State<FiatDepositScreen> with TickerProviderStateMixin {
  final _controller = Get.put(FiatDepositController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (gUserRx.value.id > 0) _controller.getFiatDepositData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _controller.isDeposit2FActive = getSettingsLocal()?.currencyDeposit2FaStatus == "1";
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
                            vSpacer10(),
                            if (_controller.isDeposit2FActive && !gUserRx.value.google2FaSecret.isValid)
                              textWithBackground("Google 2FA is not enabled".tr,
                                  bgColor: Colors.red.withOpacity(0.25), textColor: context.theme.primaryColor),
                            vSpacer30(),
                            if (_controller.faqList.isNotEmpty)
                              textAutoSizeTitle("FAQ".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeLarge),
                            if (_controller.faqList.isNotEmpty)
                              Column(children: List.generate(_controller.faqList.length, (index) => faqItem(_controller.faqList[index])))
                          ],
                        ),
                      )
                    ],
                  ),
                );
    });
  }

  Widget _openPaymentView(int selected) {
    final methods = _controller.fiatDepositData.value.paymentMethods?[selected];
    switch (methods?.paymentMethod) {
      case PaymentMethodType.bank:
        return const BankDepositScreen();
      case PaymentMethodType.wallet:
        return const WalletDepositScreen();
      case PaymentMethodType.card:
        return const CardDepositScreen();
      case PaymentMethodType.paypal:
        return const PaypalDepositScreen();
      default:
        return Container();
    }
  }
}

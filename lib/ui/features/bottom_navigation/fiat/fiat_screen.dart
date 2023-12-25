import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'fiat_deposit/fiat_deposit_screen.dart';
import 'fiat_withdrawal/fiat_withdrawal_page.dart';

class FiatScreen extends StatefulWidget {
  const FiatScreen({Key? key}) : super(key: key);

  @override
  FiatScreenState createState() => FiatScreenState();
}

class FiatScreenState extends State<FiatScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  RxInt selectedTabIndex = 0.obs;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return gUserRx.value.id == 0
          ? Column(children: [appBarMain(context, title: "Fiat".tr), signInNeedView()])
          : Column(
              children: [
                appBarMain(context, title: "Fiat".tr),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                  child: tabBarFill(["Fiat To Crypto Deposit".tr, "Crypto To Fiat Withdrawal".tr], _tabController, onTap: (index) => selectedTabIndex.value = index),
                ),
               vSpacer20(),
                selectedTabIndex.value == 0 ? const FiatDepositScreen() : const FiatWithdrawalPage()
              ],
            );
    });
  }
}

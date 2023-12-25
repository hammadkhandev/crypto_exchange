import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';

import 'staking_controller.dart';
import 'staking_earning_screen.dart';
import 'staking_faq_screen.dart';
import 'staking_home_screen.dart';
import 'staking_investment_screen.dart';
import 'staking_statistics_screen.dart';

class StakingScreen extends StatefulWidget {
  const StakingScreen({Key? key}) : super(key: key);

  @override
  StakingScreenState createState() => StakingScreenState();
}

class StakingScreenState extends State<StakingScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  RxInt selectedTabIndex = 0.obs;
  final tabList = ["Home".tr, "Reports".tr, "Investments".tr, "My Earnings".tr];

  @override
  void initState() {
    Get.put(StakingController());
    _tabController = TabController(vsync: this, length: 4);
    super.initState();
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
                appBarBackWithActions(
                    title: "Staking".tr, actionIcons: [AssetConstants.icInfoCircle], onPress: (index) => Get.to(() => const StakingFAQScreen())),
                if (gUserRx.value.id > 0)
                  tabBarUnderline(tabList, _tabController, isScrollable: true, onTap: (index) => selectedTabIndex.value = index),
                dividerHorizontal(height: 0),
                getTabBody()
              ],
            ),
          ),
        ),
      ),
    );
  }

  getTabBody() {
    return Obx(() {
      switch (selectedTabIndex.value) {
        case 0:
          return const StakingHomeScreen();
        case 1:
          return const StakingStatisticsScreen();
        case 2:
          return const StakingInvestmentScreen();
        case 3:
          return const StakingEarningScreen();
        default:
          return Container();
      }
    });
  }
}

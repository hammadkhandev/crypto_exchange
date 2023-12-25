import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/ui/features/auth/sign_in/sign_in_screen.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import '../../../../utils/appbar_util.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/spacers.dart';
import 'dashboard_controller.dart';

class HistoryTabViews extends StatefulWidget {
  final String? fromPage;

  const HistoryTabViews({Key? key, this.fromPage}) : super(key: key);

  @override
  HistoryTabViewsState createState() => HistoryTabViewsState();
}

class HistoryTabViewsState extends State<HistoryTabViews> with SingleTickerProviderStateMixin {
  final _controller = Get.find<DashboardController>();
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedSubTabIndex = 0.obs;
  TabController? orderTabController;

  @override
  void initState() {
    orderTabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  void getData() {
    if (selectedTabIndex.value == 0) {
      _controller.getTradeHistoryList(FromKey.buySell);
    } else if (selectedTabIndex.value == 1) {
      _controller.getTradeHistoryList(selectedSubTabIndex.value == 0 ? FromKey.buy : FromKey.sell);
    } else {
      _controller.getTradeHistoryList(FromKey.trade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      width: context.width,
      decoration: boxDecorationRoundBorder(),
      child: Column(
        children: [
          tabBarUnderline(["Open Orders".tr, "Order History".tr, "Trade History".tr], orderTabController,
              isScrollable: true, fontSize: Dimens.regularFontSizeMid, onTap: (index) {
            selectedTabIndex.value = index;
            getData();
          }),
          dividerHorizontal(height: 0),
          vSpacer10(),
          Obx(() {
            final color = selectedSubTabIndex.value == 0 ? gBuyColor : gSellColor;
            return selectedTabIndex.value == 1
                ? Padding(
                    padding: const EdgeInsets.only(left: Dimens.paddingMid, right: Dimens.paddingMid, bottom: Dimens.paddingMid),
                    child: tabBarText(["Buy".tr, "Sell".tr], selectedSubTabIndex.value, selectedColor: color, (index) {
                      selectedSubTabIndex.value = index;
                      getData();
                    }),
                  )
                : vSpacer0();
          }),
          Obx(() => gUserRx.value.id == 0
              ? Padding(
                  padding: const EdgeInsets.all(Dimens.paddingMid),
                  child: textSpanWithAction("Want to trade".tr, "Login".tr, () => Get.to(() => const SignInPage())),
                )
              : _listView())
        ],
      ),
    );
  }

  Widget _listView() {
    return Obx(() {
      return _controller.tradeHistoryList.isEmpty
          ? handleEmptyViewWithLoading(_controller.isHistoryLoading.value)
          : Column(
              children: List.generate(_controller.tradeHistoryList.length, (index) => _historyItemView(_controller.tradeHistoryList[index])),
            );
    });
  }

  Widget _historyItemView(Trade trade) {
    final color = trade.type == FromKey.buy ? gBuyColor : gSellColor;
    final tradeCoin = _controller.dashboardData.value.orderData?.tradeCoin ?? "";
    final baseCoin = _controller.dashboardData.value.orderData?.baseCoin ?? "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
      child: Column(
        children: [
          if (selectedTabIndex.value != 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 1, child: twoTextView("${"Type".tr}: ", trade.type ?? "", subColor: color)),
                if (selectedTabIndex.value == 0)
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => _controller.cancelOpenOrderApp(trade),
                      child: textAutoSizeKarla("Cancel".tr,
                          color: context.theme.colorScheme.secondary, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.end),
                    ),
                  )
              ],
            ),
          if (selectedTabIndex.value == 2) twoTextView("${"Transaction Id".tr}: ", trade.transactionId ?? ""),
          vSpacer2(),
          if (selectedTabIndex.value == 1) twoTextView("${"Pair".tr}: ", "$tradeCoin/$baseCoin"),
          if (selectedTabIndex.value == 1) vSpacer2(),
          twoTextView("${"Amount".tr}($tradeCoin): ", coinFormat(trade.amount)),
          vSpacer2(),
          twoTextView("${"Fees".tr}($baseCoin): ", coinFormat(trade.fees)),
          vSpacer2(),
          twoTextView("${"Price".tr}($baseCoin): ", coinFormat(trade.price)),
          vSpacer2(),
          if (selectedTabIndex.value != 1) twoTextView("${"Processed".tr}($tradeCoin): ", coinFormat(trade.processed)),
          if (selectedTabIndex.value != 1) vSpacer2(),
          if (selectedTabIndex.value != 2) twoTextView("${"Total".tr}($baseCoin): ", coinFormat(trade.total)),
          if (selectedTabIndex.value != 2) vSpacer2(),
          twoTextView("${"Created At".tr}: ", formatDate(trade.createdAt, format: dateTimeFormatDdMMMMYyyyHhMm)),
          dividerHorizontal()
        ],
      ),
    );
  }
}

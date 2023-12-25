import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/referral.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'activity_controller.dart';
import 'activity_widgets.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  ActivityScreenState createState() => ActivityScreenState();
}

class ActivityScreenState extends State<ActivityScreen> with TickerProviderStateMixin {
  final _controller = Get.put(ActivityScreenController());
  final _scrollController = ScrollController();

  @override
  void initState() {
    if (TemporaryData.activityType != null) {
      final index = _controller.getTypeMap().keys.toList().indexOf(TemporaryData.activityType!);
      if (index != -1) _controller.selectedType.value = index;
      TemporaryData.activityType = null;
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (gUserRx.value.id > 0) {
        _controller.getListData(false);
        _scrollController.addListener(() {
          if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
            if (_controller.hasMoreData) _controller.getListData(true);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => gUserRx.value.id == 0
        ? Column(children: [appBarMain(context, title: "Reports".tr), signInNeedView()])
        : Column(
            children: [
              appBarMain(context, title: "Reports".tr),
              dropDownListIndex(_controller.getTypeMap().values.toList(), _controller.selectedType.value, "All type".tr, (value) {
                _controller.selectedType.value = value;
                _controller.isFiat.value = false;
                _controller.searchController.text = "";
                _controller.getListData(false);
              }),
              if (_controller.getKey() == HistoryType.deposit || _controller.getKey() == HistoryType.withdraw)
                Row(
                  children: [
                    hSpacer10(),
                    buttonTextBordered("Crypto".tr, !_controller.isFiat.value, onPressCallback: () {
                      _controller.isFiat.value = false;
                      _controller.searchController.text = "";
                      _controller.getListData(false);
                    }),
                    hSpacer10(),
                    buttonTextBordered("Fiat".tr, _controller.isFiat.value, onPressCallback: () {
                      _controller.isFiat.value = true;
                      _controller.searchController.text = "";
                      _controller.getListData(false);
                    }),
                    const Spacer(),
                    textFieldSearch(
                        controller: _controller.searchController,
                        width: Get.width / 2,
                        height: Dimens.btnHeightMid,
                        margin: 0,
                        onTextChange: _controller.onTextChanged),
                    hSpacer10(),
                  ],
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                  child: textFieldSearch(
                      controller: _controller.searchController, height: Dimens.btnHeightMid, margin: 0, onTextChange: _controller.onTextChanged),
                ),
              if (_controller.getKey() == HistoryType.deposit || _controller.getKey() == HistoryType.withdraw)
                dividerHorizontal(indent: Dimens.paddingMid, height: Dimens.paddingMid),
              _activityTypeList()
            ],
          ));
  }

  Widget _activityTypeList() {
    return Obx(() {
      final key = _controller.getKey();
      final historyData = getHistoryTypeData(key);
      return _controller.activityDataList.isEmpty
          ? handleEmptyViewWithLoading(_controller.isLoading.value)
          : Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                controller: _scrollController,
                children: List.generate(
                  _controller.activityDataList.length,
                  (index) {
                    final item = _controller.activityDataList[index];
                    if (key == HistoryType.swap && item is SwapHistory) {
                      return SwapHistoryItemView(item, historyData);
                    } else if ((key == HistoryType.buyOrder || key == HistoryType.sellOrder || key == HistoryType.transaction) && item is Trade) {
                      return TradeItemView(item, historyData, key);
                    } else if ((key == HistoryType.fiatDeposit || key == HistoryType.fiatWithdrawal) && item is FiatHistory) {
                      return FiatHistoryItemView(item, historyData);
                    } else if (key == HistoryType.stopLimit && item is Trade) {
                      return StopLimitItemView(item, historyData);
                    } else if ((key == HistoryType.refEarningWithdrawal || key == HistoryType.refEarningTrade) && item is ReferralHistory) {
                      return ReferralItemView(item, historyData, key);
                    } else if (((key == HistoryType.deposit && _controller.isFiat.value) ||
                            (key == HistoryType.withdraw && _controller.isFiat.value)) &&
                        item is WalletCurrencyHistory) {
                      return WalletFiatHistory(history: item, historyData: historyData, type: key);
                    } else if (item is History) {
                      return HistoryItemView(item, historyData, key);
                    } else {
                      return vSpacer0();
                    }
                  },
                ),
              ),
            );
    });
  }
}

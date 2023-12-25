import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/data/models/future_data.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'future_controller.dart';
import 'future_view_widgets.dart';

class FutureScreen extends StatefulWidget {
  const FutureScreen({Key? key}) : super(key: key);

  @override
  FutureScreenState createState() => FutureScreenState();
}

class FutureScreenState extends State<FutureScreen> {
  final _controller = Get.put(FutureController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getFutureExchangeMarketDetail());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.marketData.value = FutureMarketData();
    _controller.coinPairList.clear();
    _controller.unSubscribeChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      appBarMain(context, title: "Future Market".tr),
      Obx(() => _controller.isLoading.value
          ? showLoading()
          : Expanded(
              child: ListView(
                padding: const EdgeInsets.all(Dimens.paddingMid),
                children: [
                  Obx(() {
                    final mData = _controller.marketData.value;
                    return Column(
                      children: [
                        if ((mData.coins?.length ?? 0) > 0) OpenInterestView(coinPair: mData.coins!.first),
                        if (mData.highestVolumePair != null) LongShortRatioView(pair: mData.highestVolumePair!),
                        if (mData.profitLossByCoinPair != null) HighLowPNLView(pair: mData.profitLossByCoinPair!),
                      ],
                    );
                  }),
                  vSpacer20(),
                  Obx(() {
                    final selected = _controller.selectedTabSub.value;
                    return Column(
                      children: [
                        Row(
                          children: [
                            _tabButtonView(
                                "Core Assets".tr, selected == FutureMarketKey.assets, () => _controller.changeSubTab(FutureMarketKey.assets)),
                            _tabButtonView("24H Gainers".tr, selected == FutureMarketKey.hour, () => _controller.changeSubTab(FutureMarketKey.hour)),
                            _tabButtonView("New Listing".tr, selected == FutureMarketKey.new_, () => _controller.changeSubTab(FutureMarketKey.new_)),
                          ],
                        ),
                        if (_controller.isLoadingList) showLoadingSmall(),
                        vSpacer10(),
                        _controller.coinPairList.isValid
                            ? Column(
                                children: List.generate(
                                    _controller.coinPairList.length, (index) => CoinPairItemView(coinPair: _controller.coinPairList[index])),
                              )
                            : showEmptyView(height: Dimens.menuHeight)
                      ],
                    );
                  }),
                  vSpacer20(),
                  textAutoSizeKarla("Market Index".tr, textAlign: TextAlign.start),
                  vSpacer10(),
                  Obx(() {
                    final mDataCoins = _controller.marketData.value.coins;
                    return mDataCoins.isValid
                        ? Wrap(
                            spacing: Dimens.paddingMid,
                            runSpacing: Dimens.paddingMid,
                            children: List.generate(mDataCoins?.length ?? 0, (index) => MarketIndexView(coinPair: mDataCoins![index])))
                        : showEmptyView(height: Dimens.menuHeight);
                  }),
                  vSpacer10(),
                ],
              ),
            ))
    ]);
  }

  _tabButtonView(String text, bool isSelected, VoidCallback onTap) {
    return buttonText(text,
        bgColor: isSelected ? null : Colors.transparent,
        textColor: Get.theme.primaryColor,
        onPressCallback: onTap,
        fontSize: Dimens.regularFontSizeSmall);
  }
}

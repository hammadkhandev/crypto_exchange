import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/market_date.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'market_controller.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  MarketScreenState createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  final _controller = Get.put(MarketController());
  late final TabController _tabController;
  late double textScaleFactor;

  @override
  void initState() {
    _tabController = TabController(length: _controller.getTypeMap().values.length, vsync: this);
    _controller.selectedCurrency.value = -1;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getMarketOverviewCoinStatisticList();
      _controller.getMarketOverviewTopCoinList(false);
      _controller.subscribeSocketChannels();
      /// _controller.getCurrencyList();
    });
  }

  @override
  void dispose() {
    _controller.unSubscribeChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Column(children: [
      appBarMain(context, title: "Markets Overview".tr),
      Expanded(
        child: CustomScrollView(
          slivers: [
            Obx(() {
              final mData = _controller.marketData.value;
              double height = _getTopViewHeight();
              return SliverAppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                expandedHeight: height,
                collapsedHeight: height,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(Dimens.paddingMid),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    textAutoSizePoppins("${"All price information is in".tr} USD", color: context.theme.primaryColor, textAlign: TextAlign.start),
                    vSpacer10(),
                    Wrap(
                      spacing: Dimens.paddingMid,
                      runSpacing: Dimens.paddingMid,
                      children: [
                        if (mData.highlightCoin.isValid) MarketTopItemView(title: "Highlight Coin".tr, list: mData.highlightCoin!),
                        if (mData.newListing.isValid) MarketTopItemView(title: "New Listing".tr, list: mData.newListing!),
                        if (mData.topGainerCoin.isValid) MarketTopItemView(title: "Top Gainer Coin".tr, list: mData.topGainerCoin!),
                        if (mData.topVolumeCoin.isValid) MarketTopItemView(title: "Top Volume Coin".tr, list: mData.topVolumeCoin!),
                      ],
                    )
                  ]),
                ),
              );
            }),
            SliverAppBar(
              backgroundColor: context.theme.scaffoldBackgroundColor,
              automaticallyImplyLeading: false,
              pinned: true,
              elevation: 0,
              toolbarHeight: textScaleFactor > 1 ? 160 : 150,
              flexibleSpace: Column(
                children: [
                  tabBarUnderline(_controller.getTypeMap().values.toList(), _tabController,
                      isScrollable: true, fontSize: Dimens.regularFontSizeMid, onTap: (index) => _controller.changeTab(index)),
                  vSpacer10(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                    child: textFieldSearch(
                        controller: _controller.searchController, height: Dimens.btnHeightMid, margin: 0, onTextChange: _controller.onTextChanged),
                  ),
                  vSpacer10(),
                  Row(children: [
                    hSpacer10(),
                    Expanded(flex: 2, child: textAutoSizePoppins("Market".tr, textAlign: TextAlign.start)),
                    hSpacer5(),
                    Expanded(flex: 2, child: textAutoSizePoppins("${"Price".tr}/\n${"Change (24h)".tr}", maxLines: 2)),
                    hSpacer5(),
                    Expanded(flex: 2, child: textAutoSizePoppins("${"Volume".tr}/\n${"Market Cap".tr}", maxLines: 2, textAlign: TextAlign.end)),
                    hSpacer10(),
                  ]),
                  dividerHorizontal(height: 5),
                ],
              ),
            ),
            Obx(() {
              return _controller.marketCoinList.isEmpty
                  ? SliverFillRemaining(child: handleEmptyViewWithLoading(_controller.isLoading.value))
                  : SliverPadding(
                      padding: const EdgeInsets.all(Dimens.paddingMid),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) => MarketCoinItemViewBottom(coin: _controller.marketCoinList[index]),
                            childCount: _controller.marketCoinList.length),
                      ));
            })
          ],
        ),
      ),
    ]);
  }

  double _getTopViewHeight() {
    double height = 60;
    int count = 0;
    final mData = _controller.marketData.value;
    if (mData.highlightCoin.isValid) count += 1;
    if (mData.newListing.isValid) count += 1;
    if (mData.topGainerCoin.isValid) count += 1;
    if (mData.topVolumeCoin.isValid) count += 1;
    if (count > 2) {
      height = textScaleFactor < 1 ? 325 : textScaleFactor == 1 ? 360 : textScaleFactor < 1.2 ? 390 : 430;
    } else if (count > 0) {
      height = textScaleFactor < 1 ? 180 : textScaleFactor == 1 ? 200 : textScaleFactor < 1.2 ? 220 : 240;
    }
    return height;
  }
}

class MarketTopItemView extends StatelessWidget {
  const MarketTopItemView({super.key, required this.list, required this.title});

  final List<MarketCoin> list;
  final String title;

  @override
  Widget build(BuildContext context) {
    final cWidth = (context.width - 30) / 2;
    return Container(
      width: cWidth,
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textAutoSizeKarla(title, fontSize: Dimens.regularFontSizeMid),
          vSpacer10(),
          Column(children: List.generate(list.length, (index) => MarketCoinItemView(coin: list[index]))),
        ],
      ),
    );
  }
}

class MarketCoinItemView extends StatelessWidget {
  const MarketCoinItemView({super.key, required this.coin});

  final MarketCoin coin;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      showImageNetwork(imagePath: coin.coinIcon, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin),
      hSpacer5(),
      textAutoSizeKarla(coin.coinType ?? "", fontSize: Dimens.regularFontSizeMid),
      hSpacer2(),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            textAutoSizePoppins("${coin.currencySymbol ?? ""}${coinFormat(coin.usdtPrice, fixed: 2)}", color: context.theme.primaryColor),
            textAutoSizePoppins(coinFormat(coin.change, fixed: 2), color: getNumberColor(coin.change)),
          ],
        ),
      )
    ]);
  }
}

class MarketCoinItemViewBottom extends StatelessWidget {
  const MarketCoinItemViewBottom({super.key, required this.coin});

  final MarketCoin coin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMin),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              showImageNetwork(imagePath: coin.coinIcon, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin),
              hSpacer5(),
              Expanded(
                  child: textAutoSizeKarla(coin.coinType ?? "", fontSize: Dimens.regularFontSizeExtraMid, maxLines: 2, textAlign: TextAlign.start)),
            ],
          ),
        ),
        hSpacer5(),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              textAutoSizePoppins(coinFormat(coin.price), color: context.theme.primaryColor),
              textAutoSizePoppins("${coinFormat(coin.change)}%", color: getNumberColor(coin.change)),
            ],
          ),
        ),
        hSpacer5(),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              textAutoSizePoppins(coinFormat(coin.volume), color: context.theme.primaryColor),
              textAutoSizePoppins(coinFormat(coin.totalBalance, fixed: 2), color: context.theme.primaryColor),
            ],
          ),
        )
      ]),
    );
  }
}

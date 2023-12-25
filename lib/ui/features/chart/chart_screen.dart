import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/chart/chart_controller.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/dashboard/dashboard_controller.dart';

class ChartScreen extends StatefulWidget {
  final CoinPair selectedCoinPair;
  final int intervalIndex;

  const ChartScreen({Key? key, required this.selectedCoinPair, required this.intervalIndex}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final _controller = Get.find<ChartController>();

  @override
  void initState() {
    _controller.selectedCoinPair.value = widget.selectedCoinPair;
    _controller.intervalIndex.value = widget.intervalIndex;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getChartDataApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
              child: Column(
                children: [appBarBackWithActions(title: "Chart".tr), Obx(() => Expanded(child: _chartView(_controller.candles)))],
              )),
        ),
      ),
    );
  }

  Widget _chartView(List<Candle> candles) {
    return _controller.noDataFound.value
        ? showEmptyView(message: "Chart data not found".tr, height: Dimens.menuHeight)
        : Card(
            clipBehavior: Clip.hardEdge,
            color: context.theme.colorScheme.background,
            child: Candlesticks(
              candles: candles.length >= 2 ? candles : [],
              style: CandleSticksStyle.light(
                  primaryBear: gSellColor,
                  secondaryBear: gSellColor.withOpacity(0.5),
                  primaryBull: gBuyColor,
                  secondaryBull: gBuyColor.withOpacity(0.5),
                  background: context.theme.colorScheme.background,
                  toolBarColor: context.theme.colorScheme.background,
                  primaryTextColor: context.theme.primaryColor),
              // indicators: indicators,
              // onRemoveIndicator: (String indicator) {
              //   setState(() {
              //     indicators = [...indicators];
              //     indicators.removeWhere((element) => element.name == indicator);
              //   });
              // },
              actions: [
                ToolBarAction(
                  onPressed: () => _chooseIntervalView(context, _controller.getIntervalMap().values.toList(), (index) {
                    _controller.intervalIndex.value = index;
                    _controller.getChartDataApp();
                  }),
                  width: Dimens.toolBarWideMin,
                  child: textAutoSizeKarla(_controller.getIntervalMap().values.toList()[_controller.intervalIndex.value],
                      fontSize: Dimens.regularFontSizeMid),
                ),
                ToolBarAction(
                  onPressed: () => _chooseCoinPairModal(),
                  width: Dimens.toolBarWideMid,
                  child: textAutoSizeKarla(_controller.selectedCoinPair.value.coinPair ?? "", fontSize: Dimens.regularFontSizeMid),
                ),
              ],
            ),
          );
  }

  void _chooseCoinPairModal() {
    final dBoardController = Get.find<DashboardController>();
    dBoardController.getCoinPairList("");
    Get.bottomSheet(
        Container(
            alignment: Alignment.bottomCenter,
            color: context.theme.scaffoldBackgroundColor,
            height: getContentHeight(),
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: Dimens.paddingLargeExtra, bottom: Dimens.paddingMid),
                  child: textAutoSizeKarla("Select Coin Pair".tr, fontSize: Dimens.regularFontSizeLarge),
                ),
                dividerHorizontal(),
                vSpacer10(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: Dimens.paddingMid,
                      runSpacing: Dimens.paddingMid,
                      children: List.generate(dBoardController.coinPairs.length, (index) => _coinPairItemView(dBoardController.coinPairs[index])),
                    ),
                  ),
                ),
                vSpacer20()
              ],
            )),
        isDismissible: true);
  }

  Widget _coinPairItemView(CoinPair coinPair) {
    return InkWell(
      onTap: () {
        Get.back();
        _controller.selectedCoinPair.value = coinPair;
        _controller.getChartDataApp();
      },
      child: Container(
          padding: const EdgeInsets.all(Dimens.paddingMid),
          decoration: boxDecorationRoundCorner(),
          child: textAutoSizeKarla(coinPair.coinPairName ?? "", fontSize: Dimens.regularFontSizeMid, fontWeight: FontWeight.bold)),
    );
  }

  List<Indicator> indicators = [
    BollingerBandsIndicator(length: 20, stdDev: 2, upperColor: gBuyColor, basisColor: Colors.amber, lowerColor: gSellColor),
    WeightedMovingAverageIndicator(length: 100, color: Colors.blue),
  ];
}

class ChartScreenDBoard extends StatefulWidget {
  const ChartScreenDBoard({Key? key}) : super(key: key);

  @override
  State<ChartScreenDBoard> createState() => _ChartScreenDBoardState();
}

class _ChartScreenDBoardState extends State<ChartScreenDBoard> {
  final _controller = Get.find<ChartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _controller.noDataFoundDBoard.value
        ? showEmptyView(message: "Chart data not found".tr, height: Dimens.menuHeight)
        : Container(
            color: context.theme.scaffoldBackgroundColor,
            height: context.width,
            child: Candlesticks(
              candles: _controller.candlesDBoard,
              style: CandleSticksStyle.light(
                  primaryBear: gSellColor,
                  secondaryBear: gSellColor.withOpacity(0.5),
                  primaryBull: gBuyColor,
                  secondaryBull: gBuyColor.withOpacity(0.5),
                  background: context.theme.scaffoldBackgroundColor,
                  toolBarColor: context.theme.scaffoldBackgroundColor,
                  primaryTextColor: context.theme.primaryColor),
              actions: [
                ToolBarAction(
                  onPressed: () => Get.to(() =>
                      ChartScreen(intervalIndex: _controller.intervalIndexDBoard.value, selectedCoinPair: _controller.selectedCoinPairDBoard.value)),
                  width: Dimens.toolBarWideMin,
                  child: const Icon(Icons.fullscreen),
                ),
                ToolBarAction(
                  onPressed: () => _chooseIntervalView(context, _controller.getIntervalMap().values.toList(), (index) {
                    _controller.intervalIndexDBoard.value = index;
                    _controller.getChartDataAppDBoard();
                  }),
                  width: Dimens.toolBarWideMin,
                  child: textAutoSizeKarla(_controller.getIntervalMap().values.toList()[_controller.intervalIndexDBoard.value],
                      fontSize: Dimens.regularFontSizeMid),
                ),
                ToolBarAction(
                  onPressed: () {},
                  width: Dimens.toolBarWideMid,
                  child: textAutoSizeKarla(_controller.selectedCoinPairDBoard.value.coinPair ?? "", fontSize: Dimens.regularFontSizeMid),
                ),
              ],
            ),
          ));
  }
}

void _chooseIntervalView(BuildContext context, List<String> list, Function(int) onTap) {
  showModalSheetFullScreen(
      context,
      Column(
        children: [
          textAutoSizeKarla("Select Interval".tr, fontSize: Dimens.regularFontSizeLarge),
          dividerHorizontal(),
          vSpacer10(),
          Wrap(
            direction: Axis.horizontal,
            spacing: Dimens.paddingMid,
            runSpacing: Dimens.paddingMid,
            children: List.generate(
                list.length,
                (index) => InkWell(
                    onTap: () {
                      Get.back();
                      onTap(index);
                    },
                    child: _intervalItem(list[index]))),
          ),
          vSpacer20()
        ],
      ));
}

Widget _intervalItem(String text) {
  return Container(
    padding: const EdgeInsets.all(Dimens.paddingMid),
    decoration: boxDecorationRoundCorner(),
    child: textAutoSizeKarla(text, fontSize: Dimens.regularFontSizeMid, fontWeight: FontWeight.bold),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/staking.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'staking_controller.dart';

class StakingStatisticsScreen extends StatefulWidget {
  const StakingStatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StakingStatisticsScreen> createState() => _StakingStatisticsScreenState();
}

class _StakingStatisticsScreenState extends State<StakingStatisticsScreen> {
  bool isLoading = true;
  final _controller = Get.find<StakingController>();
  StakingInvestmentStatistics? _stakingStatistics;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getStakingInvestmentStatistics((p0) => setState(() {
            isLoading = false;
            _stakingStatistics = p0;
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? showLoading()
        : Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(Dimens.paddingMid),
              children: [
                StakingStatisticsItemView(statistics: _stakingStatistics?.totalInvestment, title: "Total Investment".tr),
                StakingStatisticsItemView(statistics: _stakingStatistics?.totalRunningInvestment, title: "Running Investment".tr),
                StakingStatisticsItemView(statistics: _stakingStatistics?.totalPaidInvestment, title: "Distributed Investment".tr),
                StakingStatisticsItemView(statistics: _stakingStatistics?.totalUnpaidInvestment, title: "Distributable Investment".tr),
                StakingStatisticsItemView(statistics: _stakingStatistics?.totalCancelInvestment, title: "Cancelled Investment".tr),
              ],
            ),
          );
  }
}

class StakingStatisticsItemView extends StatelessWidget {
  const StakingStatisticsItemView({Key? key, required this.statistics, required this.title}) : super(key: key);
  final List<Statistics>? statistics;
  final String title;

  @override
  Widget build(BuildContext context) {
    final length = statistics?.length ?? 0;
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
      margin: const EdgeInsets.only(bottom: Dimens.paddingLargeExtra),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vSpacer20(),
          textAutoSizeKarla(title, fontSize: Dimens.regularFontSizeLarge),
          vSpacer20(),
          if (length > 0) _rowItemView("Coin Type".tr, "Total Bonus".tr),
          length > 0
              ? Column(
                  children: List.generate(length, (index) {
                    return _rowItemView(statistics?[index].coinType ?? "", coinFormat(statistics?[index].totalInvestment));
                  }),
                )
              : showEmptyView(height: Dimens.menuHeightSettings),
          vSpacer10(),
        ],
      ),
    );
  }

  _rowItemView(String v1, String v2) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: textAutoSizeKarla(v1, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start)),
            Expanded(child: textAutoSizeKarla(v2, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start)),
          ],
        ),
        dividerHorizontal()
      ],
    );
  }
}

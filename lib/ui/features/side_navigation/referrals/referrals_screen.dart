import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/data/models/referral.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'referrals_controller.dart';

class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({Key? key}) : super(key: key);

  @override
  ReferralsScreenState createState() => ReferralsScreenState();
}

class ReferralsScreenState extends State<ReferralsScreen> {
  final _controller = Get.put(ReferralsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getReferralData());
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
            appBarBackWithActions(title: "Referrals".tr),
            Obx(
              () => Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(Dimens.paddingMid),
                  children: [
                    _topShareView(_controller.referralData.value.url),
                    vSpacer20(),
                    _totalView(_controller.referralData.value.totalReward, _controller.referralData.value.countReferrals),
                    vSpacer30(),
                    textAutoSizeTitle("My Referrals".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
                    vSpacer10(),
                    _referralView(_controller.referralData.value.referralLevel),
                    vSpacer30(),
                    textAutoSizeTitle("My References".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
                    vSpacer10(),
                    _referencesView(_controller.referralData.value.referrals),
                    vSpacer30(),
                    textAutoSizeTitle("My Earnings".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
                    vSpacer10(),
                    _earningView(_controller.referralData.value.monthlyEarningHistories),
                    vSpacer10(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )));
  }

  Widget _topShareView(String? referralLink) {
    final link = URLConstants.referralLink + (referralLink ?? "");
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textAutoSizeTitle("Invite Your Fiends".tr, fontSize: Dimens.regularFontSizeMid),
          vSpacer10(),
          textWithCopyButton(link),
          vSpacer10(),
          textAutoSizeTitle("Or".tr, fontSize: Dimens.regularFontSizeMid),
          vSpacer10(),
          buttonRoundedMain(text: "Share Link".tr, onPressCallback: () => shareText(link))
        ],
      ),
    );
  }

  Widget _totalView(int? reward, int? referrals) {
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        coinDetailsItemView("Total Rewards".tr, (reward ?? 0).toString()),
        coinDetailsItemView("Total Invited".tr, (referrals ?? 0).toString()),
      ]),
    );
  }

  Widget _referralView(Map<String, int>? referralLevel) {
    referralLevel = referralLevel ?? {"1": 0, "2": 0, "3": 0};
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: Column(children: [
        _referralLevelItem(referralLevel.keys.toList(), true),
        dividerHorizontal(),
        _referralLevelItem(referralLevel.values.toList(), false),
      ]),
    );
  }

  Widget _referralLevelItem(List<dynamic> dataList, bool isTitle) {
    final color = isTitle ? null : Get.theme.primaryColor;
    final fontW = isTitle ? FontWeight.normal : FontWeight.bold;
    return Row(
      children: [
        Expanded(flex: 1, child: textAutoSizePoppins("${isTitle ? "${"Level".tr} " : ""}${dataList[0]}", color: color, fontWeight: fontW)),
        Expanded(flex: 1, child: textAutoSizePoppins("${isTitle ? "${"Level".tr} " : ""}${dataList[1]}", color: color, fontWeight: fontW)),
        Expanded(flex: 1, child: textAutoSizePoppins("${isTitle ? "${"Level".tr} " : ""}${dataList[2]}", color: color, fontWeight: fontW)),
      ],
    );
  }

  Widget _referencesView(List<Referral>? referrals) {
    referrals = referrals ?? [];
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: referrals.isEmpty
          ? showEmptyView(message: "empty_message_reference_list".tr)
          : Column(children: List.generate(referrals.length, (index) => _referencesItemView(referrals![index]))),
    );
  }

  Widget _referencesItemView(Referral referral) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        vSpacer10(),
        twoTextSpace('Full Name'.tr, referral.fullName ?? ""),
        vSpacer5(),
        twoTextSpaceFixed('Email'.tr, referral.email ?? "", color: context.theme.primaryColorLight),
        vSpacer5(),
        twoTextSpace('Level'.tr, referral.level ?? ""),
        vSpacer5(),
        twoTextSpace('Joining Date'.tr, formatDate(referral.joiningDate, format: dateFormatMMMMDddYyy)),
        dividerHorizontal(),
      ],
    );
  }

  Widget _earningView(List<Earning>? earnings) {
    earnings = earnings ?? [];
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      child: earnings.isEmpty
          ? showEmptyView(message: "empty_message_earning_list".tr)
          : Column(children: List.generate(earnings.length, (index) => _earningItemView(earnings![index]))),
    );
  }

  Widget _earningItemView(Earning earning) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        vSpacer10(),
        twoTextSpace('Coin Type'.tr, earning.coinType ?? ""),
        vSpacer5(),
        twoTextSpace('Amount'.tr, coinFormat(earning.amount)),
        vSpacer5(),
        twoTextSpaceFixed('Level'.tr, (earning.level ?? 0).toString()),
        vSpacer5(),
        twoTextSpace('Transaction Id'.tr, earning.transactionId ?? ""),
        dividerHorizontal(),
      ],
    );
  }
}

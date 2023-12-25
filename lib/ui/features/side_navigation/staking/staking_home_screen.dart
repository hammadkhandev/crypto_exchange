import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/staking.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'staking_controller.dart';
import 'staking_details_screen.dart';

class StakingHomeScreen extends StatefulWidget {
  const StakingHomeScreen({Key? key}) : super(key: key);

  @override
  State<StakingHomeScreen> createState() => _StakingHomeScreenState();
}

class _StakingHomeScreenState extends State<StakingHomeScreen> {
  final isLogin = gUserRx.value.id > 0;
  bool isLoading = true;
  final _controller = Get.find<StakingController>();
  StakingOffersData? stakingData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getStakingOfferList((p0) => setState(() {
            isLoading = false;
            stakingData = p0;
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyList = stakingData?.offerList?.keys.toList() ?? [];
    return keyList.isEmpty
        ? handleEmptyViewWithLoading(isLoading)
        : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(Dimens.paddingMid),
                itemCount: keyList.length,
                itemBuilder: (context, index) {
                  final list = stakingData?.offerList?[keyList[index]] ?? [];
                  return StakingOfferItemView(stakingOffers: list, isLogin: isLogin);
                }),
          );
  }
}

class StakingOfferItemView extends StatelessWidget {
  const StakingOfferItemView({Key? key, required this.stakingOffers, required this.isLogin}) : super(key: key);
  final List<StakingOffer> stakingOffers;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    Rx<StakingOffer> selectedOffer = stakingOffers.first.obs;
    return Container(
      decoration: boxDecorationRoundCorner(),
      padding: const EdgeInsets.all(Dimens.paddingMid),
      margin: const EdgeInsets.only(bottom: Dimens.paddingMid),
      child: Column(
        children: [
          Row(
            children: [
              showImageNetwork(imagePath: selectedOffer.value.coinIcon, width: Dimens.iconSizeMid, height: Dimens.iconSizeMid),
              hSpacer5(),
              textAutoSizeKarla(selectedOffer.value.coinType ?? "", fontSize: Dimens.regularFontSizeMid),
              const Spacer(),
              if (isLogin)
                buttonText("Stake Now".tr, textColor: Get.theme.primaryColor, onPressCallback: () {
                  showBottomSheetFullScreen(context, StakingDetailsScreen(stakingOffer: selectedOffer.value), title: "Staking".tr);
                })
            ],
          ),
          vSpacer10(),
          Obx(() {
            return Column(
              children: [
                twoTextSpace("Minimum Amount".tr, "${coinFormat(selectedOffer.value.minimumInvestment)} ${selectedOffer.value.coinType ?? ""}"),
                vSpacer5(),
                twoTextSpace("Est. APR".tr, "${selectedOffer.value.offerPercentage}%"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textAutoSizeKarla("Duration".tr, fontSize: Dimens.regularFontSizeMid, color: Get.theme.primaryColorLight),
                    Expanded(
                      child: Wrap(
                          alignment: WrapAlignment.end,
                          children: List.generate(stakingOffers.length, (index) {
                            final offer = stakingOffers[index];
                            final isSelected = offer == selectedOffer.value;
                            return buttonText("${offer.minimumMaturityPeriod} ${"Days".tr}",
                                bgColor: Colors.transparent,
                                textColor: Get.theme.primaryColor,
                                borderColor: isSelected ? Get.theme.colorScheme.secondary : null,
                                // borderColor: Get.theme.colorScheme.secondary,
                                visualDensity: minimumVisualDensity,
                                onPressCallback: () => selectedOffer.value = offer);
                          })),
                    )
                  ],
                )
              ],
            );
          })
        ],
      ),
    );
  }
}

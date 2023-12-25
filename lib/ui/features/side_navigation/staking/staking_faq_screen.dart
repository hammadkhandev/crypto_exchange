import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/staking.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'staking_controller.dart';

class StakingFAQScreen extends StatefulWidget {
  const StakingFAQScreen({Key? key}) : super(key: key);

  @override
  State<StakingFAQScreen> createState() => _StakingFAQScreenState();
}

class _StakingFAQScreenState extends State<StakingFAQScreen> {
  final _controller = Get.find<StakingController>();
  bool isLoading = true;
  StakingLandingData? stakingLandingData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getStakingLandingDetails((p0) => setState(() {
            isLoading = false;
            stakingLandingData = p0;
          }));
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
              children: [
                appBarBackWithActions(title: "Staking Info".tr),
                if (isLoading)
                  showLoading()
                else
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Stack(
                          children: [
                            Container(
                                width: Get.width,
                                height: Get.width / 2,
                                color: Colors.grey,
                                child: (stakingLandingData?.stakingLandingCoverImage.isValid ?? false)
                                    ? Image.network(stakingLandingData?.stakingLandingCoverImage ?? "", fit: BoxFit.cover)
                                    : null),
                            Container(
                              padding: const EdgeInsets.all(Dimens.paddingMid),
                              width: Get.width,
                              height: Get.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (stakingLandingData?.stakingLandingTitle.isValid ?? false)
                                    textAutoSizeKarla(stakingLandingData?.stakingLandingTitle ?? "",
                                        fontSize: Dimens.regularFontSizeMid, maxLines: 2, color: Colors.white),
                                  if (stakingLandingData?.stakingLandingDescription.isValid ?? false) vSpacer10(),
                                  if (stakingLandingData?.stakingLandingDescription.isValid ?? false)
                                    textAutoSizePoppins(stakingLandingData?.stakingLandingDescription ?? "", color: Colors.white, maxLines: 7),
                                ],
                              ),
                            )
                          ],
                        ),
                        vSpacer20(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                          child: textAutoSizeKarla("FAQS".tr, fontSize: Dimens.regularFontSizeLarge, textAlign: TextAlign.start),
                        ),
                        Column(
                            children:
                                List.generate(stakingLandingData?.faqList?.length ?? 0, (index) => faqItem(stakingLandingData!.faqList![index])))
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

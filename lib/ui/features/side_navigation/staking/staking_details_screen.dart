import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/staking.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

import 'staking_controller.dart';

class StakingDetailsScreen extends StatefulWidget {
  const StakingDetailsScreen({Key? key, required this.stakingOffer}) : super(key: key);
  final StakingOffer stakingOffer;

  @override
  State<StakingDetailsScreen> createState() => _StakingDetailsScreenState();
}

class _StakingDetailsScreenState extends State<StakingDetailsScreen> {
  final _controller = Get.find<StakingController>();
  final _amountEditController = TextEditingController();
  StakingDetailsData? _stakingDetailsData;
  RxBool isLoading = true.obs;
  RxDouble estimatedInterest = 0.0.obs;
  RxBool autoStaking = false.obs;
  RxBool termsCheck = false.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getOfferDetails(widget.stakingOffer.uid ?? ""));
  }

  void getOfferDetails(String uid) async {
    isLoading.value = true;
    _controller.getStakingOfferDetails(uid, (p0) {
      _stakingDetailsData = p0;
      isLoading.value = false;
    });
  }

  void _onTextChanged(String amount) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () => _getBonus());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final offer = _stakingDetailsData?.offerDetails;
        final typeData = getStakingTermsData(offer?.termsType);
        return isLoading.value
            ? showLoading()
            : ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(Dimens.paddingMid),
                children: [
                  Row(
                    children: [
                      showImageNetwork(imagePath: offer?.coinIcon, width: Dimens.iconSizeMid, height: Dimens.iconSizeMid),
                      hSpacer5(),
                      textAutoSizeKarla(offer?.coinType ?? "", fontSize: Dimens.regularFontSizeMid),
                      const Spacer(),
                      textAutoSizeKarla(typeData.first, color: typeData.last, fontSize: Dimens.regularFontSizeMid),
                    ],
                  ),
                  vSpacer10(),
                  twoTextSpace("Stake Date".tr, formatDate(offer?.stakeDate, format: dateTimeFormatDdMMMMYyyyHhMm)),
                  vSpacer5(),
                  twoTextSpace("Value Date".tr, formatDate(offer?.valueDate, format: dateTimeFormatDdMMMMYyyyHhMm)),
                  vSpacer5(),
                  twoTextSpace("Interest Period".tr, "${offer?.interestPeriod ?? 0} ${"Days".tr}"),
                  vSpacer5(),
                  twoTextSpace("Interest End Date".tr, formatDate(offer?.interestEndDate, format: dateTimeFormatDdMMMMYyyyHhMm)),
                  if (offer?.termsType == StakingTermsType.flexible) vSpacer5(),
                  if (offer?.termsType == StakingTermsType.flexible)
                    twoTextSpace("Minimum Maturity Period".tr, "${offer?.minimumMaturityPeriod ?? 0} ${"Days".tr}"),
                  vSpacer5(),
                  twoTextSpace("Minimum Amount".tr, coinFormat(offer?.minimumInvestment)),
                  vSpacer5(),
                  twoTextSpace("Available Amount".tr, coinFormat((offer?.maximumInvestment ?? 0) - (offer?.totalInvestmentAmount ?? 0))),
                  vSpacer5(),
                  Obx(() => twoTextSpace("Estimated Interest".tr, coinFormat(estimatedInterest.value))),
                  vSpacer10(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textAutoSizeKarla("Duration".tr, fontSize: Dimens.regularFontSizeMid, color: Get.theme.primaryColorLight),
                      Expanded(
                        child: Wrap(
                            alignment: WrapAlignment.end,
                            runSpacing: Dimens.paddingMid,
                            spacing: Dimens.paddingMid,
                            children: List.generate(_stakingDetailsData?.offerList?.length ?? 0, (index) {
                              final cOffer = _stakingDetailsData?.offerList?[index];
                              final isSelected = cOffer?.uid == offer?.uid;
                              return buttonText("${cOffer?.minimumMaturityPeriod} ${"Days".tr}",
                                  bgColor: Colors.transparent,
                                  textColor: Get.theme.primaryColor,
                                  borderColor: isSelected ? Get.theme.colorScheme.secondary : null,
                                  onPressCallback: () => getOfferDetails(cOffer?.uid ?? ""));
                            })),
                      )
                    ],
                  ),
                  vSpacer10(),
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textAutoSizeKarla("Enable Auto Staking".tr, fontSize: Dimens.regularFontSizeLarge),
                          toggleSwitch(selectedValue: autoStaking.value, onChange: (value) => autoStaking.value = value)
                        ],
                      )),
                  textAutoSizePoppins("earn staking rewards automatically".tr, maxLines: 3, textAlign: TextAlign.start),
                  vSpacer10(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textAutoSizeKarla("Est. APR".tr, fontSize: Dimens.regularFontSizeLarge),
                      textAutoSizeKarla("${coinFormat(offer?.offerPercentage)}%", fontSize: Dimens.regularFontSizeMid, color: Colors.green),
                    ],
                  ),
                  vSpacer15(),
                  textAutoSizeKarla("Lock Amount".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeLarge),
                  vSpacer5(),
                  textFieldWithPrefixSuffixText(
                      controller: _amountEditController,
                      suffixText: offer?.coinType ?? "",
                      suffixColor: Get.theme.primaryColor,
                      textAlign: TextAlign.start,
                      onTextChange: _onTextChanged),
                  vSpacer20(),
                  textAutoSizeKarla("Terms and Conditions".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeLarge),
                  vSpacer5(),
                  if ((offer?.userMinimumHoldingAmount ?? 0) > 0)
                    _termsView("staking_holding_amount_terms".trParams({"value": "${offer?.userMinimumHoldingAmount} ${offer?.coinType}"})),
                  if ((offer?.registrationBefore ?? 0) > 0)
                    _termsView("staking_registered_before_terms".trParams({"value": "${offer?.registrationBefore} ${"Days".tr.toLowerCase()}"})),
                  if ((offer?.phoneVerification ?? 0) == 1) _termsView("staking_verified_phone_terms".tr),
                  if ((offer?.kycVerification ?? 0) == 1) _termsView("staking_verified_kyc_terms".tr),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
                    child: HtmlWidget(offer?.termsCondition ?? "", onLoadingBuilder: (context, element, loadingProgress) => showLoadingSmall()),
                  ),
                  vSpacer15(),
                  Obx(() => Row(
                        children: [
                          Checkbox(value: termsCheck.value, onChanged: (v) => termsCheck.value = v ?? false, visualDensity: minimumVisualDensity),
                          textAutoSizePoppins("I agree to the terms and conditions".tr, textAlign: TextAlign.start),
                        ],
                      )),
                  vSpacer10(),
                  buttonRoundedMain(text: "Confirm".tr, onPressCallback: () => _confirmStaking())
                ],
              );
      }),
    );
  }

  _termsView(String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textAutoSizeKarla("\u2022 ", fontSize: Dimens.regularFontSizeMid),
          Expanded(child: textAutoSizeKarla(text, fontSize: Dimens.regularFontSizeMid, maxLines: 2, textAlign: TextAlign.start)),
        ],
      );

  void _getBonus() async {
    final amount = makeDouble(_amountEditController.text.trim());
    if (amount == 0) {
      estimatedInterest.value = amount;
    } else {
      _controller.totalInvestmentBonus(_stakingDetailsData?.offerDetails?.uid ?? "", amount, (p0) => estimatedInterest.value = p0);
    }
  }

  void _confirmStaking() {
    final amount = makeDouble(_amountEditController.text.trim());
    if (amount <= 0) {
      showToast("amount_must_greater_than_0".tr, context: context);
      return;
    }

    if (!termsCheck.value) {
      showToast("Accept the terms and conditions".tr, context: context);
      return;
    }
    hideKeyboard(context: context);
    _controller.investmentSubmit(context, _stakingDetailsData?.offerDetails?.uid ?? "", amount, autoStaking.value);
  }
}

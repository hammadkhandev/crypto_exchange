import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/local/constants.dart';
import '../../../../helper/main_bg_view.dart';
import '../../../../utils/appbar_util.dart';
import '../../../../utils/button_util.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/dimens.dart';
import '../../../../utils/spacers.dart';
import '../../../../utils/text_util.dart';
import 'my_profile_controller.dart';

class PhoneVerifyScreen extends StatefulWidget {
  const PhoneVerifyScreen({Key? key, required this.registrationId}) : super(key: key);
  final String registrationId;

  @override
  State<PhoneVerifyScreen> createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  TextEditingController codeEditController = TextEditingController();
  final _controller = Get.put(MyProfileController());
  Timer? resendTimer;
  RxBool resendActive = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer();
    });
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subTitle = "${'Enter verification code which sent phone'.tr} ${widget.registrationId}";
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: Column(
              children: [
                appBarBackWithActions(title: "Verify Phone".tr),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(Dimens.paddingMid),
                    children: [
                      vSpacer10(),
                      textAutoSizeKarla(subTitle, color: context.theme.primaryColorLight, maxLines: 3, fontSize: Dimens.regularFontSizeMid),
                      vSpacer20(),
                      pinCodeView(controller: codeEditController),
                      vSpacer20(),
                      buttonRoundedMain(text: "Verify".tr, onPressCallback: () => checkInputData()),
                      vSpacer20(),
                      Obx(() => textSpanWithAction('Did not receive code'.tr, "Resend".tr.toUpperCase(), () {
                            if (resendActive.value) {
                              _controller.sendSMS(widget.registrationId, true);
                              startTimer();
                            }
                          }, textAlign: TextAlign.end, subColor: resendActive.value ? null : context.theme.dividerColor))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    resendActive.value = false;
    int second = 0;
    resendTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      second++;
      if (second == 45) {
        resendTimer?.cancel();
        resendActive.value = true;
      }
    });
  }

  void checkInputData() {
    if (codeEditController.text.length < DefaultValue.codeLength) {
      showToast("code_invalid_message".trParams({"count": DefaultValue.codeLength.toString()}));
      return;
    }
    hideKeyboard(context: context);
    _controller.verifyPhone(codeEditController.text);
  }
}

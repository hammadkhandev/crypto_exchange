import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import '../../../../data/local/constants.dart';
import '../../../../data/models/user.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/dimens.dart';
import '../../../../utils/spacers.dart';
import '../../../../utils/text_field_util.dart';
import 'my_profile_controller.dart';

class SendSMSScreen extends StatefulWidget {
  const SendSMSScreen({Key? key}) : super(key: key);

  @override
  State<SendSMSScreen> createState() => _SendSMSScreenState();
}

class _SendSMSScreenState extends State<SendSMSScreen> {
  final _controller = Get.put(MyProfileController());

  User user = gUserRx.value;
  TextEditingController phoneEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(Dimens.paddingMid),
      children: [
        Align(alignment: Alignment.centerLeft, child: textAutoSizePoppins("Verify Phone".tr, fontSize: Dimens.regularFontSizeExtraMid)),
        vSpacer20(),
        textFieldWithSuffixIcon(
            controller: TextEditingController(), hint: "Phone Number".tr, labelText: "Phone Number".tr, text: user.phone ?? "", isEnable: false),
        vSpacer10(),
        vSpacer20(),
        Obx(() => gUserRx.value.phoneVerified == 1
            ? textAutoSizeTitle("Verified".tr, fontSize: Dimens.regularFontSizeLarge, color: Colors.green)
            : buttonRoundedMain(text: "Send SMS".tr, onPressCallback: () => checkInputData())),
        vSpacer20(),
      ],
    ));
  }

  void checkInputData() {
    if (!user.phone.isValid) {
      showToast("Please update your profile with a valid phone number".tr);
      return;
    }
    hideKeyboard(context: context);
    _controller.sendSMS(user.phone!, false);
  }
}

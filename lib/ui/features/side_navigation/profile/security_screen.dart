import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/ui/features/auth/change_password/change_password_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/settings/settings_screen.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'my_profile_controller.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _controller = Get.put(MyProfileController());
  Rx<User> userRx = gUserRx.value.obs;
  final reasonEditController = TextEditingController();
  final passwordEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getUserSetting((user) => userRx.value = user));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          Align(alignment: Alignment.centerLeft, child: textAutoSizePoppins("Profile Security Status".tr, fontSize: Dimens.regularFontSizeExtraMid)),
          vSpacer10(),
          _basicSecurityView(),
          vSpacer20(),
          Align(alignment: Alignment.centerLeft, child: textAutoSizePoppins("Advanced Security".tr, fontSize: Dimens.regularFontSizeExtraMid)),
          vSpacer10(),
          _advanceSecurityView()
        ],
      ),
    );
  }

  Widget _basicSecurityView() {
    return Obx(() {
      final user = userRx.value;
      return Column(
        children: [
          _securityItemView(
              imagePath: AssetConstants.icFingerprintScan,
              title: "Google Authenticator (Recommended)".tr,
              subTitle: "Protect your account and transactions".tr,
              btnText: user.google2FaSecret.isValid ? "Remove".tr : "Enable".tr,
              btnColor: user.google2FaSecret.isValid ? Colors.red : Colors.green,
              onTap: () => Get.to(() => const SettingsScreen())),
          _securityItemView(
              imagePath: AssetConstants.icSmartphone,
              title: "Phone Number Verification".tr,
              subTitle: "Protect your account and transactions".tr,
              btnText: user.phoneVerified == 1 ? "Verified".tr : "Verify".tr,
              btnColor: user.phoneVerified == 1 ? Colors.green : null,
              onTap: () => sendSms()),
          _securityItemView(
              imagePath: AssetConstants.icEmail,
              title: "Email Address Verification".tr,
              subTitle: "Protect your account and transactions".tr,
              btnText: user.isVerified == 1 ? "Verified".tr : "Verify".tr,
              btnColor: user.isVerified == 1 ? Colors.green : null),
        ],
      );
    });
  }

  Widget _advanceSecurityView() {
    return Column(
      children: [
        _securityItemView(
            imagePath: AssetConstants.icKey,
            title: "Login Password".tr,
            subTitle: "Login password is used to log in to your account".tr,
            btnText: "Change".tr,
            btnColor: Colors.green,
            onTap: () => Get.to(() => const ChangePasswordScreen())),
        _securityItemView(
            imagePath: AssetConstants.icDelete,
            title: "Delete Account".tr,
            subTitle: "Admin will verify your request".tr,
            btnText: "Delete".tr,
            btnColor: Colors.red,
            onTap: () => showBottomSheetFullScreen(context, _showDeleteAccountView(), title: "Delete Account".tr, onClose: () {
                  reasonEditController.text = "";
                  passwordEditController.text = "";
                })),
      ],
    );
  }

  Widget _securityItemView({String? imagePath, String? title, String? subTitle, String? btnText, Color? btnColor, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: showImageAsset(imagePath: imagePath, width: Dimens.iconSizeLarge, height: Dimens.iconSizeLarge),
      title:
          textAutoSizePoppins(title ?? "", fontSize: Dimens.regularFontSizeMid, fontWeight: FontWeight.bold, maxLines: 2, textAlign: TextAlign.start),
      subtitle: textAutoSizePoppins(subTitle ?? "", maxLines: 3, textAlign: TextAlign.start),
      trailing: buttonText(btnText ?? "", bgColor: btnColor),
      contentPadding: EdgeInsets.zero,
    );
  }

  void sendSms() {
    if (!userRx.value.phone.isValid) {
      showToast("Please update your profile with a valid phone number".tr);
      return;
    }
    _controller.sendSMS(userRx.value.phone!, false);
  }

  _showDeleteAccountView() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          showImageAsset(imagePath: AssetConstants.icDelete, width: Dimens.iconSizeLogo, height: Dimens.iconSizeLogo),
          vSpacer20(),
          textAutoSizePoppins("Do you want to delete your account".tr,
              maxLines: 5, color: Get.theme.primaryColor, fontSize: Dimens.regularFontSizeMid),
          vSpacer20(),
          textAutoSizeTitle("The Reason For Delete".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
          vSpacer2(),
          textFieldWithSuffixIcon(controller: reasonEditController, hint: "Write Your Reason".tr, maxLines: 5, height: 100),
          textAutoSizePoppins("(${"Write your reason with as details as possible".tr})", maxLines: 2, color: Colors.redAccent),
          vSpacer10(),
          textAutoSizeTitle("Current Password".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
          vSpacer2(),
          textFieldWithSuffixIcon(controller: passwordEditController, hint: "Write Your Password".tr, isObscure: true),
          vSpacer20(),
          buttonRoundedMain(text: "Delete".tr, bgColor: Colors.redAccent, onPressCallback: () => _confirmDeleteAccount()),
          vSpacer20(),
        ],
      ),
    );
  }

  _confirmDeleteAccount() {
    final reason = reasonEditController.text.trim();
    if (reason.isEmpty) {
      showToast("Reason can not be empty".tr, isError: true);
      return;
    }

    if (passwordEditController.text.length < DefaultValue.kPasswordLength) {
      showToast("Password_invalid_length".trParams({"count": DefaultValue.kPasswordLength.toString()}), isError: true);
      return;
    }
    hideKeyboard(context: context);
    alertForAction(context,
        title: "Are you sure".tr,
        subTitle: "You want to delete your account".trParams({"text": reason}),
        buttonTitle: "Confirm Delete".tr,
        buttonColor: Colors.redAccent,
        onOkAction: () => _controller.deleteAccountRequest(reason, passwordEditController.text, () {
              reasonEditController.text = "";
              passwordEditController.text = "";
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import '../../../../helper/auth_bg_view.dart';
import '../../../../utils/spacers.dart';
import '../sign_up/sign_up_screen.dart';
import 'reset_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String registrationId;

  const ResetPasswordScreen({Key? key, required this.registrationId}) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BGViewAuth(
        isAuth: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLargeDouble),
            child: Column(
              children: [
                vSpacer15(),
                showImageAsset(
                    imagePath: AssetConstants.icLogo, height: Dimens.iconSizeLogo, width: Dimens.iconSizeLogo, color: context.theme.primaryColor),
                vSpacer15(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimens.paddingLarge, bottom: Dimens.paddingMin),
                    child: ListView(
                      children: [
                        viewTitleWithSubTitleText(
                            title: 'Recovery or reset Password'.tr, subTitle: "${'reset_password_message'.tr} ${widget.registrationId}", maxLines: 2),
                        textFieldWithSuffixIcon(
                            controller: _controller.codeEditController,
                            labelText: "Reset Code".tr,
                            hint: "Reset Code".tr,
                            type: TextInputType.emailAddress),
                        vSpacer15(),
                        Obx(() {
                          return textFieldWithSuffixIcon(
                              controller: _controller.passEditController,
                              labelText: "New Password".tr,
                              hint: "New Password".tr,
                              type: TextInputType.visiblePassword,
                              iconPath: _controller.isShowPassword.value ? AssetConstants.icPasswordShow : AssetConstants.icPasswordHide,
                              isObscure: !_controller.isShowPassword.value,
                              iconAction: () => _controller.isShowPassword.value = !_controller.isShowPassword.value);
                        }),
                        vSpacer15(),
                        Obx(() {
                          return textFieldWithSuffixIcon(
                              controller: _controller.confirmPassEditController,
                              labelText: "Confirm New Password".tr,
                              hint: "Confirm New Password".tr,
                              type: TextInputType.visiblePassword,
                              iconPath: _controller.isShowPassword.value ? AssetConstants.icPasswordShow : AssetConstants.icPasswordHide,
                              isObscure: !_controller.isShowPassword.value,
                              iconAction: () => _controller.isShowPassword.value = !_controller.isShowPassword.value);
                        }),
                        vSpacer20(),
                        buttonRoundedMain(
                            text: "Reset password".tr, onPressCallback: () => _controller.isInPutDataValid(context, widget.registrationId)),
                        vSpacer20(),
                        textSpanWithAction('Do not have account'.tr, "Sign Up".tr, () => Get.off(() => const SignUpScreen())),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

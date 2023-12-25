import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import '../../../../utils/appbar_util.dart';
import '../../../../utils/spacers.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: Column(
              children: [
                appBarBackWithActions(title: "Change password".tr, fontSize: Dimens.regularFontSizeLarge),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(Dimens.paddingMid),
                    children: [
                      textAutoSizeKarla("Input your old and new password".tr,
                          color: Get.theme.primaryColorLight, maxLines: 2, fontSize: Dimens.regularFontSizeMid),
                      vSpacer20(),
                      textFieldWithSuffixIcon(
                          controller: _controller.currentPassEditController,
                          labelText: "Current Password".tr,
                          hint: "Current Password".tr,
                          type: TextInputType.visiblePassword,
                          isObscure: true),
                      vSpacer15(),
                      Obx(() {
                        return textFieldWithSuffixIcon(
                            controller: _controller.newPassEditController,
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
                      buttonRoundedMain(text: "Change".tr, onPressCallback: () => _controller.isInPutDataValid(context)),
                      vSpacer20(),
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
}

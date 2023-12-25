import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/ui/features/auth/sign_in/sign_in_screen.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import '../../../../helper/auth_bg_view.dart';
import 'sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _controller = Get.put(SignUpController());

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
                logoWithSkipView(),
                vSpacer15(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimens.paddingLarge, bottom: Dimens.paddingMin),
                    child: ListView(
                      children: [
                        viewTitleWithSubTitleText(title: 'Sign up'.tr, subTitle: 'Create your own account'.tr, maxLines: 2),
                        textFieldWithSuffixIcon(
                            controller: _controller.firstNameEditController,
                            labelText: "First Name".tr,
                            hint: "First Name".tr,
                            type: TextInputType.name),
                        vSpacer15(),
                        textFieldWithSuffixIcon(
                            controller: _controller.lastNameEditController,
                            labelText: "Last Name".tr,
                            hint: "Last Name".tr,
                            type: TextInputType.name),
                        vSpacer15(),
                        textFieldWithSuffixIcon(
                            controller: _controller.emailEditController, labelText: "Email".tr, hint: "Email".tr, type: TextInputType.emailAddress),
                        vSpacer15(),
                        // // for phone number
                        // textFieldWithSuffixIcon(countryPick: getCountry(context, initialValue: selectedCountry,
                        //     onChanged: (value) => selectedCountry = value),
                        //     controller: _controller.phoneEditController, hint: "Your phone".tr, type: TextInputType.datetime),
                        vSpacer15(),
                        Obx(() {
                          return textFieldWithSuffixIcon(
                              controller: _controller.passEditController,
                              labelText: "Password".tr,
                              hint: "Password".tr,
                              type: TextInputType.visiblePassword,
                              iconPath: _controller.isShowPassword.value ? AssetConstants.icPasswordShow : AssetConstants.icPasswordHide,
                              isObscure: !_controller.isShowPassword.value,
                              iconAction: () => _controller.isShowPassword.value = !_controller.isShowPassword.value);
                        }),
                        vSpacer15(),
                        Obx(() {
                          return textFieldWithSuffixIcon(
                              controller: _controller.confirmPassEditController,
                              labelText: "Confirm Password".tr,
                              hint: "Confirm Password".tr,
                              type: TextInputType.visiblePassword,
                              iconPath: _controller.isShowPassword.value ? AssetConstants.icPasswordShow : AssetConstants.icPasswordHide,
                              isObscure: !_controller.isShowPassword.value,
                              iconAction: () => _controller.isShowPassword.value = !_controller.isShowPassword.value);
                        }),
                        vSpacer20(),
                        buttonRoundedMain(text: "Sign Up".tr, onPressCallback: () => _controller.isInPutDataValid(context)),
                        vSpacer20(),
                        textSpanWithAction('Already Have An account'.tr, "Sign In".tr, () => Get.off(() => const SignInPage())),
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

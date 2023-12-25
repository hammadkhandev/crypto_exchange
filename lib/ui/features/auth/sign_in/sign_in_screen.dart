import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/helper/auth_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/auth/forgot_password/forgot_password_page.dart';
import 'package:tradexpro_flutter/ui/features/auth/sign_up/sign_up_screen.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'sign_in_controller.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _controller = Get.put(SignInController());

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
                          viewTitleWithSubTitleText(title: 'Sign In'.tr, subTitle: 'SignIn_description'.tr, maxLines: 2),
                          textFieldWithSuffixIcon(
                              labelText: 'Email'.tr, controller: _controller.emailEditController, hint: "Email".tr, type: TextInputType.emailAddress),
                          vSpacer15(),
                          Obx(() {
                            return textFieldWithSuffixIcon(
                                labelText: 'Password'.tr,
                                controller: _controller.passEditController,
                                hint: "Password".tr,
                                type: TextInputType.visiblePassword,
                                iconPath: _controller.isShowPassword.value ? AssetConstants.icPasswordShow : AssetConstants.icPasswordHide,
                                isObscure: !_controller.isShowPassword.value,
                                iconAction: () {
                                  _controller.isShowPassword.value = !_controller.isShowPassword.value;
                                });
                          }),
                          vSpacer20(),
                          InkWell(
                            onTap: () => Get.off(() => const ForgotPasswordPage()),
                            child: textAutoSizePoppins('Forgot Password'.tr, textAlign: TextAlign.end, decoration: TextDecoration.underline),
                          ),
                          vSpacer20(),
                          buttonRoundedMain(text: "Sign In".tr, onPressCallback: () => _controller.isInPutDataValid(context)),
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
        ));
  }
}

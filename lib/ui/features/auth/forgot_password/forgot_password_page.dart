import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/auth_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/auth/sign_up/sign_up_screen.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import '../../../../utils/spacers.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _controller = Get.put(ForgotPasswordController());

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
                showImageAsset(imagePath: AssetConstants.icLogo, height: Dimens.iconSizeLogo, width: Dimens.iconSizeLogo, color: context.theme.primaryColor),
                vSpacer15(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimens.paddingLarge, bottom: Dimens.paddingMin),
                    child: ListView(
                      children: [
                        viewTitleWithSubTitleText(
                            title: 'Forget Password'.tr, subTitle: 'Please enter the email address to request a password reset.'.tr, maxLines: 2),
                        textFieldWithSuffixIcon(
                            labelText: 'Email'.tr, controller: _controller.emailEditController, hint: "Email".tr, type: TextInputType.emailAddress),
                        vSpacer20(),
                        buttonRoundedMain(text: "Send".tr, onPressCallback: () => _controller.isInPutDataValid(context)),
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

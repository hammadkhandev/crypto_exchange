import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/auth_bg_view.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/text_util.dart';
import '../sign_in/sign_in_screen.dart';
import 'email_verify_controller.dart';

class EmailVerifyPage extends StatefulWidget {
  final String registrationId;

  const EmailVerifyPage({Key? key, required this.registrationId}) : super(key: key);

  @override
  EmailVerifyPageState createState() => EmailVerifyPageState();
}

class EmailVerifyPageState extends State<EmailVerifyPage> {
  final _controller = Get.put(EmailVerifyController());

  @override
  Widget build(BuildContext context) {
    final subTitle = "${'Enter verification code which sent email'.tr} ${widget.registrationId}";
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
                        viewTitleWithSubTitleText(title: 'Code verification'.tr, subTitle: subTitle, maxLines: 3),
                        vSpacer20(),
                        pinCodeView(controller: _controller.codeEditController),
                        vSpacer20(),
                        buttonRoundedMain(text: "Verify".tr, onPressCallback: () => _controller.isInPutDataValid(context, widget.registrationId)),
                        vSpacer20(),
                        textSpanWithAction('Back to'.tr, "Sign In".tr, () => Get.off(() => const SignInPage())),
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

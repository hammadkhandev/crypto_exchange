import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/helper/auth_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/auth/sign_in/sign_in_screen.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import '../../../data/local/constants.dart';
import '../../../utils/button_util.dart';
import '../../../utils/dimens.dart';
import '../../../utils/spacers.dart';
import '../../../helper/app_widgets.dart';

class SignUpSuccessPage extends StatefulWidget {
  const SignUpSuccessPage({Key? key}) : super(key: key);

  @override
  SignUpSuccessPageState createState() => SignUpSuccessPageState();
}

class SignUpSuccessPageState extends State<SignUpSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
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
                        vSpacer30(),
                        showImageAsset(
                            imagePath: AssetConstants.icTickLarge,
                            height: Get.width / 3.2,
                            width: Get.width / 3.2,
                            color: Get.theme.colorScheme.secondary),
                        viewTitleWithSubTitleText(title: 'Successful'.tr, subTitle: 'Your account verified successfully'.tr),
                        buttonRoundedMain(text: "Sign in now".tr, onPressCallback: () => Get.off(() => const SignInPage())),
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

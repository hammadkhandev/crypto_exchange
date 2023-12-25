import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final size = Get.width / 2;
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: GetBuilder<SplashController>(
          init: SplashController(),
          builder: (splashController) {
            return Container(
              padding: const EdgeInsets.all(0),
              decoration: decorationBackgroundGradient(),
              width: Get.width,
              height: Get.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(alignment: Alignment.topRight, child: showImageAsset(imagePath: AssetConstants.icTopBgMark, height: size, width: size)),
                  Column(
                    children: [
                      showImageAsset(imagePath: AssetConstants.icLogo, height: size / 1.2, width: size / 1.2, color: Get.theme.primaryColor),
                      Padding(
                        padding: const EdgeInsets.all(Dimens.paddingLargeDouble),
                        child: textAutoSizeTitle('splashLogoSubText'.tr, color: Get.theme.primaryColor),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: showImageAsset(imagePath: gIsDarkMode ? AssetConstants.icBottomBgMarkDark : AssetConstants.icBottomBgMark, height: size, width: size),
                  )
                ],
              ),
            );
          }),
    );
  }
}

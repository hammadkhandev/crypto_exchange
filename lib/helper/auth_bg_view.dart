import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/utils/colors.dart';
import '../data/local/constants.dart';
import '../utils/dimens.dart';
import '../utils/image_util.dart';

class BGViewAuth extends StatelessWidget {
  final Widget child;
  final bool isAuth;

  const BGViewAuth({Key? key, required this.child, required this.isAuth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.width / 2;
    return Container(
      width: context.width,
      height: context.height,
      color: context.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  showImageAsset(imagePath: AssetConstants.icEllipseBg, width: context.width, color: gIsDarkMode ? cSunGlowDark : cSunGlow),
                  Positioned(
                      right: 0,
                      child: showImageAsset(imagePath: AssetConstants.icTopBgMark, height: size, width: size, color: Colors.white.withOpacity(0.5))),
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: showImageAsset(imagePath: AssetConstants.icBottomBgAuth, height: size, width: size),
              // )
            ],
          ),
          if (isAuth)
            Positioned(
                top: 140,
                bottom: 30,
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLarge),
                  child: showImageAsset(
                      imagePath: gIsDarkMode ? AssetConstants.bgAuthMiddleDark : AssetConstants.bgAuthMiddle,
                      height: Get.height,
                      width: Get.width,
                      boxFit: BoxFit.fill),
                )),
          child
        ],
      ),
    );
  }
}

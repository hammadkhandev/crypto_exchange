import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/colors.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';

class BGViewMain extends StatelessWidget {
  final Widget child;

  const BGViewMain({Key? key, required this.child}) : super(key: key);

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
          Positioned(
              top: context.mediaQueryPadding.top + 10,
              bottom: 0,
              width: Get.width,
              child: showImageAsset(
                  color: context.theme.scaffoldBackgroundColor,
                  imagePath: gIsDarkMode ? AssetConstants.bgAuthMiddleDark : AssetConstants.bgAuthMiddle,
                  height: Get.height,
                  width: Get.width,
                  boxFit: BoxFit.fill)),
          child
        ],
      ),
    );
  }
}

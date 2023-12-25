import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'button_util.dart';
import 'common_utils.dart';

const pathTempProfileImageName = "_profileImage_id_verify.jpeg";
const pathTempFrontImageName = "_frontImage_id_verify.jpeg";
const pathTempBackImageName = "_backImage_id_verify.jpeg";

Widget showCircleAvatar(String? url, {double size = 90}) {
  return ClipOval(
    child: CachedNetworkImage(
      imageUrl: url ?? "",
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: (context, url) => SvgPicture.asset(AssetConstants.icLogo, colorFilter: _getColorFilter(Get.theme.primaryColor)),
      errorWidget: (context, url, error) => SvgPicture.asset(AssetConstants.icLogo, colorFilter: _getColorFilter(Get.theme.primaryColor)),
    ),
  );
}

_getColorFilter(Color? color) => color == null ? null : ColorFilter.mode(color, BlendMode.srcIn);

Widget showCachedNetworkImage(String url, {double size = 90}) {
  return CachedNetworkImage(
    imageUrl: url,
    width: size,
    height: size,
    fit: BoxFit.cover,
    placeholder: (context, url) => SvgPicture.asset(AssetConstants.icLogo),
    errorWidget: (context, url, error) {
      return SvgPicture.asset(AssetConstants.icLogo, height: size / 2, width: size / 2);
    },
  );
}

Widget showImageAsset(
    {IconData? icon,
    String? imagePath = "",
    double? width,
    double? height,
    VoidCallback? onPressCallback,
    Color? color,
    BoxFit? boxFit = BoxFit.contain,
    double? iconSize}) {
  return InkWell(
    onTap: onPressCallback,
    child: imagePath!.isNotEmpty
        ? imagePath.contains(".svg")
            ? SvgPicture.asset(imagePath, fit: boxFit!, width: width, height: height, colorFilter: _getColorFilter(color))
            : Image.asset(imagePath, fit: boxFit!, width: width, height: height, color: color)
        : Icon(icon!, size: iconSize, color: color),
  );
}

Widget showImageNetwork({
  String? imagePath,
  double? width,
  double? height,
  VoidCallback? onPressCallback,
  Color? iconColor,
  BoxFit boxFit = BoxFit.contain,
  Color? bgColor,
  double? iconSize,
  double? padding,
}) {
  return InkWell(
      onTap: onPressCallback,
      child: Container(
        height: height,
        width: width,
        color: bgColor ?? Colors.grey.withOpacity(0.25),
        padding: EdgeInsets.all(padding ?? 0),
        child: imagePath.isValid
            ? imagePath!.contains(".svg")
                ? SvgPicture.network(imagePath, fit: boxFit, colorFilter: _getColorFilter(iconColor))
                : Image.network(imagePath, fit: boxFit)
            : SvgPicture.asset(AssetConstants.icLogo),
      ));
}

Widget showImageLocal(File file, {double size = 90}) {
  return Container(
    padding: const EdgeInsets.all(5),
    child: Image.file(file, width: size, height: size, fit: BoxFit.cover),
  );
}

Widget showCircleAvatarLocal(File file, {double size = 90}) {
  return ClipOval(
      child: Image.file(
    file,
    width: size,
    height: size,
    fit: BoxFit.cover,
  ));
}

void showImageChooser(BuildContext context, Function(File, bool) onChoose, {bool isCamera = true, bool isGallery = true, bool isCrop = true}) {
  hideKeyboard(context: context);
  choosePhotoModalBottomSheet(
      onTakePic: isCamera
          ? () {
              Get.back();
              getImage(false, onChoose, isCrop);
            }
          : null,
      onChoosePic: isGallery
          ? () {
              Get.back();
              getImage(true, onChoose, isCrop);
            }
          : null,
      width: Get.width * 0.85);
}

choosePhotoModalBottomSheet({VoidCallback? onTakePic, VoidCallback? onChoosePic, double width = 0}) => Get.bottomSheet(
      Container(
          alignment: Alignment.bottomCenter,
          //height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onTakePic != null)
                buttonRoundedMain(
                    text: "Take a picture".tr, onPressCallback: onTakePic, width: width, textColor: Colors.black, bgColor: Colors.white),
              if (onTakePic != null) dividerHorizontal(height: 10, indent: Get.width - width),
              if (onChoosePic != null)
                buttonRoundedMain(
                    text: "Choose a picture".tr, onPressCallback: onChoosePic, width: width, textColor: Colors.black, bgColor: Colors.white),
              if (onChoosePic != null) dividerHorizontal(height: 10, indent: Get.width - width),
              buttonRoundedMain(text: "Cancel".tr, onPressCallback: () => Get.back(), width: width, textColor: Colors.black, bgColor: Colors.grey),
              const SizedBox(height: 10)
            ],
          )),
      isDismissible: true,
    );

Future getImage(bool isGallery, Function(File, bool) onChoose, bool isCrop) async {
  XFile? res;
  if (isGallery) {
    res = await ImagePicker().pickImage(source: ImageSource.gallery);
  } else {
    res = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
  }
  if (res != null) {
    if (isCrop) {
      cropImage(isGallery, res, onChoose);
    } else {
      onChoose(File(res.path), isGallery);
    }
  }
}

Future cropImage(bool isGallery, XFile file, Function(File, bool) onChoose) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: file.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: true),
      IOSUiSettings(),
    ],
  );

  if (croppedFile != null) {
    var file = File(croppedFile.path);
    onChoose(file, isGallery);
  }
}

void saveFileOnTempPath(File chooseFile, {String? imgName, Function(File)? onNewFile}) async {
  imgName = imgName ?? pathTempProfileImageName;

  getImageDirectoryPath(imgName).then((tempPath) {
    ///Delete previous file if exists
    final checkFile = File(tempPath);
    if (checkFile.existsSync()) checkFile.deleteSync();

    ///Create new file
    File(tempPath).createSync(recursive: true);
    File newFile = chooseFile.copySync(tempPath);
    chooseFile.deleteSync();
    if (onNewFile != null) onNewFile(newFile);
  });
}

Future<String> getImageDirectoryPath(String path) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  return "${appDocDir.path}${AssetConstants.pathTempImageFolder}${DateTime.now().millisecondsSinceEpoch}$path";
}

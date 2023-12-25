import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import '../../../../data/models/user.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/decorations.dart';
import 'my_profile_controller.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  ProfileEditScreenState createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<ProfileEditScreen> {
  final _controller = Get.put(MyProfileController());
  User user = gUserRx.value;
  Rx<File> profileImage = File("").obs;
  Rx<Country> selectedPhone = Country.parse("US").obs;
  Rx<Country> selectedCountry = Country.parse("US").obs;
  RxInt selectedGender = 0.obs;
  TextEditingController firstNameEditController = TextEditingController();
  TextEditingController lastNameEditController = TextEditingController();
  TextEditingController nickNameEditController = TextEditingController();
  TextEditingController phoneEditController = TextEditingController();
  TextEditingController countryEditController = TextEditingController();

  List<String> getGenderList() => ["Male".tr, "Female".tr, "Others".tr];

  @override
  void initState() {
    super.initState();
    selectedGender.value = user.gender != null ? (user.gender! - 1) : -1;
    if (user.country.isValid) {
      selectedCountry.value = Country.parse(user.country!);
      countryEditController.text = selectedCountry.value.name;
    }
    getPhoneNumber();
  }

  void getPhoneNumber() async {
    if (user.phone.isValid) {
      var phone = user.phone!.contains("+") ? user.phone! : "+${user.phone!}";
      final phoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(phone);
      selectedPhone.value = Country.parse(phoneNumber.isoCode ?? "");
      phoneEditController.text = user.phone!;
    } else {
      phoneEditController.text = selectedPhone.value.phoneCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          Align(alignment: Alignment.centerLeft, child: textAutoSizePoppins("Profile Update".tr, fontSize: Dimens.regularFontSizeExtraMid)),
          vSpacer20(),
          _photoEditView(),
          vSpacer20(),
          textFieldWithSuffixIcon(controller: firstNameEditController, hint: "First Name".tr, labelText: "First Name".tr, text: user.firstName ?? ""),
          vSpacer10(),
          textFieldWithSuffixIcon(controller: lastNameEditController, hint: "Last Name".tr, labelText: "Last Name".tr, text: user.lastName ?? ""),
          vSpacer10(),
          textFieldWithSuffixIcon(controller: nickNameEditController, hint: "Nick Name".tr, labelText: "Nick Name".tr, text: user.nickName ?? ""),
          vSpacer10(),
          Obx(() => textFieldWithWidget(
              controller: phoneEditController,
              type: TextInputType.phone,
              prefixWidget: countryPickerView(context, selectedPhone.value, (value) {
                selectedPhone.value = value;
                phoneEditController.text = value.phoneCode;
              }, showPhoneCode: true))),
          textAutoSizePoppins("add phone number message".tr, maxLines: 2, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMin),
          vSpacer10(),
          Obx(() => textFieldWithWidget(
              controller: countryEditController,
              hint: "Select Country".tr,
              readOnly: true,
              prefixWidget: countryPickerView(context, selectedCountry.value, (value) {
                selectedCountry.value = value;
                countryEditController.text = value.name;
              }))),
          vSpacer10(),
          Obx(() =>
              dropDownListIndex(getGenderList(), selectedGender.value, "Select Gender".tr, hMargin: 0, (value) => selectedGender.value = value)),
          vSpacer20(),
          buttonRoundedMain(text: "Update Profile".tr, onPressCallback: () => checkProfileData()),
          vSpacer10(),
        ],
      ),
    );
  }

  Widget _photoEditView() {
    final boxSize = context.width / 2.5;
    return Align(
      child: Container(
        width: boxSize,
        height: boxSize,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        decoration: getRoundCornerWithShadow(color: context.theme.scaffoldBackgroundColor),
        child: InkWell(
          onTap: () {
            showImageChooser(context, (chooseFile, isGallery) {
              isGallery ? profileImage.value = chooseFile : saveFileOnTempPath(chooseFile, onNewFile: (newFile) => profileImage.value = newFile);
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Obx(() => profileImage.value.path == ""
                  ? showCircleAvatar(user.photo, size: boxSize - Dimens.paddingLargeDouble)
                  : showCircleAvatarLocal(profileImage.value, size: boxSize - Dimens.paddingLargeDouble)),
              Positioned(bottom: 0, right: 0, child: buttonOnlyIcon(iconPath: AssetConstants.icEditRoundBg, size: Dimens.iconSizeMid))
            ],
          ),
        ),
      ),
    );
  }

  void checkProfileData() async {
    User updateUser = user.createNewInstance();
    if (firstNameEditController.text.trim().isEmpty) {
      showToast("First name can not be empty".tr, isError: true);
      return;
    }
    updateUser.firstName = firstNameEditController.text.trim();

    if (lastNameEditController.text.trim().isEmpty) {
      showToast("Last name can not be empty".tr, isError: true);
      return;
    }
    updateUser.lastName = lastNameEditController.text.trim();

    if (nickNameEditController.text.trim().isEmpty) {
      showToast("Nick name can not be empty".tr, isError: true);
      return;
    }
    updateUser.nickName = nickNameEditController.text.trim();

    if (phoneEditController.text.trim().isNotEmpty) {
      var number = removeSpecialChar(phoneEditController.text.trim());
      if (number.length > selectedPhone.value.phoneCode.length) updateUser.phone = number;
    }
    if (countryEditController.text.trim().isNotEmpty) updateUser.country = selectedCountry.value.countryCode;
    if (selectedGender.value != -1) updateUser.gender = selectedGender.value + 1;
    hideKeyboard(context: context);
    _controller.updateProfile(updateUser, profileImage.value);
  }
}

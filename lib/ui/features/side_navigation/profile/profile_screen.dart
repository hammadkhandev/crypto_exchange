import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'bank_screen.dart';
import 'kyc_screen.dart';
import 'my_profile_controller.dart';
import 'my_profile_edit_screen.dart';
import 'security_screen.dart';
import 'send_sms_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _controller = Get.put(MyProfileController());
  List<UserActivity> userActivities = <UserActivity>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
            child: Column(
              children: [
                appBarBackWithActions(title: "Profile".tr),
                Obx(() => Expanded(
                      child: Column(
                        children: [
                          dropDownListIndex(_controller.getProfileMenus(), _controller.selectedType.value, "All type".tr,
                              (value) => _controller.selectedType.value = value),
                          _buildBody()
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.selectedType.value == 0) {
      return _profileView(gUserRx.value);
    } else if (_controller.selectedType.value == 1) {
      return const ProfileEditScreen();
    } else if (_controller.selectedType.value == 2) {
      return const SendSMSScreen();
    } else if (_controller.selectedType.value == 3) {
      return const SecurityScreen();
    } else if (_controller.selectedType.value == 4) {
      return const KYCScreen();
    } else if (_controller.selectedType.value == 5) {
      return const BankScreen();
    } else {
      return Container();
    }
  }

  Widget _profileView(User user) {
    final boxSize = context.width / 1.75;
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: textAutoSizePoppins("Profile Information".tr, fontSize: Dimens.regularFontSizeExtraMid),
          ),
          vSpacer20(),
          Align(
            child: Container(
              width: boxSize,
              height: boxSize,
              padding: const EdgeInsets.all(Dimens.paddingMid),
              decoration: getRoundCornerWithShadow(color: context.theme.scaffoldBackgroundColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showCircleAvatar(user.photo, size: boxSize / 2),
                  vSpacer10(),
                  textAutoSizeTitle(getName(user.firstName, user.lastName), fontSize: Dimens.regularFontSizeLarge),
                  textAutoSizePoppins(user.email ?? "", color: context.theme.primaryColor),
                ],
              ),
            ),
          ),
          vSpacer20(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(),
              text: user.nickName.isValid ? user.nickName : "No Nick Name".tr,
              hint: "Nick Name".tr,
              isEnable: false),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(),
              text: user.countryName.isValid ? user.countryName : "No Country".tr,
              hint: "Country".tr,
              isEnable: false),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(), text: getActiveStatusData(user.status).first, hint: "Status".tr, isEnable: false),
          vSpacer10(),
          textFieldWithSuffixIcon(controller: TextEditingController(), text: user.phone ?? "No Phone".tr, hint: "Phone".tr, isEnable: false),
          vSpacer30(),
          _userActivityListView()
        ],
      ),
    );
  }

  Widget _userActivityListView() {
    if (userActivities.isEmpty) _controller.getUserActivities((list) => userActivities = list);
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: textAutoSizePoppins("Profile Activity".tr, fontSize: Dimens.regularFontSizeExtraMid),
      ),
      vSpacer20(),
      _activitySectionView(),
      userActivities.isEmpty
          ? vSpacer0()
          : Column(children: List.generate(userActivities.length, (index) => _userActivityItem(userActivities[index]))),
      vSpacer20(),
    ]);
  }

  Widget _activitySectionView() {
    return Container(
      decoration: boxDecorationTopRound(),
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
      height: Dimens.btnHeightMain,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(flex: 1, child: textAutoSizePoppins("Action".tr, textAlign: TextAlign.start)),
          Expanded(flex: 1, child: textAutoSizePoppins("IP Address".tr)),
          Expanded(flex: 1, child: textAutoSizePoppins("Time".tr, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _userActivityItem(UserActivity activity) {
    String actionString = "${getActivityActionText(activity.action)}\n${activity.source ?? ""}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMin),
      child: Row(
        children: [
          Expanded(flex: 1, child: textAutoSizePoppins(actionString, maxLines: 2, textAlign: TextAlign.start)),
          Expanded(flex: 1, child: textAutoSizePoppins(activity.ipAddress ?? "", maxLines: 2)),
          Expanded(
              flex: 1,
              child: textAutoSizePoppins(formatDate(activity.updatedAt, format: dateTimeFormatYyyyMMDdHhMm), maxLines: 2, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

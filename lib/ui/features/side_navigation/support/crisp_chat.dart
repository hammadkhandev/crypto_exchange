import 'package:crisp/crisp_view.dart';
import 'package:crisp/models/main.dart';
import 'package:crisp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/language_util.dart';

class CrispChat extends StatefulWidget {
  const CrispChat({Key? key}) : super(key: key);

  @override
  CrispChatState createState() => CrispChatState();
}

class CrispChatState extends State<CrispChat> {
   CrispMain? crispMain;

  @override
  void initState() {
    super.initState();
    final key = getSettingsLocal()?.liveChatKey ?? "";
    if (key.isValid && key != DefaultValue.crispKey) {
      crispMain = CrispMain(websiteId: key);
      crispMain?.register(
          user: CrispUser(
              email: gUserRx.value.email ?? "",
              avatar: gUserRx.value.photo ?? "",
              nickname: gUserRx.value.firstName ?? "",
              phone: gUserRx.value.phone ?? ""));
    } else {
      showToast("Invalided Crisp chat key".tr);
    }

    // crispMain.setMessage("Hello world");
    // crispMain.setSessionData({
    //   "order_id": "111",
    //   "app_version": "0.1.1",
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          if(crispMain != null)
          CrispView(
            crispMain: crispMain!,
            clearCache: false,
            onLinkPressed: openUrlInBrowser,
          ),
          Positioned(
              right: LanguageUtil.isDirectionRTL() ? null : 0,
              left: LanguageUtil.isDirectionRTL() ? 0 : null,
              child: buttonOnlyIcon(iconPath: AssetConstants.icCloseBox, iconColor: Get.theme.primaryColorDark, onPressCallback: () => Get.back())),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/helper/two_fa_helper.dart';
import 'package:tradexpro_flutter/ui/features/root/root_screen.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/ui/features/auth/email_verify/email_verify_page.dart';

class SignInController extends GetxController {
  TextEditingController emailEditController = TextEditingController();
  TextEditingController passEditController = TextEditingController();
  TextEditingController codeEditController = TextEditingController();
  RxBool isShowPassword = false.obs;

  void clearInputData() {
    emailEditController.text = "";
    passEditController.text = "";
    isShowPassword = false.obs;
  }

  void isInPutDataValid(BuildContext context) {
    if (emailEditController.text.trim().isNotEmpty && passEditController.text.isNotEmpty) {
      if (!GetUtils.isEmail(emailEditController.text.trim())) {
        showToast("Input a valid Email".tr, isError: true);
        return;
      }
      if (passEditController.text.length < DefaultValue.kPasswordLength) {
        showToast("Password_invalid_message".trParams({"count": DefaultValue.kPasswordLength.toString()}), isError: true);
        return;
      }
      hideKeyboard(context: context);
      loginUser(context);
    } else {
      showToast("Fields can not be empty".tr, isError: true);
    }
  }

  void loginUser(BuildContext context) {
    showLoadingDialog();
    APIRepository().loginUser(emailEditController.text.trim(), passEditController.text).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        if (success) {
          final user = User.fromJson(resp.data[APIKeyConstants.user]);
          if (resp.data[APIKeyConstants.g2fEnabled] == "1") {
            verifyGoogleCodeLogin(context, user.id);
          } else {
            showToast(message, isError: false);
            handleLoginSuccess(resp.data);
          }
        } else {
          final verify = resp.data[APIKeyConstants.emailVerified] as int?;
          if (verify != null && verify == 0) {
            alertForAction(context, title: "Need verification".tr, subTitle: "verify unverified account".tr, buttonTitle: "Verify".tr,
                onOkAction: () {
              Get.back();
              Get.off(() => EmailVerifyPage(registrationId: emailEditController.text.trim()));
            });
          } else {
            showToast(message);
          }
        }
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void verifyGoogleCodeLogin(BuildContext context, int userId) {
    TwoFAHelper.get2FACode(forText: "Sign In".tr, buttonText: "Sign In".tr, (code) {
      hideKeyboard(context: context);
      showLoadingDialog();
      APIRepository().verify2FACodeLogin(code, userId).then((resp) {
        hideLoadingDialog();
        showToast(resp.message, isError: !resp.success);
        if (resp.success) {
          Get.back();
          handleLoginSuccess(resp.data);
        }
      }, onError: (err) {
        hideLoadingDialog();
        showToast(err.toString());
      });
    });
  }

  void handleLoginSuccess(dynamic resp) {
    GetStorage().write(PreferenceKey.accessToken, resp[APIKeyConstants.accessToken] ?? "");
    GetStorage().write(PreferenceKey.accessType, resp[APIKeyConstants.accessType] ?? "");
    GetStorage().write(PreferenceKey.accessTokenEvm, resp[APIKeyConstants.accessTokenEvm] ?? "");
    var userMap = resp[APIKeyConstants.user] as Map?;
    if (userMap != null) {
      GetStorage().write(PreferenceKey.userObject, userMap);
      GetStorage().write(PreferenceKey.isLoggedIn, true);
      Future.delayed(const Duration(milliseconds: 100), () => Get.offAll(() => const RootScreen()));
    }
  }

}

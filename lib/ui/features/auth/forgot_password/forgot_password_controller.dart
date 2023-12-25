import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/ui/features/auth/reset_password/reset_password_screen.dart';
import '../../../../data/local/api_constants.dart';
import '../../../../data/remote/api_repository.dart';
import '../../../../utils/common_utils.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailEditController = TextEditingController();

  void isInPutDataValid(BuildContext context) {
    if (!GetUtils.isEmail(emailEditController.text.trim())) {
      showToast("Input a valid Email".tr);
      return;
    }
    hideKeyboard(context: context);
    forgetPassword();
  }

  void forgetPassword() {
    showLoadingDialog();
    APIRepository().forgetPassword(emailEditController.text.trim()).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) {
          Get.off(() => ResetPasswordScreen(registrationId: emailEditController.text.trim()));
        }
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

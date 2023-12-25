import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/local/api_constants.dart';
import '../../../../data/local/constants.dart';
import '../../../../data/remote/api_repository.dart';
import '../../../../utils/common_utils.dart';
import '../sign_in/sign_in_screen.dart';

class ResetPasswordController extends GetxController {
  TextEditingController codeEditController = TextEditingController();
  TextEditingController passEditController = TextEditingController();
  TextEditingController confirmPassEditController = TextEditingController();
  RxBool isShowPassword = false.obs;

  void isInPutDataValid(BuildContext context, String email) {
    if (codeEditController.text.trim().isNotEmpty && passEditController.text.isNotEmpty && confirmPassEditController.text.isNotEmpty) {
      if (codeEditController.text.length < DefaultValue.codeLength) {
        showToast("Code length must be".trParams({"count": DefaultValue.codeLength.toString()}));
        return;
      }
      if (!isValidPassword(passEditController.text)) {
        showToast("Password_invalid_message".trParams({"count": DefaultValue.kPasswordLength.toString()}));
        return;
      }
      if (passEditController.text != confirmPassEditController.text) {
        showToast("Password and confirm password not matched".tr);
        return;
      }
      hideKeyboard(context: context);
      resetPassword(email);
    } else {
      showToast("Fields can not be empty".tr);
    }
  }

  void resetPassword(String email) {
    showLoadingDialog();
    APIRepository().resetPassword(email, codeEditController.text.trim(), passEditController.text).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) Get.off(() => const SignInPage());
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/local/api_constants.dart';
import '../../../../data/local/constants.dart';
import '../../../../data/remote/api_repository.dart';
import '../../../../utils/common_utils.dart';

class ChangePasswordController extends GetxController {
  TextEditingController currentPassEditController = TextEditingController();
  TextEditingController newPassEditController = TextEditingController();
  TextEditingController confirmPassEditController = TextEditingController();
  RxBool isShowPassword = false.obs;

  void isInPutDataValid(BuildContext context) {
    if (currentPassEditController.text.isNotEmpty && newPassEditController.text.isNotEmpty && confirmPassEditController.text.isNotEmpty) {
      if (!isValidPassword(newPassEditController.text)) {
        showToast("Password_invalid_message".trParams({"count": DefaultValue.kPasswordLength.toString()}));
        return;
      }
      if (newPassEditController.text != confirmPassEditController.text) {
        showToast("Password and confirm password not matched".tr);
        return;
      }
      hideKeyboard(context: context);
      changePassword();
    } else {
      showToast("Fields can not be empty".tr);
    }
  }

  void changePassword() {
    showLoadingDialog();
    APIRepository().changePassword(currentPassEditController.text, newPassEditController.text, confirmPassEditController.text).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) Get.back();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

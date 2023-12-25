import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/ui/features/auth/signup_success_page.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import '../../../../data/local/api_constants.dart';

class EmailVerifyController extends GetxController {
  TextEditingController codeEditController = TextEditingController();

  void isInPutDataValid(BuildContext context, String email) {
    if (codeEditController.text.length < DefaultValue.codeLength) {
      showToast("Code length must be".trParams({"count": DefaultValue.codeLength.toString()}));
      return;
    }
    hideKeyboard(context: context);
    verifyCode(email);
  }

  void verifyCode(String email) {
    showLoadingDialog();
    APIRepository().verifyEmail(email, codeEditController.text).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) {
          Get.off(() => const SignUpSuccessPage());
        }
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

// void resendEmailVerificationCode() {
//   showLoadingDialog();
//   APIRepository().resendEmailVerificationCode(emailEditController.text).then((resp) {
//     hideLoadingDialog();
//     showToast(resp.message);
//   }, onError: (err) {
//     hideLoadingDialog();
//     showToast(err.toString());
//   });
// }

}

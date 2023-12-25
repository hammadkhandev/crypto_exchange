import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/language_util.dart';
import 'package:tradexpro_flutter/data/models/settings.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';

class SettingsController extends GetxController {
  Rx<UserSettings> userSettings = UserSettings().obs;
  TextEditingController codeEditController = TextEditingController();
  RxInt selectedCurrency = 0.obs;
  RxInt selectedLanguage = 0.obs;
  RxInt selectedColorIndex = 0.obs;
  RxInt selectedPreferenceIndex = 0.obs;

  void getUserSetting() {
    showLoadingDialog();
    APIRepository().getUserSetting().then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        userSettings.value = UserSettings.fromJson(resp.data);
        if (userSettings.value.user != null) saveGlobalUser(user: userSettings.value.user);
        if (userSettings.value.fiatCurrency != null) {
          final list = userSettings.value.fiatCurrency ?? [];
          final currency = list.firstWhereOrNull((element) => element.code == (userSettings.value.user?.currency ?? ""));
          if (currency != null) selectedCurrency.value = list.indexOf(currency);
        }
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void setCurrentLanguage() {
    selectedLanguage.value = -1;
    final list = getSettingsLocal()?.languageList ?? [];
    final language = list.firstWhereOrNull((element) => element.key?.toLowerCase() == (LanguageUtil.getCurrentKey().toLowerCase()));
    if (language != null) selectedLanguage.value = list.indexOf(language);
  }

  void setupGoogleSecret() {
    if (codeEditController.text.trim().length < DefaultValue.codeLength) {
      showToast("Code length must be".trParams({"count": DefaultValue.codeLength.toString()}));
      return;
    }
    showLoadingDialog();
    bool isAdd = userSettings.value.google2faSecret.isValid;
    String secret = isAdd ? (userSettings.value.google2faSecret ?? "") : (userSettings.value.user?.google2FaSecret ?? "");

    APIRepository().setupGoogleSecret(codeEditController.text.trim(), secret, isAdd).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) {
        userSettings.value.user?.google2FaSecret = isAdd ? userSettings.value.google2faSecret : "";
        codeEditController.text = "";
        userSettings.refresh();
        if (resp.data != null) saveGlobalUser(userMap: resp.data);
        Get.back();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void enableDisable2FALogin() {
    showLoadingDialog();
    APIRepository().twoFALoginEnableDisable().then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) {
        if (resp.data != null) saveGlobalUser(userMap: resp.data);
        userSettings.value.user = gUserRx.value;
        codeEditController.text = "";
        userSettings.refresh();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void saveCurrency() {
    showLoadingDialog();
    final currency = userSettings.value.fiatCurrency![selectedCurrency.value];
    APIRepository().updateCurrency(currency.code ?? "").then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) updateCommonSettings();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  List<String> getLanguageList() {
    final lList = getSettingsLocal()?.languageList;
    if (lList != null) {
      List<String> cList = lList.map((e) => e.name ?? "").toList();
      return cList;
    }
    return [];
  }

// void saveLanguage() {
//   showLoadingDialog();
//   final language = getSettingsLocal()?.languageList?[selectedLanguage.value];
//   APIRepository().updateLanguage(language?.key ?? "").then((resp) {
//     hideLoadingDialog();
//     showToast(resp.message, isError: !resp.success);
//     if (resp.success) {
//       LanguageUtil.updateLanguage(language?.key ?? "");
//       updateGlobalUser();
//     }
//   }, onError: (err) {
//     hideLoadingDialog();
//     showToast(err.toString());
//   });
// }
}

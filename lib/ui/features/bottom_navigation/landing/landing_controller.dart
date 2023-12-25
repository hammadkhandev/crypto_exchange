import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/models/settings.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';

class LandingController extends GetxController {
  Rx<LandingData> landingData = LandingData().obs;
  RxBool isLoading = false.obs;
  RxInt selectedTab = 0.obs;

  void getLandingSettings() async {
    isLoading.value = true;
    APIRepository().getCommonSettings().then((resp) {
      isLoading.value = false;
      if (resp.success && resp.data != null && resp.data is Map<String, dynamic>) {
        final settings = resp.data[APIKeyConstants.landingSettings];
        if (settings != null && settings is Map<String, dynamic>) {
          landingData.value = LandingData.fromJson(settings);
        }
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }
}

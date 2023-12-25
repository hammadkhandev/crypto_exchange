import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/network_util.dart';
import 'package:tradexpro_flutter/ui/features/on_boarding/on_boarding_screen.dart';
import 'package:tradexpro_flutter/ui/features/root/root_screen.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getCommonSettings();
  }

  void getCommonSettings() async {
    gUserAgent = await getUserAgent();
    NetworkCheck.isOnline().then((value) {
      if (value) {
        APIRepository().getCommonSettings().then((resp) {
          if (resp.success && resp.data != null && resp.data is Map<String, dynamic>) {
            final settings = resp.data[APIKeyConstants.commonSettings];
            if (settings != null && settings is Map<String, dynamic>) {
              GetStorage().write(PreferenceKey.settingsObject, settings);
            }
            final media = resp.data[APIKeyConstants.landingSettings]["media_list"];
            if (media != null && media is List) {
              GetStorage().write(PreferenceKey.mediaList, media);
            }
          }
          takeNextStep();
        });
      }
    });
  }

  void takeNextStep() {
    var isOnBoarding = GetStorage().read(PreferenceKey.isOnBoardingDone);
    if (isOnBoarding) {
      Get.off(() => const RootScreen(), transition: Transition.leftToRightWithFade);
    } else {
      Get.off(() => const OnBoardingScreen(), transition: Transition.leftToRightWithFade);
    }
  }
}

import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/app_notification.dart';
import '../../../data/remote/api_repository.dart';
import '../../../utils/common_utils.dart';
import '../root/root_controller.dart';

class NotificationsController extends GetxController {
  RxList<AppNotification> notificationList = <AppNotification>[].obs;
  RxBool isDataLoading = false.obs;

  void getNotifications() {
    isDataLoading.value = true;
    APIRepository().getNotifications().then((resp) {
      isDataLoading.value = false;
      if (resp.success) {
        List<AppNotification> list = List<AppNotification>.from(resp.data!.map((x) => AppNotification.fromJson(x)));
        notificationList.value = list;
        Get.find<RootController>().notificationCount.value = list.length;
      } else {
        showToast(resp.message);
      }
    }, onError: (err) => showToast(err.toString()));
  }

  void updateNotificationStatus() {
    if (notificationList.isEmpty) return;
    showLoadingDialog();
    List<int> ids = notificationList.map((element) => element.id).toList();
    APIRepository().updateNotificationStatus(ids).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        showToast("All notifications are cleared".tr, isError: false);
        notificationList.clear();
        Get.find<RootController>().notificationCount.value = 0;
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

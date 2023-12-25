import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/gift_card.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';

class GiftCardThemesController extends GetxController {
  RxList<GiftCardBanner> themeList = <GiftCardBanner>[].obs;
  GiftCardThemeData? giftCardsData;
  RxInt selectedCategory = 0.obs;
  RxBool isLoading = true.obs;
  bool hasMoreData = true;
  int loadedPage = 0;

  List<String> getCategoryNameList() {
    var list = <String>[];
    if (giftCardsData?.categories.isValid ?? false) {
      list = giftCardsData!.categories!.map((e) => e.name ?? "").toList();
    }
    list.insert(0, "All".tr);
    return list;
  }

  void getGiftCardThemeData(Function() onSuccess) {
    APIRepository().getGiftCardThemeData().then((resp) {
      if (resp.success && resp.data != null) {
        giftCardsData = GiftCardThemeData.fromJson(resp.data);
        onSuccess();
        getGiftCardThemes(false);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  void getGiftCardThemes(bool isLoadMore) {
    if (!isLoadMore) {
      loadedPage = 0;
      hasMoreData = true;
      themeList.clear();
    }
    loadedPage++;
    isLoading.value = true;
    final uid = selectedCategory.value == 0 ? FromKey.all : giftCardsData!.categories![selectedCategory.value - 1].uid;
    APIRepository().getGiftCardThemes(loadedPage, uid ?? "").then((resp) {
      isLoading.value = false;
      if (resp.success && resp.data != null) {
        final listResponse = ListResponse.fromJson(resp.data);
        loadedPage = listResponse.currentPage ?? 0;
        hasMoreData = listResponse.nextPageUrl != null;
        final list = List<GiftCardBanner>.from(listResponse.data!.map((x) => GiftCardBanner.fromJson(x)));
        themeList.addAll(list);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }
}

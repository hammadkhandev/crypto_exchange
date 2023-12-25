import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/gift_card.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/gift_cards/gift_cards_controller.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';

class GiftCardSelfController extends GetxController {
  RxList<GiftCard> myCardList = <GiftCard>[].obs;
  GiftCardSelfData? giftCardsData;
  RxInt selectedStatus = 0.obs;
  RxBool isLoading = true.obs;
  bool hasMoreData = true;
  int loadedPage = 0;
  GiftCard? updatedCard;

  List<String> getStatusList() => ["All".tr, "Active".tr, "Redeemed".tr, "Transferred".tr, "Trading".tr, "Locked".tr];

  void getGiftCardMyPageData(Function() onSuccess) {
    APIRepository().getGiftCardMyPageData().then((resp) {
      if (resp.success && resp.data != null) {
        giftCardsData = GiftCardSelfData.fromJson(resp.data);
        onSuccess();
        getGiftCardMyCardList(false);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  void getGiftCardMyCardList(bool isLoadMore) {
    if (!isLoadMore) {
      loadedPage = 0;
      hasMoreData = true;
      myCardList.clear();
    }
    loadedPage++;
    isLoading.value = true;
    final status = selectedStatus.value == 0 ? FromKey.all : selectedStatus.value.toString();
    APIRepository().getGiftCardMyCardList(loadedPage, status).then((resp) {
      isLoading.value = false;
      if (resp.success && resp.data != null) {
        final listResponse = ListResponse.fromJson(resp.data);
        loadedPage = listResponse.currentPage ?? 0;
        hasMoreData = listResponse.nextPageUrl != null;
        final list = List<GiftCard>.from(listResponse.data!.map((x) => GiftCard.fromJson(x)));
        myCardList.addAll(list);
        handleUpdatedCardAction();
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  void giftCardUpdate(GiftCard gCard) async {
    showLoadingDialog();
    APIRepository().giftCardUpdate(gCard.uid ?? "", gCard.lock == 0 ? 1 : 0, "").then((resp) async {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) {
        Get.back();
        updatedCard = gCard;
        getGiftCardMyCardList(false);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  handleUpdatedCardAction() {
    if (updatedCard != null) {
      final card = myCardList.firstWhereOrNull((element) => element.uid == updatedCard?.uid);
      if (card != null) Get.find<GiftCardsController>().updateMyCardList(card);
      updatedCard == null;
    }
  }
}

import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/gift_card.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';

import 'gift_cards_self/gift_cards_self_screen.dart';

class GiftCardsController extends GetxController {
  Rx<GiftCardsData> giftCardsData = GiftCardsData().obs;
  RxBool isLoading = true.obs;

  void getGiftCardsLandingDetails() {
    APIRepository().getGiftCardMainPageData().then((resp) {
      isLoading.value = false;
      if (resp.success && resp.data != null) {
        giftCardsData.value = GiftCardsData.fromJson(resp.data);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  void getGiftCardCheck(String code, Function(GiftCard) onSuccess) {
    showLoadingDialog();
    APIRepository().getGiftCardCheck(code).then((resp) {
      hideLoadingDialog();
      if (resp.success && resp.data != null) {
        final card = GiftCard.fromJson(resp.data[APIKeyConstants.card]);
        final banner = GiftCardBanner.fromJson(resp.data[APIKeyConstants.banner]);
        card.banner = banner;
        onSuccess(card);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void getGiftCardCode(String uid, String password, Function(String) onSuccess) {
    showLoadingDialog();
    APIRepository().getGiftCardRedeemCode(uid, password).then((resp) {
      hideLoadingDialog();
      if (resp.success && resp.data != null) {
        final code = resp.data[APIKeyConstants.redeemCode] ?? "";
        onSuccess(code);
        Future.delayed(const Duration(seconds: 1), () => Get.back());
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void giftCardRedeem(String code) {
    showLoadingDialog();
    APIRepository().getGiftCardRedeem(code).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) Get.back();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void giftCardAdd(String code) {
    showLoadingDialog();
    APIRepository().getGiftCardAdd(code).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) Get.off(() => const GiftCardSelfScreen());
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void giftCardUpdate(GiftCard gCard) async {
    showLoadingDialog();
    APIRepository().giftCardUpdate(gCard.uid ?? "", gCard.lock == 0 ? 1 : 0, FromKey.home).then((resp) async {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) {
        Get.back();
        if (resp.data != null) {
          final myCards = List<GiftCard>.from(resp.data["my_cards"].map((x) => GiftCard.fromJson(x)));
          if (myCards.isValid) {
            giftCardsData.value.myCards = myCards;
            giftCardsData.refresh();
          }
        }
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void updateMyCardList(GiftCard gCard) {
    if (giftCardsData.value.myCards.isValid) {
      final index = giftCardsData.value.myCards!.indexWhere((element) => element.uid == gCard.uid);
      if (index != -1) {
        giftCardsData.value.myCards![index] = gCard;
        giftCardsData.refresh();
      }
    }
  }

  void giftCardSend(String cardUid, int sendType, String sendId, String? message) async {
    showLoadingDialog();
    APIRepository().getGiftCardSend(cardUid, sendType, sendId, message).then((resp) async {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) Get.back();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

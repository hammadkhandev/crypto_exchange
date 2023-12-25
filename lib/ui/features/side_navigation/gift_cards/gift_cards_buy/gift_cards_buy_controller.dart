import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/gift_card.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/gift_cards/gift_cards_self/gift_cards_self_screen.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';

class GiftCardBuyController extends GetxController {
  GiftCardBuyData? giftCardBuyData;
  bool isLoading = true;
  RxInt selectedCoin = 0.obs;
  RxInt selectedTab = 0.obs;
  RxInt selectedWallet = 0.obs;
  RxBool is1Card = true.obs;
  RxBool isLock = false.obs;
  RxDouble amount = 0.0.obs;
  RxInt quantity = 0.obs;
  Rx<GiftCardWalletData> walletData = GiftCardWalletData().obs;
  final noteEditController = TextEditingController();

  List<String> getCoinNameList() {
    if (giftCardBuyData?.coins.isValid ?? false) {
      return giftCardBuyData!.coins!.map((e) => e.coinType ?? "").toList();
    }
    return [];
  }

  String getCoinType() {
    if (selectedCoin.value != -1 && (giftCardBuyData?.coins.isValid ?? false)) {
      return giftCardBuyData!.coins![selectedCoin.value].coinType ?? "";
    }
    return "";
  }

  void getGiftCardBuyData(String uid, Function() onSuccess) {
    APIRepository().getGiftCardBuyData(uid).then((resp) {
      isLoading = false;
      if (resp.success && resp.data != null) {
        giftCardBuyData = GiftCardBuyData.fromJson(resp.data);
        onSuccess();
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading = false;
      showToast(err.toString());
    });
  }

  void getGiftCardWalletData() {
    if (selectedCoin.value == -1) return;
    APIRepository().getGiftCardWalletData(getCoinType()).then((resp) {
      if (resp.success && resp.data != null) {
        walletData.value = GiftCardWalletData.fromJson(resp.data);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void checkAndBuyGiftCard(BuildContext context) async {
    final bannerId = giftCardBuyData?.selectedBanner?.uid ?? "";
    if (bannerId.isEmpty) {
      showToast("Gift Card ID not found".tr, context: context);
      return;
    }
    final coinType = getCoinType();
    if (coinType.isEmpty) {
      showToast("Select your coin".tr, context: context);
      return;
    }
    if (amount.value <= 0) {
      showToast("amount_must_greater_than_0".tr, context: context);
      return;
    }
    final balance = selectedWallet.value == WalletType.p2p ? walletData.value.p2PWalletBalance : walletData.value.exchangeWalletBalance;
    if (amount.value > (balance ?? 0)) {
      showToast("Amount_greater_then".trParams({"amount": "$balance"}), context: context);
      return;
    }

    if (selectedWallet.value == 0) {
      showToast("select your wallet".tr, context: context);
      return;
    }
    if (selectedTab.value == 1 && quantity.value <= 0) {
      showToast("Quantity is required".tr, context: context);
      return;
    }
    final lock = isLock.value ? 1 : 0;
    final note = noteEditController.text.trim();

    hideKeyboard(context: context);
    showLoadingDialog();
    APIRepository().giftCardBuy(bannerId, coinType, selectedWallet.value, amount.value, quantity.value, lock, selectedTab.value, note).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success, context: context);
      if (resp.success) {
        Get.off(() => const GiftCardSelfScreen());
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

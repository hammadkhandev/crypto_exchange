import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';

class FiatWithdrawalController extends GetxController {
  Rx<FiatWithdrawal> fiatWithdrawalData = FiatWithdrawal().obs;
  RxInt selectedMethodIndex = 0.obs;
  RxBool isLoading = true.obs;

  void getFiatWithdrawal() {
    isLoading.value = true;
    APIRepository().getFiatWithdrawal().then((resp) {
      isLoading.value = false;
      if (resp.success) {
        fiatWithdrawalData.value = FiatWithdrawal.fromJson(resp.data);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  List<String> getMethodList(FiatWithdrawal? fiatWithdrawal) {
    if (fiatWithdrawal?.paymentMethodList.isValid ?? false) {
      return fiatWithdrawal!.paymentMethodList!.map((e) => e.title ?? "").toList();
    }
    return [];
  }

  List<String> getBankList(FiatWithdrawal? fiatWithdrawal) {
    if (fiatWithdrawal?.myBank.isValid ?? false) {
      return fiatWithdrawal!.myBank!.map((e) => e.bankName ?? "").toList();
    }
    return [];
  }

  void getAndSetCoinRate(String walletKey, String currency, double amount, Function(FiatWithdrawalRate) onSuccess) async {
    APIRepository().getFiatWithdrawalRate(walletKey, currency, amount).then((resp) {
      if (resp.success) {
        final rate = FiatWithdrawalRate.fromJson(resp.data);
        onSuccess(rate);
      } else {
        showToast(resp.message);
        onSuccess(FiatWithdrawalRate());
      }
    }, onError: (err) {
      showToast(err.message);
    });
  }

  void fiatWithdrawalProcess(CreateWithdrawal withdraw, Function() onSuccess) {
    showLoadingDialog();
    final pMethod = fiatWithdrawalData.value.paymentMethodList?[selectedMethodIndex.value];
    withdraw.paymentMethodId = pMethod?.id;
    withdraw.paymentMethodType = pMethod?.paymentMethod;
    withdraw.type = "fiat";
    APIRepository().fiatWithdrawalProcess(withdraw).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success, isLong: true);
      if (resp.success) onSuccess();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

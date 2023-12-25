import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/models/response.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';

class WalletWithdrawalController extends GetxController {
  Rx<FiatWithdrawal> fiatWithdrawalData = FiatWithdrawal().obs;
  late Wallet wallet;
  RxBool isLoading = true.obs;
  RxInt selectedMethodIndex = 0.obs;

  void getFiatWithdrawal() {
    isLoading.value = true;
    APIRepository().getWalletCurrencyWithdraw().then((resp) {
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

  void walletCurrencyWithdraw(CreateWithdrawal withdraw, Function() onSuccess) {
    showLoadingDialog();
    final pMethod = fiatWithdrawalData.value.paymentMethodList?[selectedMethodIndex.value];
    withdraw.paymentMethodId = pMethod?.id;
    withdraw.paymentMethodType = pMethod?.paymentMethod;
    withdraw.type = "wallet";
    APIRepository().walletCurrencyWithdraw(withdraw).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success, isLong: true);
      if (resp.success) onSuccess();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  Future<void> getHistoryListData(String type, Function(List<History>) onGetHistory) async {
    APIRepository().getActivityList(0, type).then((resp) {
      if (resp.success) {
        final historyResponse = HistoryResponse.fromJson(resp.data);
        final listResponse = historyResponse.histories;
        if (listResponse != null) {
          final list = List<History>.from(listResponse.data!.map((x) => History.fromJson(x)));
          onGetHistory(list);
        }
      }
    }, onError: (err) {});
  }

  Future<void> getFAQList(int type, Function(List<FAQ>) onList) async {
    APIRepository().getFAQList(1, type: type).then((resp) {
      if (resp.success) {
        ListResponse response = ListResponse.fromJson(resp.data);
        if (response.data != null) {
          List<FAQ> list = List<FAQ>.from(response.data!.map((x) => FAQ.fromJson(x)));
          onList(list);
        }
      }
    }, onError: (err) {});
  }

  Future<void> getWalletWithdrawal(Wallet wallet, Function(Map) onWallet) async {
    showLoadingDialog();
    APIRepository().getWalletWithdrawal(wallet.id).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        if (success) {
          onWallet(resp.data);
        } else {
          showToast(message);
        }
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  Future<void> preWithdrawalProcess(String address, double amount, int walletId, Function(PreWithdraw) onData, {String? network}) async {
    APIRepository().preWithdrawalProcess(address, amount, walletId, "withdrawal", "", network: network).then((resp) {
      if (resp.success && resp.data != null) {
        onData(PreWithdraw.fromJson(resp.data));
      }
    }, onError: (err) {});
  }

  Future<void> preWithdrawalProcessEvm(String address, double amount, int walletId, Network network, Function(PreWithdraw) onData) async {
    APIRepository().preWithdrawalProcessEvm(address, amount, walletId, "withdrawal", networkId: network.id, networkType: network.networkType).then(
        (resp) {
      if (resp.success && resp.data != null) {
        onData(PreWithdraw.fromJson(resp.data));
      }
    }, onError: (err) {});
  }

  Future<void> withdrawProcess(Wallet wallet, String address, double amount, String networkType, String code) async {
    showLoadingDialog();
    APIRepository().withdrawProcess(wallet.id, address, amount,  networkType, code).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) Get.back();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  Future<void> withdrawProcessEvm(Wallet wallet, String address, double amount, String code, Network network) async {
    showLoadingDialog();
    final netID = network.id == 0 ? null : network.id;
    APIRepository().withdrawProcessEvm(wallet.id, address, amount, code, netID, network.networkType, network.baseType).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) Get.back();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

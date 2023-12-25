import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';

class SwapController extends GetxController {
  RxList<Wallet> walletList = <Wallet>[].obs;
  Rx<Wallet> selectedFromCoin = Wallet(id: 0).obs;
  Rx<Wallet> selectedToCoin = Wallet(id: 0).obs;
  final toEditController = TextEditingController();
  final fromEditController = TextEditingController();
  final RxDouble rate = 0.0.obs;
  final RxDouble convertRate = 0.0.obs;

  Future<void> getCoinSwapApp(Wallet? preWallet) async {
    APIRepository().getCoinSwapApp().then((resp) {
      if (resp.success) {
        final data = resp.data[APIKeyConstants.wallets];
        walletList.value = List<Wallet>.from(data!.map((x) => Wallet.fromJson(x)));
        if (preWallet != null) {
          final wallet = walletList.firstWhereOrNull((element) => element.coinType == preWallet.coinType);
          selectedFromCoin.value = wallet ?? preWallet;
        } else if (walletList.isNotEmpty) {
          selectedFromCoin.value = walletList.first;
        }
        if (walletList.length > 1) {
          if (walletList[1].coinType == selectedFromCoin.value.coinType) {
            selectedToCoin.value = walletList[0];
          } else {
            selectedToCoin.value = walletList[1];
          }
        }
        getAndSetCoinRate();
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getAndSetCoinRate() {
    String amount = fromEditController.text.trim();
    if (amount.isEmpty || amount == "0") {
      rate.value = 0;
      convertRate.value = 0;
      toEditController.text = convertRate.value.toString();
      return;
    }

    if (selectedFromCoin.value.id != 0 && selectedToCoin.value.id != 0) {
      getCoinRate(amount, selectedFromCoin.value.id, selectedToCoin.value.id, (rt, covertRate) {
        rate.value = rt;
        convertRate.value = covertRate;
        toEditController.text = convertRate.value.toString();
      });
    }
  }

  Future<void> getCoinRate(String amount, int fromId, int toId, Function(double, double) onRate) async {
    APIRepository().getCoinRate(amount, fromId, toId).then((resp) {
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        if (success) {
          final rate = makeDouble(resp.data[APIKeyConstants.rate]);
          final convertRate = makeDouble(resp.data[APIKeyConstants.convertRate]);
          onRate(rate, convertRate);
        } else {
          showToast(message);
        }
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  Future<void> swapCoinProcess(int fromCoinId, int toCoinId, double amount) async {
    showLoadingDialog();
    APIRepository().swapCoinProcess(fromCoinId, toCoinId, amount).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) Get.back();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

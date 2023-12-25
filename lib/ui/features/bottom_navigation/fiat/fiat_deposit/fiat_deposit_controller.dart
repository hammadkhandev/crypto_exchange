import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/helper/two_fa_helper.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

class FiatDepositController extends GetxController {
  RxBool isLoading = true.obs;
  RxInt selectedMethodIndex = 0.obs;
  Rx<FiatDeposit> fiatDepositData = FiatDeposit().obs;
  RxList<FAQ> faqList = <FAQ>[].obs;
  bool isDeposit2FActive = false;

  Future<void> getFiatDepositData() async {
    isLoading.value = true;
    APIRepository().getCurrencyDepositData().then((resp) {
      isLoading.value = false;
      if (resp.success) {
        fiatDepositData.value = FiatDeposit.fromJson(resp.data);
      } else {
        showToast(resp.message);
      }
      getFAQList();
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  Future<void> getFAQList() async {
    APIRepository().getFAQList(1, type: FAQType.deposit).then((resp) {
      if (resp.success) {
        ListResponse response = ListResponse.fromJson(resp.data);
        if (response.data != null) {
          List<FAQ> list = List<FAQ>.from(response.data!.map((x) => FAQ.fromJson(x)));
          faqList.value = list;
        }
      }
    }, onError: (err) {});
  }

  Future<void> getCurrencyDepositRate(int walletId, double amount, Function(double) onRate,
      {String? currency, int? bankId, int? walletIdFrom}) async {
    final pMethod = fiatDepositData.value.paymentMethods?[selectedMethodIndex.value];
    APIRepository().getCurrencyDepositRate(walletId, pMethod?.id ?? 0, amount, currency: currency, bankId: bankId, walletIdFrom: walletIdFrom).then(
        (resp) {
      if (resp.success) {
        final cAmount = makeDouble(resp.data[APIKeyConstants.calculatedAmount]);
        onRate(cAmount);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.message);
    });
  }

  Future<void> currencyDepositProcess(CreateDeposit deposit, Function() onSuccess) async {
    final pMethod = fiatDepositData.value.paymentMethods?[selectedMethodIndex.value];
    deposit.paymentId = pMethod?.id;
    if ((getSettingsLocal()?.currencyDeposit2FaStatus ?? "") == "1") {
      if (!gUserRx.value.google2FaSecret.isValid) {
        showToast("You need to activate 2FA from settings for proceed this".tr);
        return;
      }
      TwoFAHelper.get2FACode(forText: "Withdraw".tr, (code) {
        deposit.code = code;
        depositProcess(deposit, onSuccess);
      });
    } else {
      depositProcess(deposit, onSuccess);
    }
  }

  Future<void> depositProcess(CreateDeposit deposit, Function() onSuccess) async {
    showLoadingDialog();
    APIRepository().currencyDepositProcess(deposit).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) {
        if (deposit.code.isValid) Get.back();
        onSuccess();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.message);
    });
  }

  List<String> getMethodList(FiatDeposit? fiatDepositData) {
    if (fiatDepositData?.paymentMethods.isValid ?? false) {
      return fiatDepositData!.paymentMethods!.map((e) => e.title ?? "").toList();
    }
    return [];
  }

  List<String> getBankList(FiatDeposit? fiatDepositData) {
    if (fiatDepositData?.banks.isValid ?? false) {
      return fiatDepositData!.banks!.map((e) => e.bankName ?? "").toList();
    }
    return [];
  }
}

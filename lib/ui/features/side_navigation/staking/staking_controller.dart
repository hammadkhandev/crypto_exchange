import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/models/staking.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

class StakingController extends GetxController {

  void getStakingLandingDetails(Function(StakingLandingData) onSuccess) {
    APIRepository().getStakingLandingDetails().then((resp) {
      if (resp.success) {
        final value = StakingLandingData.fromJson(resp.data);
        onSuccess(value);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getStakingOfferList(Function(StakingOffersData) onSuccess) {
    APIRepository().getStakingOfferList().then((resp) {
      if (resp.success) {
        final value = StakingOffersData.fromJson(resp.data);
        onSuccess(value);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getStakingOfferDetails(String uid, Function(StakingDetailsData) onSuccess) {
    APIRepository().getStakingOfferDetails(uid).then((resp) {
      if (resp.success) {
        final value = StakingDetailsData.fromJson(resp.data);
        onSuccess(value);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void totalInvestmentBonus(String uid, double amount, Function(double) onSuccess) {
    APIRepository().totalInvestmentBonus(uid, amount).then((resp) {
      if (resp.success) {
        final value = makeDouble(resp.data[APIKeyConstants.totalBonus]);
        onSuccess(value);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void investmentSubmit(BuildContext context, String uid, double amount, bool autoRenew) {
    showLoadingDialog();
    APIRepository().investmentSubmit(uid, amount, autoRenew ? StakingRenewType.auto : StakingRenewType.manual).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.success] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success, context: context);
        if (success) Future.delayed(const Duration(seconds: 1), () => Get.back());
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void getStakingInvestmentStatistics(Function(StakingInvestmentStatistics) onSuccess) {
    APIRepository().getStakingInvestmentStatistics().then((resp) {
      if (resp.success) {
        final value = StakingInvestmentStatistics.fromJson(resp.data);
        onSuccess(value);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getStakingInvestmentList(int page, Function(ListResponse) onSuccess) {
    APIRepository().getStakingInvestmentList(page).then((resp) {
      if (resp.success) {
        final value = ListResponse.fromJson(resp.data);
        onSuccess(value);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void investmentCanceled(String uid, Function() onSuccess) {
    showLoadingDialog();
    APIRepository().investmentCanceled(uid).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) onSuccess();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void getStakingEarningList(int page, Function(ListResponse) onSuccess) {
    APIRepository().getStakingInvestmentPaymentList(page).then((resp) {
      if (resp.success) {
        final value = ListResponse.fromJson(resp.data);
        onSuccess(value);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }
}

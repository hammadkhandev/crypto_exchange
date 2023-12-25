import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/response.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';

class WalletController extends GetxController with GetSingleTickerProviderStateMixin {
  final refreshController = EasyRefreshController(controlFinishRefresh: true);
  final searchController = TextEditingController();
  List<CoinPair> coinPairs = [];
  RxInt selectedTypeIndex = 0.obs;
  int loadedPage = 0;
  bool hasMoreData = false;
  RxList<Wallet> walletList = <Wallet>[].obs;
  Rx<TotalBalance> totalBalance = TotalBalance().obs;
  int walletListFromType = 0;
  Timer? _searchTimer;

  Map<int, String> getTypeMap() {
    final settings = getSettingsLocal();
    var map = {WalletViewType.overview: "Wallet Overview".tr, WalletViewType.spot: "Spot Wallet".tr};
    if (settings?.enableFutureTrade == 1) map[WalletViewType.future] = "Future Wallet".tr;
    if (settings?.p2pModule == 1) map[WalletViewType.p2p] = "P2P Wallet".tr;
    return map;
  }

  void changeWalletTab(int type) {
    final index = getTypeMap().keys.toList().indexOf(type);
    if (index != -1) selectedTypeIndex.value = index;
  }

  void onTextChanged(String text) {
    if (_searchTimer?.isActive ?? false) _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(seconds: 1), () => refreshController.callRefresh());
  }

  Future<void> getWalletOverviewData(Function(WalletOverview) onData, {String? coinType}) async {
    if (gUserRx.value.id == 0) {
      refreshController.finishRefresh();
      return;
    }
    APIRepository().getWalletBalanceDetails(coinType ?? "").then((resp) {
      refreshController.finishRefresh();
      resp.success ? onData(WalletOverview.fromJson(resp.data)) : showToast(resp.message);
    }, onError: (err) {
      refreshController.finishRefresh();
      showToast(err.toString());
    });
  }

  void clearListView() {
    loadedPage = 0;
    hasMoreData = false;
    walletList.clear();
  }

  Future<void> getWalletList({bool isFromLoadMore = false}) async {
    if (gUserRx.value.id == 0) {
      refreshController.finishRefresh();
      return;
    }
    if (!isFromLoadMore) clearListView();
    loadedPage++;
    final search = searchController.text.trim();
    APIRepository().getWalletList(loadedPage, type: walletListFromType, search: search).then((resp) {
      refreshController.finishRefresh();
      if (resp.success) {
        ListResponse? listResponse;
        if (walletListFromType == WalletViewType.spot) {
          totalBalance.value = TotalBalance.fromJson(resp.data);
          final wallets = resp.data[APIKeyConstants.wallets];
          if (wallets != null) listResponse = ListResponse.fromJson(wallets);
        } else {
          listResponse = ListResponse.fromJson(resp.data);
        }
        if (listResponse != null) {
          loadedPage = listResponse.currentPage ?? 0;
          hasMoreData = listResponse.nextPageUrl != null;
          if (listResponse.data != null) {
            List<Wallet> list = List<Wallet>.from(listResponse.data!.map((x) => Wallet.fromJson(x)));
            walletList.addAll(list);
          }
        }
        if (walletListFromType == WalletViewType.spot) getDashBoardData();
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      refreshController.finishRefresh();
      showToast(err.toString());
    });
  }

  void getDashBoardData() async {
    if (coinPairs.isNotEmpty) return;
    APIRepository().getDashBoardData("").then((resp) {
      if (resp.success) {
        final dashboardData = DashboardData.fromJson(resp.data);
        coinPairs = dashboardData.coinPairs ?? [];
      }
    }, onError: (err) {});
  }

  List<String> getCoinPairList(String text) {
    final pairList = coinPairs.where((element) => (element.coinPairName ?? "").toLowerCase().contains(text.toLowerCase())).toList();
    return pairList.map((e) => e.coinPairName ?? "").toList();
  }

  //p2p
  // void transferAmount(Wallet wallet, double amount, bool isSend) {
  //   showLoadingDialog();
  //
  //   P2pAPIRepository().transferWalletBalance(wallet.coinType ?? "", amount, isSend ? 1 : 2).then((resp) {
  //     hideLoadingDialog();
  //     showToast(resp.message, isError: !resp.success);
  //     if (resp.success) {
  //       Get.back();
  //       Future.delayed(const Duration(seconds: 3), () => getP2pWalletsList(false));
  //     }
  //   }, onError: (err) {
  //     hideLoadingDialog();
  //     showToast(err.toString());
  //   });
  // }
  //
  // /// spot_wallet =1 or future_wallet =2
  // void transferAmount(Wallet wallet, int walletType, double amount, bool isSend) {
  //   showLoadingDialog();
  //
  //   APIRepository().futureTradeWalletBalanceTransfer(isSend ? 2 : 1, wallet.coinType ?? "", amount).then((resp) {
  //     hideLoadingDialog();
  //     showToast(resp.message, isError: !resp.success);
  //     if (resp.success) {
  //       Get.back();
  //       Future.delayed(const Duration(seconds: 2), () => getFutureWalletList(isFromLoadMore: false));
  //     }
  //   }, onError: (err) {
  //     hideLoadingDialog();
  //     showToast(err.toString());
  //   });
  // }

  void transferWalletAmount(Wallet wallet, int walletType, double amount, bool isSend) async {
    showLoadingDialog();
    try {
      ServerResponse? resp;
      if (walletType == WalletViewType.future) {
        /// spot_wallet =1 or future_wallet =2
        resp = await APIRepository().futureTradeWalletBalanceTransfer(isSend ? 2 : 1, wallet.coinType ?? "", amount);
      } else if (walletType == WalletViewType.p2p) {
        resp = await APIRepository().p2pWalletBalanceTransfer(wallet.coinType ?? "", amount, isSend ? 1 : 2);
      }
      hideLoadingDialog();
      if (resp != null) {
        showToast(resp.message, isError: !resp.success);
        if (resp.success) {
          Get.back();
          Future.delayed(const Duration(seconds: 1), () => refreshController.callRefresh());
        }
      }
    } catch (err) {
      hideLoadingDialog();
      showToast(err.toString());
    }
  }
}

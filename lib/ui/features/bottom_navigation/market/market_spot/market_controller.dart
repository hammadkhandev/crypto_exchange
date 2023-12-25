import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/list_response.dart';
import 'package:tradexpro_flutter/data/models/market_date.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/data/remote/socket_provider.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';

class MarketController extends GetxController implements SocketListener {
  RxBool isLoading = true.obs;
  RxInt selectedTab = 0.obs;
  RxInt selectedCurrency = 0.obs;
  RxList<Currency> currencyList = <Currency>[].obs;
  RxList<MarketCoin> marketCoinList = <MarketCoin>[].obs;
  Rx<MarketData> marketData = MarketData().obs;
  final searchController = TextEditingController();
  int loadedPage = 0;
  bool hasMoreData = false;
  Timer? _searchTimer;

  Map<int, String> getTypeMap() {
    var map = {1: "All Crypto".tr, 2: "Spot Markets".tr};
    if (getSettingsLocal()?.enableFutureTrade == 1) map[3] = "Future Markets".tr;
    map[4] = "New Listing".tr;
    return map;
  }

  void changeTab(int key) {
    selectedTab.value = key;
    getMarketOverviewTopCoinList(false);
  }

  void changeCurrency(int index) {
    selectedCurrency.value = index;
    getMarketOverviewCoinStatisticList();
    getMarketOverviewTopCoinList(false);
  }

  void onTextChanged(String text) {
    if (_searchTimer?.isActive ?? false) _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(seconds: 1), () => getMarketOverviewTopCoinList(false));
  }

  Future<void> getCurrencyList() async {
    APIRepository().getCurrencyList().then((resp) {
      if (resp.success) {
        currencyList.value = List<Currency>.from(resp.data.map((x) => Currency.fromJson(x)));
        selectedCurrency.value = currencyList.indexWhere((element) => element.value == DefaultValue.currency);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  Future<void> getMarketOverviewCoinStatisticList() async {
    final currency = selectedCurrency.value == -1 ? DefaultValue.currency : currencyList[selectedCurrency.value].value;
    APIRepository().getMarketOverviewCoinStatisticList(currency ?? "").then((resp) {
      if (resp.success) {
        marketData.value = MarketData.fromJson(resp.data);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  Future<void> getMarketOverviewTopCoinList(bool isLoadMore) async {
    if (!isLoadMore) {
      loadedPage = 0;
      hasMoreData = true;
      marketCoinList.clear();
    }
    isLoading.value = true;
    loadedPage++;
    final currency = selectedCurrency.value == -1 ? DefaultValue.currency : currencyList[selectedCurrency.value].value;
    final type = getTypeMap().keys.toList()[selectedTab.value];
    final query = searchController.text.trim();
    APIRepository().getMarketOverviewTopCoinList(loadedPage, currency ?? "", type, search: query).then((resp) {
      isLoading.value = false;
      if (resp.success) {
        final listResp = ListResponse.fromJson(resp.data);
        marketCoinList.value = List<MarketCoin>.from(listResp.data.map((x) => MarketCoin.fromJson(x)));
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoading.value = true;
      showToast(err.toString());
    });
  }

  @override
  void onDataGet(channel, event, data) {
    if (channel == SocketConstants.channelMarketOverviewCoinStatisticListData && event == SocketConstants.eventMarketOverviewCoinStatisticList) {
      if (data is Map<String, dynamic>) marketData.value = MarketData.fromJson(data);
    } else if (channel == SocketConstants.channelMarketOverviewTopCoinListData && event == SocketConstants.eventMarketOverviewTopCoinList) {
      if (data is Map<String, dynamic>) {
        final coin = MarketCoin.fromJson(data[APIKeyConstants.coinPairDetails]);
        findAndUpdateListData(coin);
      }
    }
  }

  void subscribeSocketChannels() {
    APIRepository().subscribeEvent(SocketConstants.channelMarketOverviewCoinStatisticListData, this);
    APIRepository().subscribeEvent(SocketConstants.channelMarketOverviewTopCoinListData, this);
  }

  void unSubscribeChannel() {
    APIRepository().unSubscribeEvent(SocketConstants.channelMarketOverviewCoinStatisticListData, this);
    APIRepository().unSubscribeEvent(SocketConstants.channelMarketOverviewTopCoinListData, this);
  }

  void findAndUpdateListData(MarketCoin? coin) {
    if (coin == null) return;
    if (marketCoinList.isNotEmpty) {
      final index = marketCoinList.indexWhere((element) => element.coinType == coin.coinType);
      if (index != 1) {
        marketCoinList[index] = coin;
        marketCoinList.refresh();
      }
    }
  }
}

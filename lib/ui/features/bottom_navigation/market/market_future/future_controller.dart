import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/future_data.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/data/remote/socket_provider.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';

class FutureController extends GetxController implements SocketListener {
  RxBool isLoading = true.obs;
  bool isLoadingList = false;
  RxString selectedTabSub = FutureMarketKey.assets.obs;
  RxList<CoinPair> coinPairList = <CoinPair>[].obs;
  Rx<FutureMarketData> marketData = FutureMarketData().obs;

  @override
  void onDataGet(channel, event, data) {
    if (channel == SocketConstants.channelFutureTradeGetExchangeMarketDetailsData && event == SocketConstants.eventMarketDetailsData) {
      marketData.value = FutureMarketData.fromJson(data);
      if (selectedTabSub.value == FutureMarketKey.assets && isLoadingList == false) coinPairList.value = marketData.value.coins ?? [];
    }
  }

  void subscribeSocketChannels() {
    APIRepository().subscribeEvent(SocketConstants.channelFutureTradeGetExchangeMarketDetailsData, this);
  }

  void unSubscribeChannel() {
    APIRepository().unSubscribeEvent(SocketConstants.channelFutureTradeGetExchangeMarketDetailsData, this);
  }

  Future<void> getFutureExchangeMarketDetail() async {
    isLoading.value = true;
    APIRepository().getFutureExchangeMarketDetail(1, FutureMarketKey.assets).then((resp) {
      if (resp.success) {
        marketData.value = FutureMarketData.fromJson(resp.data);
        coinPairList.value = marketData.value.coins ?? [];
      } else {
        showToast(resp.message);
      }
      isLoading.value = false;
      subscribeSocketChannels();
    }, onError: (err) {
      isLoading.value = false;
      showToast(err.toString());
    });
  }

  void changeSubTab(String key) {
    isLoadingList = true;
    selectedTabSub.value = key;
    getFutureCoinList();
  }

  Future<void> getFutureCoinList() async {
    APIRepository().getFutureExchangeMarketDetail(1, selectedTabSub.value).then((resp) {
      isLoadingList = false;
      if (resp.success) {
        final mData = FutureMarketData.fromJson(resp.data);
        coinPairList.value = mData.coins ?? [];
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isLoadingList = true;
      showToast(err.toString());
      coinPairList.value = [];
    });
  }
}

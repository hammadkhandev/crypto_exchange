import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/data/models/future_data.dart';
import 'package:tradexpro_flutter/data/models/response.dart';
import 'package:tradexpro_flutter/data/models/trade_info_socket.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/data/remote/socket_provider.dart';
import 'package:tradexpro_flutter/ui/features/chart/chart_controller.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';

class FutureTradeController extends GetxController implements SocketListener {
  Rx<CoinPair> selectedCoinPair = CoinPair().obs;
  Rx<FutureTradeDashboardData> futureDashboardData = FutureTradeDashboardData().obs;
  RxList<CoinPair> coinPairs = <CoinPair>[].obs;
  TextEditingController searchEditController = TextEditingController();
  final _chartController = Get.put(ChartController());
  RxString selectedOrderSort = FromKey.all.obs;
  RxList<ExchangeOrder> buyExchangeOrder = <ExchangeOrder>[].obs;
  RxList<ExchangeOrder> sellExchangeOrder = <ExchangeOrder>[].obs;
  RxList<ExchangeTrade> exchangeTrades = <ExchangeTrade>[].obs;
  RxInt selectedHistoryTabIndex = 0.obs;
  RxList<dynamic> tradeHistoryList = <dynamic>[].obs;
  RxBool isHistoryLoading = false.obs;
  double fBalance = 0;
  String channelDashboard = "";
  String channelTradeInfo = "";
  String channelMyTrade = "";

  /// *** Socket Functionality ***

  @override
  void onDataGet(channel, event, data) {
    if (channel == channelDashboard) {
      if ((event == SocketConstants.eventOrderPlace || event == SocketConstants.eventOrderRemove) && data is SocketOrderPlace) {
        if (data.orderData?.exchangePair == selectedCoinPair.value.coinPair) {
          handleOrderBookList(data.orders?.orderType, data.orders?.orders);
          futureDashboardData.value.orderData = data.orderData;
          futureDashboardData.refresh();
        }
      }
    } else if (channel == channelTradeInfo) {
      if (event == SocketConstants.eventProcess && data is SocketTradeInfo) {
        if (data.orderData?.exchangePair == selectedCoinPair.value.coinPair) {
          if (data.trades?.transactions != null) exchangeTrades.value = data.trades?.transactions ?? [];
        }
        futureDashboardData.value.lastPriceData = data.lastPriceData;
        futureDashboardData.value.pairs = data.pairs;
        futureDashboardData.value.orderData = data.orderData;
        futureDashboardData.refresh();
      }
    } else if (channel == channelMyTrade && event == SocketConstants.eventFutureTradeData && data is FutureTradeMyOrders) {
      if (selectedHistoryTabIndex.value == 0) {
        tradeHistoryList.value = data.positionOrderList ?? [];
      } else if (selectedHistoryTabIndex.value == 1) {
        tradeHistoryList.value = data.openOrderList ?? [];
      } else if (selectedHistoryTabIndex.value == 2 && data.orderHistoryList.isValid) {
        tradeHistoryList.value = data.orderHistoryList ?? [];
      } else if (selectedHistoryTabIndex.value == 3 && data.tradeHistoryList.isValid) {
        tradeHistoryList.value = data.tradeHistoryList ?? [];
      } else if (selectedHistoryTabIndex.value == 4 && data.transactionList.isValid) {
        tradeHistoryList.value = data.transactionList ?? [];
      }
    }
  }

  void subscribeCoinPairChannel() {
    if (selectedCoinPair.value.parentCoinId != null) {
      channelDashboard = "${SocketConstants.channelDashboard}${selectedCoinPair.value.parentCoinId}-${selectedCoinPair.value.childCoinId}";
      APIRepository().subscribeEvent(channelDashboard, this);
      channelTradeInfo = "${SocketConstants.channelTradeInfo}${selectedCoinPair.value.parentCoinId}-${selectedCoinPair.value.childCoinId}";
      APIRepository().subscribeEvent(channelTradeInfo, this);
      channelMyTrade =
          "${SocketConstants.channelFutureTrade}${gUserRx.value.id}-${selectedCoinPair.value.parentCoinId}-${selectedCoinPair.value.childCoinId}";
      APIRepository().subscribeEvent(channelMyTrade, this);
    }
  }

  void unSubscribeChannel(bool isDispose) {
    if (channelDashboard.isValid) APIRepository().unSubscribeEvent(channelDashboard, isDispose ? this : null);
    if (channelTradeInfo.isValid) APIRepository().unSubscribeEvent(channelTradeInfo, isDispose ? this : null);
    if (channelMyTrade.isValid) APIRepository().unSubscribeEvent(channelMyTrade, isDispose ? this : null);
    channelTradeInfo = "";
    channelMyTrade = "";
    channelDashboard = "";
  }

  // API Functionality
  void getFutureTradeData() {
    showLoadingDialog();
    unSubscribeChannel(false);
    APIRepository().getFutureTradeAppDashboard(selectedCoinPair.value.getCoinPairKey()).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        futureDashboardData.value = FutureTradeDashboardData.fromJson(resp.data);
        /// updateSelfBalance(dashboardData.value.orderData);
        if (selectedCoinPair.value.coinPair == null) {
          final exPair = futureDashboardData.value.orderData?.exchangePair ?? "";
          fBalance = futureDashboardData.value.orderData?.total?.baseWallet?.balance ?? 0;
          if (exPair.isNotEmpty) {
            selectedCoinPair.value = (futureDashboardData.value.pairs ?? []).firstWhere((element) => element.coinPair == exPair);
          }
        }
        _chartController.selectedCoinPairDBoard.value = selectedCoinPair.value;
        _chartController.getChartDataAppDBoard();
        Future.delayed(const Duration(milliseconds: 100), () {
          getExchangeOrderList(FromKey.sell);
          getExchangeOrderList(FromKey.buy);
        });
        Future.delayed(const Duration(milliseconds: 250), () => getFutureTradeHistoryList(0));
        Future.delayed(const Duration(milliseconds: 500), () => getFutureExchangeTradeList());

        subscribeCoinPairChannel();
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void getCoinPairList(String searchText) {
    if (searchText.isEmpty) {
      coinPairs.value = futureDashboardData.value.pairs ?? [];
    } else {
      searchText = searchText.toLowerCase();
      final list =
          (futureDashboardData.value.pairs ?? []).where((element) => (element.coinPairName ?? "").toLowerCase().contains(searchText)).toList();
      coinPairs.value = list;
    }
  }

  void getExchangeOrderList(String type) {
    APIRepository()
        .getExchangeOrderList(type, futureDashboardData.value.orderData?.baseCoinId ?? 0, futureDashboardData.value.orderData?.tradeCoinId ?? 0)
        .then((resp) {
      if (resp.success) {
        var list = List<ExchangeOrder>.from(resp.data[APIKeyConstants.orders].map((x) => ExchangeOrder.fromJson(x)));
        handleOrderBookList(resp.data[APIKeyConstants.orderType], list);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void handleOrderBookList(String? type, List<ExchangeOrder>? list) {
    if (list != null) {
      if (type == FromKey.sell) {
        list = list.reversed.toList();
        sellExchangeOrder.value = (list.length >= 15) ? list.sublist(0, 15) : list;
      } else {
        buyExchangeOrder.value = (list.length >= 15) ? list.sublist(0, 15) : list;
      }
    }
  }

  void selectCoinPair(CoinPair coinPair) {
    selectedCoinPair.value = coinPair;
    getFutureTradeData();
  }

  int getListLength(List<ExchangeOrder> list) {
    int length = selectedOrderSort.value == FromKey.all ? DefaultValue.listLimitOrderBook ~/ 2 : DefaultValue.listLimitOrderBook;
    length = list.length < length ? list.length : length;
    return length;
  }

  void getFutureExchangeTradeList() {
    APIRepository()
        .getFutureTradeExchangeMarketTradesApp(
            futureDashboardData.value.orderData?.baseCoinId ?? 0, futureDashboardData.value.orderData?.tradeCoinId ?? 0)
        .then((resp) {
      if (resp.success) {
        final list = List<ExchangeTrade>.from(resp.data[APIKeyConstants.transactions].map((x) => ExchangeTrade.fromJson(x)));
        exchangeTrades.value = list;
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  void getFutureTradeHistoryList(int selectedTab) async {
    if (gUserRx.value.id == 0) return;
    tradeHistoryList.clear();
    isHistoryLoading.value = true;
    final orderData = futureDashboardData.value.orderData;

    try {
      ServerResponse? resp;
      if (selectedTab == 0) {
        resp = await APIRepository().getFutureTradeLongShortPositionOrderList(orderData?.baseCoinId ?? 0, orderData?.tradeCoinId ?? 0);
      } else if (selectedTab == 1) {
        resp = await APIRepository().getFutureTradeLongShortOpenOrderList(orderData?.baseCoinId ?? 0, orderData?.tradeCoinId ?? 0);
      } else if (selectedTab == 2) {
        resp = await APIRepository().getFutureTradeLongShortOrderHistory(orderData?.baseCoinId ?? 0, orderData?.tradeCoinId ?? 0);
      } else if (selectedTab == 3) {
        resp = await APIRepository().getFutureTradeLongShortTradeHistory(orderData?.baseCoinId ?? 0, orderData?.tradeCoinId ?? 0);
      } else if (selectedTab == 4) {
        resp = await APIRepository().getFutureTradeLongShortTransactionHistory(selectedCoinPair.value.coinPairId ?? 0);
      }
      isHistoryLoading.value = false;
      if (resp?.success ?? false) {
        if (selectedTab == 4) {
          final list = List<FutureTransaction>.from(resp?.data.map((x) => FutureTransaction.fromJson(x)));
          tradeHistoryList.value = list;
        } else {
          final list = List<FutureTrade>.from(resp?.data.map((x) => FutureTrade.fromJson(x)));
          tradeHistoryList.value = list;
        }
      } else {
        showToast(resp?.message ?? "");
      }
    } catch (err) {
      isHistoryLoading.value = false;
      showToast(err.toString());
    }
  }

  void updateProfitLossLongShortOrder(FutureTrade trade, double takeProfit, double stopLoss) {
    showLoadingDialog();
    APIRepository().futureTradeUpdateProfitLossLongShortOrder(trade.uid ?? "", takeProfit, stopLoss).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) Get.back();
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void getFutureTradeTakeProfitStopLossDetails(FutureTrade trade, Function(FutureTrade) onSuccess) async {
    APIRepository().getFutureTradeTakeProfitStopLossDetails(trade.uid ?? "").then((resp) {
      if (resp.success) {
        final newTrade = FutureTrade.fromJson(resp.data);
        onSuccess(newTrade);
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
    });
  }

  void canceledLongShortOrder(FutureTrade trade) {
    showLoadingDialog();
    APIRepository().futureTradeCanceledLongShortOrder(trade.uid ?? "").then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) {
        Get.back();
        tradeHistoryList.remove(trade);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void closeLongShortAllOrders() {
    showLoadingDialog();
    List<Map> dataList = [];
    for (final trade in tradeHistoryList) {
      if (trade is FutureTrade) {
        Map<String, dynamic> dataMap = {};
        dataMap[APIKeyConstants.orderId] = trade.id;
        dataMap[APIKeyConstants.orderType] = trade.isLimitLocal == 1 ? OrderType.limit : OrderType.market;
        if (trade.isLimitLocal == 1) dataMap[APIKeyConstants.price] = trade.profitLossCalculation?.marketPrice;
        dataMap[APIKeyConstants.side] = trade.side;
        dataList.add(dataMap);
      }
    }
    APIRepository().futureTradeCloseLongShortAllOrders(selectedCoinPair.value.coinPairId ?? 0, dataList).then((resp) {
      hideLoadingDialog();
      showToast(resp.message, isError: !resp.success);
      if (resp.success) {
        Get.back();
        //tradeHistoryList.remove(trade);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void prePlaceOrderData(CreateTrade trade, Function(FTPreOrderData?) onData) async {
    trade.coinPairId = selectedCoinPair.value.coinPairId ?? 0;
    APIRepository().futureTradePrePlaceOrderData(trade).then((resp) {
      if (resp.success) {
        final preData = FTPreOrderData.fromJson(resp.data);
        onData(preData);
      } else {
        onData(null);
      }
    }, onError: (err) {
      onData(null);
    });
  }

  void handlePlaceBuySellOrder(CreateTrade trade, bool? isBuy) async {
    showLoadingDialog();
    trade.coinPairId = selectedCoinPair.value.coinPairId ?? 0;
    try {
      ServerResponse? resp;
      if (trade.tradeType == FutureTradeType.close) {
        resp = await APIRepository().futureTradePlaceCloseLongShortOrder(trade);
      } else if (trade.tradeType == FutureTradeType.open && isBuy == true) {
        resp = await APIRepository().futureTradePlacedBuyOrder(trade);
      } else if (trade.tradeType == FutureTradeType.open && isBuy == false) {
        resp = await APIRepository().futureTradePlacedSellOrder(trade);
      }
      hideLoadingDialog();
      showToast(resp?.message ?? "", isError: !(resp?.success ?? false), isLong: true);
      // if (resp?.success ?? false) Get.back();
    } catch (error) {
      hideLoadingDialog();
      showToast(error.toString());
    }
  }
}

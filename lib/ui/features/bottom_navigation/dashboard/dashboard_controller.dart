import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/exchange_order.dart';
import 'package:tradexpro_flutter/data/models/trade_info_socket.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/data/remote/socket_provider.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/ui/features/chart/chart_controller.dart';

class DashboardController extends GetxController implements SocketListener {
  Rx<DashboardData> dashboardData = DashboardData().obs;
  Rx<SelfBalance> selfBalance = SelfBalance().obs;
  Rx<CoinPair> selectedCoinPair = CoinPair().obs;
  RxList<CoinPair> coinPairs = <CoinPair>[].obs;
  RxList<ExchangeOrder> buyExchangeOrder = <ExchangeOrder>[].obs;
  RxList<ExchangeOrder> sellExchangeOrder = <ExchangeOrder>[].obs;
  RxList<ExchangeTrade> exchangeTrades = <ExchangeTrade>[].obs;
  RxList<Trade> tradeHistoryList = <Trade>[].obs;
  TextEditingController searchEditController = TextEditingController();
  RxString selectedOrderSort = FromKey.all.obs;
  RxBool isHistoryLoading = false.obs;
  String tradeHistoryListType = "";
  final _chartController = Get.put(ChartController());
  String channelTradeInfo = "";
  String channelUserTrades = "";
  String channelDashboard = "";

  @override
  void onDataGet(channel, event, data) {
    if (channel == channelDashboard) {
      if ((event == SocketConstants.eventOrderPlace || event == SocketConstants.eventOrderRemove) && data is SocketOrderPlace) {
        if (data.orderData?.exchangePair == selectedCoinPair.value.coinPair) {
          handleOrderBookList(data.orders?.orderType, data.orders?.orders);
          dashboardData.value.orderData = data.orderData;
          dashboardData.refresh();
        }
      } else {
        final selfEvent = "${SocketConstants.eventOrderPlace}_${gUserRx.value.id}";
        if (event == selfEvent && data is SocketUserHistory) {
          updateSelfBalance(dashboardData.value.orderData);
          List<Trade>? list;
          if (tradeHistoryListType == FromKey.buy) {
            list = data.openOrders?.buyOrders;
          } else if (tradeHistoryListType == FromKey.sell) {
            list = data.openOrders?.sellOrders;
          } else if (tradeHistoryListType == FromKey.buySell) {
            list = data.openOrders?.orders;
          }
          if (list != null) {
            tradeHistoryList.value = (list.length >= 5) ? list.sublist(0, 5) : list;
          }
        }
      }
    } else if (channel == channelTradeInfo) {
      if (event == SocketConstants.eventProcess && data is SocketTradeInfo) {
        if (data.orderData?.exchangePair == selectedCoinPair.value.coinPair) {
          if (data.trades?.transactions != null) exchangeTrades.value = data.trades?.transactions ?? [];
        }
        dashboardData.value.lastPriceData = data.lastPriceData;
        dashboardData.value.coinPairs = data.pairs;
        dashboardData.value.orderData = data.orderData;
        dashboardData.refresh();
      }
    }

    ///_chartController.updateChart(data);
  }

  void subscribeCoinPairChannel() {
    if (selectedCoinPair.value.parentCoinId != null) {
      channelDashboard = "${SocketConstants.channelDashboard}${selectedCoinPair.value.parentCoinId}-${selectedCoinPair.value.childCoinId}";
      APIRepository().subscribeEvent(channelDashboard, this);
      channelTradeInfo = "${SocketConstants.channelTradeInfo}${selectedCoinPair.value.parentCoinId}-${selectedCoinPair.value.childCoinId}";
      APIRepository().subscribeEvent(channelTradeInfo, this);
    }
  }

  void unSubscribeChannel(bool isDispose) {
    if (channelDashboard.isValid) APIRepository().unSubscribeEvent(channelDashboard, isDispose ? this : null);
    if (channelTradeInfo.isValid) APIRepository().unSubscribeEvent(channelTradeInfo, isDispose ? this : null);
    if (channelUserTrades.isValid) APIRepository().unSubscribeEvent(channelUserTrades, isDispose ? this : null);
    channelTradeInfo = "";
    channelUserTrades = "";
    channelDashboard = "";
  }

  void getDashBoardData() {
    showLoadingDialog();
    unSubscribeChannel(false);
    APIRepository().getDashBoardData(selectedCoinPair.value.coinPair ?? "").then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        dashboardData.value = DashboardData.fromJson(resp.data);
        updateSelfBalance(dashboardData.value.orderData);
        if (selectedCoinPair.value.coinPair == null) {
          final exPair = dashboardData.value.orderData?.exchangePair ?? "";
          if (exPair.isNotEmpty) {
            selectedCoinPair.value = (dashboardData.value.coinPairs ?? []).firstWhere((element) => element.coinPair == exPair);
          }
        }
        _chartController.selectedCoinPairDBoard.value = selectedCoinPair.value;
        _chartController.getChartDataAppDBoard();
        Future.delayed(const Duration(milliseconds: 100), () {
          getExchangeOrderList(FromKey.sell);
          getExchangeOrderList(FromKey.buy);
        });
        Future.delayed(const Duration(milliseconds: 250), () => getTradeHistoryList(FromKey.buySell));
        Future.delayed(const Duration(milliseconds: 500), () => getExchangeTradeList());

        subscribeCoinPairChannel();
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void updateSelfBalance(OrderData? orderData) {
    selfBalance.value.total = orderData?.total;
    selfBalance.value.buyPrice = orderData?.buyPrice;
    selfBalance.value.sellPrice = orderData?.sellPrice;
    selfBalance.refresh();
  }

  void getExchangeOrderList(String type) {
    APIRepository().getExchangeOrderList(type, dashboardData.value.orderData?.baseCoinId ?? 0, dashboardData.value.orderData?.tradeCoinId ?? 0).then(
        (resp) {
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

  int getListLength(List<ExchangeOrder> list) {
    int length = selectedOrderSort.value == FromKey.all ? DefaultValue.listLimitOrderBook ~/ 2 : DefaultValue.listLimitOrderBook;
    length = list.length < length ? list.length : length;
    return length;
  }

  void getExchangeTradeList() {
    APIRepository().getExchangeTradeList(dashboardData.value.orderData?.baseCoinId ?? 0, dashboardData.value.orderData?.tradeCoinId ?? 0).then(
        (resp) {
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

  void getTradeHistoryList(String orderType) {
    if (gUserRx.value.id == 0) return;
    isHistoryLoading.value = true;
    tradeHistoryListType = orderType;
    tradeHistoryList.clear();
    final orderData = dashboardData.value.orderData;
    APIRepository().getTradeHistoryList(orderData?.baseCoinId ?? 0, orderData?.tradeCoinId ?? 0, orderType).then((resp) {
      isHistoryLoading.value = false;
      if (resp.success) {
        final key = orderType == FromKey.trade ? APIKeyConstants.transactions : APIKeyConstants.orders;
        final list = List<Trade>.from(resp.data[key].map((x) => Trade.fromJson(x)));
        tradeHistoryList.value = (list.length >= 5) ? list.sublist(0, 5) : list;
      } else {
        showToast(resp.message);
      }
    }, onError: (err) {
      isHistoryLoading.value = false;
      showToast(err.toString());
    });
  }

  void getCoinPairList(String searchText) {
    if (searchText.isEmpty) {
      coinPairs.value = dashboardData.value.coinPairs ?? [];
    } else {
      searchText = searchText.toLowerCase();
      final list = (dashboardData.value.coinPairs ?? []).where((element) => (element.coinPairName ?? "").toLowerCase().contains(searchText)).toList();
      coinPairs.value = list;
    }
  }

  /// *** PLACE ORDER *** ///

  void placeOrderLimit(bool isBuy, int baseCoinId, int tradeCoinId, double price, double amount, Function() onSuccess) {
    showLoadingDialog();
    APIRepository().placeOrderLimit(isBuy, baseCoinId, tradeCoinId, price, amount).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.status] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) onSuccess();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void placeOrderMarket(bool isBuy, int baseCoinId, int tradeCoinId, double price, double amount, Function() onSuccess) {
    showLoadingDialog();
    APIRepository().placeOrderMarket(isBuy, baseCoinId, tradeCoinId, price, amount).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.status] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) onSuccess();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void placeOrderStopMarket(bool isBuy, int baseCoinId, int tradeCoinId, double amount, double limit, double stop, Function() onSuccess) {
    showLoadingDialog();
    APIRepository().placeOrderStopMarket(isBuy, baseCoinId, tradeCoinId, amount, limit, stop).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.status] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) onSuccess();
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }

  void cancelOpenOrderApp(Trade trade) {
    showLoadingDialog();
    APIRepository().cancelOpenOrderApp(trade.type ?? "", trade.id ?? 0).then((resp) {
      hideLoadingDialog();
      if (resp.success) {
        final success = resp.data[APIKeyConstants.status] as bool? ?? false;
        final message = resp.data[APIKeyConstants.message] as String? ?? "";
        showToast(message, isError: !success);
        if (success) getTradeHistoryList(tradeHistoryListType);
      }
    }, onError: (err) {
      hideLoadingDialog();
      showToast(err.toString());
    });
  }
}

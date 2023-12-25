import 'package:candlesticks/candlesticks.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/trade_info_socket.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

class ChartController extends GetxController {
  Map<int, String> getIntervalMap() => {5: "5m".tr, 15: "15m".tr, 30: "30m".tr, 120: "1h".tr, 240: '4h'.tr, 1440: '1d'.tr};

  /// *** CHART *** ///
  RxList<Candle> candles = <Candle>[].obs;
  RxInt intervalIndex = 0.obs;
  Rx<CoinPair> selectedCoinPair = CoinPair().obs;
  RxBool noDataFound = false.obs;

  void getChartDataApp() {
    final interval = getIntervalMap().keys.toList()[intervalIndex.value];
    candles.value = [];
    APIRepository().getExchangeChartDataApp(selectedCoinPair.value.parentCoinId ?? 0, selectedCoinPair.value.childCoinId ?? 0, interval).then((resp) {
      if (resp.success) {
        final list = List<Candle>.from(resp.data.map((x) => getCandle(x)));
        noDataFound.value = list.isEmpty;
        candles.value = list;
      }
    }, onError: (err) {
      showToast(err.toString());
    });
  }

  /// *** DASHBOARD CHART *** ///
  RxList<Candle> candlesDBoard = <Candle>[].obs;
  RxInt intervalIndexDBoard = 0.obs;
  Rx<CoinPair> selectedCoinPairDBoard = CoinPair().obs;
  RxBool noDataFoundDBoard = false.obs;

  Future<void> getChartDataAppDBoard() async {
    final interval = getIntervalMap().keys.toList()[intervalIndexDBoard.value];
    candlesDBoard.value = [];
    APIRepository()
        .getExchangeChartDataApp(selectedCoinPairDBoard.value.parentCoinId ?? 0, selectedCoinPairDBoard.value.childCoinId ?? 0, interval)
        .then((resp) {
      if (resp.success) {
        final list = List<Candle>.from(resp.data.map((x) => getCandle(x)));
        noDataFoundDBoard.value = list.isEmpty;
        candlesDBoard.value = list.reversed.toList();
      }
    }, onError: (err) {
      showToast(err.toString());
    });

    // //import 'package:http/http.dart' as http;
    // final uri = Uri.parse("https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=5m");
    // final res = await http.get(uri);
    // final list = (jsonDecode(res.body) as List<dynamic>).map((e) => Candle.fromJson(e)).toList().reversed.toList();
    // candlesDBoard.value = list;
  }

  void updateChart(SocketTradeInfo infoSocket) {
    //print("candles >> infoSocket");
    if (candlesDBoard.isEmpty) return;
    final date = getDateWithTime(infoSocket.lastTrade?.time);
    if(date == null) return;
    //print("candles >> date");
    final price = makeDouble(infoSocket.lastTrade?.price);
    final total = makeDouble(infoSocket.lastTrade?.total);
    final lastBar = candlesDBoard[0];
    double low = 0, high = 0;

    if (price < lastBar.low) {
      low = price;
      high = lastBar.high;
    } else if (price > lastBar.high) {
      high = price;
      low = lastBar.low;
    }
    var newBar = Candle(date: date, high: high, low: low, open: lastBar.open, close: price, volume: lastBar.volume+total);
    candlesDBoard.insert(0, newBar);
    // if (lastBar.date == newBar.date && lastBar.open == newBar.open) {
    //   print("candles >> update");
    //   candlesDBoard[0] = newBar;
    // } else if (newBar.date.difference(lastBar.date) == lastBar.date.difference(candlesDBoard[1].date)) {
    //   print("candles >> insert");
    //   candlesDBoard.insert(0, newBar);
    // }
  }

  // void updateChart(TradeInfoSocket infoSocket) {
  //   print("candles >> infoSocket");
  //   if (candlesDBoard.isEmpty) return;
  //   final date = getDateWithTime(infoSocket.lastTrade?.time);
  //   if(date == null) return;
  //   print("candles >> date");
  //   final price = makeDouble(infoSocket.lastTrade?.price);
  //   final total = makeDouble(infoSocket.lastTrade?.total);
  //   final lastBar = candlesDBoard[0];
  //   double low = 0, high = 0;
  //
  //   if (price < lastBar.low) {
  //     low = price;
  //     high = lastBar.high;
  //   } else if (price > lastBar.high) {
  //     high = price;
  //     low = lastBar.low;
  //   }
  //   var newBar = Candle(date: date, high: high, low: low, open: lastBar.open, close: price, volume: lastBar.volume+total);
  //   candlesDBoard.insert(0, newBar);
  //   // if (lastBar.date == newBar.date && lastBar.open == newBar.open) {
  //   //   print("candles >> update");
  //   //   candlesDBoard[0] = newBar;
  //   // } else if (newBar.date.difference(lastBar.date) == lastBar.date.difference(candlesDBoard[1].date)) {
  //   //   print("candles >> insert");
  //   //   candlesDBoard.insert(0, newBar);
  //   // }
  // }
}

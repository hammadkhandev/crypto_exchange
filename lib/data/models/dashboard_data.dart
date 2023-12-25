import 'dart:convert';
import 'package:tradexpro_flutter/utils/number_util.dart';

class DashboardData {
  DashboardData({
    this.title,
    this.coinPairs,
    this.orderData,
    this.feesSettings,
    this.lastPriceData,
    this.broadcastPort,
    this.appKey,
    this.cluster,
  });

  String? title;
  List<CoinPair>? coinPairs;
  OrderData? orderData;
  Fees? feesSettings;
  List<PriceData>? lastPriceData;
  String? broadcastPort;
  String? appKey;
  String? cluster;

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        title: json["title"],
        broadcastPort: json["broadcast_port"],
        appKey: json["app_key"],
        cluster: json["cluster"],
        coinPairs: json["pairs"] == null ? null : List<CoinPair>.from(json["pairs"].map((x) => CoinPair.fromJson(x))),
        orderData: json["order_data"] == null ? null : OrderData.fromJson(json["order_data"]),
        feesSettings: json["fees_settings"] is Map<String, dynamic> ? Fees.fromJson(json["fees_settings"]) : null,
        lastPriceData: json["last_price_data"] == null ? null : List<PriceData>.from(json["last_price_data"].map((x) => PriceData.fromJson(x))),
      );
}

class Fees {
  Fees({
    this.makerFees,
    this.takerFees,
    this.thirtyDayVolume,
  });

  double? makerFees;
  double? takerFees;
  String? thirtyDayVolume;

  factory Fees.fromJson(Map<String, dynamic> json) => Fees(
        makerFees: makeDouble(json["maker_fees"]),
        takerFees: makeDouble(json["taker_fees"]),
        thirtyDayVolume: json["thirtyDayVolume"],
      );

  Map<String, dynamic> toJson() => {
        "maker_fees": makerFees,
        "taker_fees": takerFees,
        "thirtyDayVolume": thirtyDayVolume,
      };
}

class PriceData {
  PriceData({
    this.amount,
    this.price,
    this.lastPrice,
    this.priceOrderType,
    this.total,
    this.time,
  });

  double? amount;
  double? price;
  double? lastPrice;
  double? total;

  String? priceOrderType;
  String? time;

  factory PriceData.fromJson(Map<String, dynamic> json) => PriceData(
        amount: makeDouble(json["amount"]),
        price: makeDouble(json["price"]),
        lastPrice: makeDouble(json["last_price"]),
        priceOrderType: json["price_order_type"],
        total: makeDouble(json["total"]),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "price": price,
        "last_price": lastPrice,
        "price_order_type": priceOrderType,
        "total": total,
        "time": time,
      };
}

class OrderData {
  OrderData({
    this.baseCoinId,
    this.tradeCoinId,
    this.total,
    this.fees,
    this.onOrder,
    this.sellPrice,
    this.buyPrice,
    this.baseCoin,
    this.tradeCoin,
    this.exchangePair,
    this.exchangeCoinPair,
  });

  int? baseCoinId;
  int? tradeCoinId;
  Total? total;
  Fees? fees;
  OnOrder? onOrder;
  double? sellPrice;
  double? buyPrice;
  String? baseCoin;
  String? tradeCoin;
  String? exchangePair;
  String? exchangeCoinPair;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        baseCoinId: json["base_coin_id"],
        tradeCoinId: json["trade_coin_id"],
        total: Total.fromJson(json["total"]),
        fees: json["fees"] is Map<String, dynamic> ? Fees.fromJson(json["fees"]) : null,
        onOrder: json["on_order"] == null ? null : OnOrder.fromJson(json["on_order"]),
        sellPrice: makeDouble(json["sell_price"]),
        buyPrice: makeDouble(json["buy_price"]),
        baseCoin: json["base_coin"],
        tradeCoin: json["trade_coin"],
        exchangePair: json["exchange_pair"],
        exchangeCoinPair: json["exchange_coin_pair"],
      );

  Map<String, dynamic> toJson() => {
        "base_coin_id": baseCoinId,
        "trade_coin_id": tradeCoinId,
        "total": total?.toJson(),
        "fees": fees?.toJson(),
        "on_order": onOrder?.toJson(),
        "sell_price": sellPrice,
        "buy_price": buyPrice,
        "base_coin": baseCoin,
        "trade_coin": tradeCoin,
        "exchange_pair": exchangePair,
        "exchange_coin_pair": exchangeCoinPair,
      };
}

class OnOrder {
  OnOrder({
    this.tradeWallet,
    this.baseWallet,
  });

  double? tradeWallet;
  double? baseWallet;

  factory OnOrder.fromJson(Map<String, dynamic> json) => OnOrder(
        tradeWallet: makeDouble(json["trade_wallet"]),
        baseWallet: makeDouble(json["base_wallet"]),
      );

  Map<String, dynamic> toJson() => {
        "trade_wallet": tradeWallet,
        "base_wallet": baseWallet,
      };
}

class Total {
  Total({
    this.tradeWallet,
    this.baseWallet,
  });

  TradeWallet? tradeWallet;
  TradeWallet? baseWallet;

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        tradeWallet: TradeWallet.fromJson(json["trade_wallet"]),
        baseWallet: TradeWallet.fromJson(json["base_wallet"]),
      );

  Map<String, dynamic> toJson() => {
        "trade_wallet": tradeWallet?.toJson(),
        "base_wallet": baseWallet?.toJson(),
      };
}

class TradeWallet {
  TradeWallet({
    this.balance,
    this.coinType,
    this.fullName,
    this.high,
    this.low,
    this.volume,
    this.lastPrice,
    this.priceChange,
  });

  double? balance;
  String? coinType;
  String? fullName;
  double? high;
  double? low;
  double? volume;
  double? lastPrice;
  double? priceChange;

  factory TradeWallet.fromJson(Map<String, dynamic> json) => TradeWallet(
        balance: makeDouble(json["balance"]),
        coinType: json["coin_type"],
        fullName: json["full_name"],
        high: makeDouble(json["high"]),
        low: makeDouble(json["low"]),
        volume: makeDouble(json["volume"]),
        lastPrice: makeDouble(json["last_price"]),
        priceChange: makeDouble(json["price_change"]),
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "coin_type": coinType,
        "full_name": fullName,
        "high": high,
        "low": low,
        "volume": volume,
        "last_price": lastPrice,
        "price_change": priceChange,
      };
}

class CoinPair {
  CoinPair({
    this.coinPairName,
    this.coinPair,
    this.coinPairId,
    this.parentCoinId,
    this.childCoinId,
    this.lastPrice,
    this.priceChange,
    this.childCoinName,
    this.icon,
    this.parentCoinName,
    this.userId,
    this.balance,
    this.estBalance,
    this.isFavorite,
    this.high,
    this.low,
    this.volume,
  });

  String? coinPairName;
  String? coinPair;
  int? coinPairId;
  int? parentCoinId;
  int? childCoinId;
  String? childCoinName;
  String? icon;
  String? parentCoinName;
  int? userId;

  String? estBalance;
  int? isFavorite;
  String? high;
  String? low;
  String? lastPrice;
  double? priceChange;
  double? balance;
  double? volume;

  factory CoinPair.fromJson(Map<String, dynamic> json) => CoinPair(
        coinPairName: json["coin_pair_name"],
        coinPair: json["coin_pair"],
        coinPairId: json["coin_pair_id"],
        parentCoinId: json["parent_coin_id"],
        childCoinId: json["child_coin_id"],
        lastPrice: json["last_price"],
        priceChange: makeDouble(json["price_change"]),
        childCoinName: json["child_coin_name"],
        icon: json["icon"] ?? json["coin_icon"],
        parentCoinName: json["parent_coin_name"],
        userId: makeInt(json["user_id"]),
        balance: makeDouble(json["balance"]),
        estBalance: json["est_balance"],
        isFavorite: json["is_favorite"],
        high: json["high"],
        low: json["low"],
        volume: makeDouble(json["volume"]),
      );

  String getCoinPairName() => "${childCoinName ?? ""}/${parentCoinName ?? ""}";

  String getCoinPairKey() => "${childCoinName ?? ""}_${parentCoinName ?? ""}";
}

// final chartData = chartDataFromJson(jsonString);
ChartData chartDataFromJson(String str) => ChartData.fromJson(json.decode(str));

String chartDataToJson(ChartData data) => json.encode(data.toJson());

class ChartData {
  ChartData({
    required this.time,
    required this.low,
    required this.high,
    required this.open,
    required this.close,
    required this.volume,
  });

  int time;
  double low;
  double high;
  double open;
  double close;
  double volume;

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        time: json["time"] ?? 0,
        low: makeDouble(json["low"]),
        high: makeDouble(json["high"]),
        open: makeDouble(json["open"]),
        close: makeDouble(json["close"]),
        volume: makeDouble(json["volume"]),
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "low": low,
        "high": high,
        "open": open,
        "close": close,
        "volume": volume,
      };
}

class SelfBalance {
  SelfBalance({
    this.total,
    this.sellPrice,
    this.buyPrice,
  });

  Total? total;
  double? sellPrice;
  double? buyPrice;
}

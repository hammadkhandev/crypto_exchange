import 'package:tradexpro_flutter/utils/number_util.dart';

class MarketCoin {
  int? id;
  int? coinId;
  double? volume;
  double? change;
  double? high;
  double? low;
  double? price;
  double? totalBalance;
  double? usdtPrice;
  String? coinType;
  String? coinIcon;
  String? currencySymbol;
  DateTime? coinCreatedAt;
  DateTime? coinPairUpdatedAt;
  DateTime? createdAt;

  MarketCoin({
    this.id,
    this.volume,
    this.change,
    this.high,
    this.low,
    this.price,
    this.createdAt,
    this.coinType,
    this.coinId,
    this.totalBalance,
    this.coinIcon,
    this.usdtPrice,
    this.coinCreatedAt,
    this.coinPairUpdatedAt,
    this.currencySymbol,
  });

  factory MarketCoin.fromJson(Map<String, dynamic> json) => MarketCoin(
        id: json["id"],
        volume: makeDouble(json["volume"]),
        change: makeDouble(json["change"]),
        high: makeDouble(json["high"]),
        low: makeDouble(json["low"]),
        price: makeDouble(json["price"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        coinType: json["coin_type"],
        coinId: json["coin_id"],
        totalBalance: makeDouble(json["total_balance"]),
        coinIcon: json["coin_icon"],
        usdtPrice: makeDouble(json["usdt_price"]),
        coinCreatedAt: json["coin_created_at"] == null ? null : DateTime.parse(json["coin_created_at"]),
        coinPairUpdatedAt: json["coin_pair_updated_at"] == null ? null : DateTime.parse(json["coin_pair_updated_at"]),
        currencySymbol: json["currency_symbol"],
      );
}

class MarketData {
  List<MarketCoin>? highlightCoin;
  List<MarketCoin>? newListing;
  List<MarketCoin>? topGainerCoin;
  List<MarketCoin>? topVolumeCoin;

  MarketData({
    this.highlightCoin,
    this.newListing,
    this.topGainerCoin,
    this.topVolumeCoin,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) => MarketData(
        highlightCoin: json["highlight_coin"] == null ? null : List<MarketCoin>.from(json["highlight_coin"].map((x) => MarketCoin.fromJson(x))),
        newListing: json["new_listing"] == null ? null : List<MarketCoin>.from(json["new_listing"].map((x) => MarketCoin.fromJson(x))),
        topGainerCoin: json["top_gainer_coin"] == null ? null : List<MarketCoin>.from(json["top_gainer_coin"].map((x) => MarketCoin.fromJson(x))),
        topVolumeCoin: json["top_volume_coin"] == null ? null : List<MarketCoin>.from(json["top_volume_coin"].map((x) => MarketCoin.fromJson(x))),
      );
}

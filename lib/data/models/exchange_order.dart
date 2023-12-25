import 'dart:convert';

import 'package:tradexpro_flutter/utils/number_util.dart';

///final exchangeOrder = exchangeOrderFromJson(jsonString);
ExchangeOrder exchangeOrderFromJson(String str) => ExchangeOrder.fromJson(json.decode(str));

String exchangeOrderToJson(ExchangeOrder data) => json.encode(data.toJson());

class ExchangeOrder {
  ExchangeOrder({
    this.createdAt,
    this.status,
    this.processed,
    this.price,
    this.amount,
    this.total,
    this.mySize,
    this.percentage,
    this.isFavorite,
  });

  DateTime? createdAt;
  int? status;
  double? processed;
  double? price;
  double? amount;
  double? total;
  double? mySize;
  double? percentage;
  dynamic isFavorite;

  factory ExchangeOrder.fromJson(Map<String, dynamic> json) => ExchangeOrder(
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        status: json["status"],
        processed: makeDouble(json["processed"]),
        price: makeDouble(json["price"]),
        amount: makeDouble(json["amount"]),
        total: makeDouble(json["total"]),
        mySize: makeDouble(json["my_size"]),
        percentage: makeDouble(json["percentage"]),
        isFavorite: json["is_favorite"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "status": status,
        "processed": processed,
        "price": price,
        "amount": amount,
        "total": total,
        "my_size": mySize,
        "percentage": percentage,
        "is_favorite": isFavorite,
      };
}

///final exchangeTrade = exchangeTradeFromJson(jsonString);

ExchangeTrade exchangeTradeFromJson(String str) => ExchangeTrade.fromJson(json.decode(str));

String exchangeTradeToJson(ExchangeTrade data) => json.encode(data.toJson());

class ExchangeTrade {
  ExchangeTrade({
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
  String? priceOrderType;
  double? total;
  String? time;

  factory ExchangeTrade.fromJson(Map<String, dynamic> json) => ExchangeTrade(
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

class Trade {
  Trade({
    this.type,
    this.id,
    this.transactionId,
    this.price,
    this.createdAt,
    this.actualAmount,
    this.processed,
    this.status,
    this.actualTotal,
    this.amount,
    this.total,
    this.fees,
    this.baseCoin,
    this.tradeCoin,
    this.deletedAt,
    this.lastPrice,
    this.priceOrderType,
    this.time,
  });

  String? type;
  int? id;
  String? transactionId;
  int? status;
  DateTime? createdAt;
  DateTime? deletedAt;
  double? actualAmount;
  double? processed;
  double? actualTotal;
  double? amount;
  double? total;
  double? fees;
  double? price;
  String? baseCoin;
  String? tradeCoin;
  double? lastPrice;
  String? priceOrderType;
  String? time;

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
        type: json["type"] ?? json["order_type"],
        id: json["id"],
        transactionId: json["transaction_id"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        actualAmount: makeDouble(json["actual_amount"]),
        processed: makeDouble(json["processed"]),
        price: makeDouble(json["price"]),
        actualTotal: makeDouble(json["actual_total"]),
        amount: makeDouble(json["amount"]),
        total: makeDouble(json["total"]),
        fees: makeDouble(json["fees"]),
        baseCoin: json["base_coin"],
        tradeCoin: json["trade_coin"],
        lastPrice: makeDouble(json["last_price"]),
        priceOrderType: json["price_order_type"],
        time: json["time"],
      );
}

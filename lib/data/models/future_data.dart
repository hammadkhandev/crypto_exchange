import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

import 'dashboard_data.dart';

class FutureTradeDashboardData {
  String? title;
  bool? success;
  String? message;
  String? appKey;
  String? cluster;
  bool? pairStatus;
  List<CoinPair>? pairs;
  OrderData? orderData;
  Fees? feesSettings;
  List<PriceData>? lastPriceData;

  FutureTradeDashboardData({
    this.title,
    this.success,
    this.message,
    this.appKey,
    this.cluster,
    this.pairStatus,
    this.pairs,
    this.orderData,
    this.feesSettings,
    this.lastPriceData,
  });

  factory FutureTradeDashboardData.fromJson(Map<String, dynamic> json) => FutureTradeDashboardData(
        title: json["title"],
        success: json["success"],
        message: json["message"],
        appKey: json["app_key"],
        cluster: json["cluster"],
        pairStatus: json["pair_status"],
        pairs: json["pairs"] == null ? null : List<CoinPair>.from(json["pairs"].map((x) => CoinPair.fromJson(x))),
        orderData: json["order_data"] == null ? null : OrderData.fromJson(json["order_data"]),
        feesSettings: json["fees_settings"] is Map<String, dynamic> ? Fees.fromJson(json["fees_settings"]) : null,
        lastPriceData: json["last_price_data"] == null ? null : List<PriceData>.from(json["last_price_data"].map((x) => PriceData.fromJson(x))),
      );
}

class FutureMarketData {
  List<CoinPair>? coins;
  HighestVolumePair? highestVolumePair;
  ProfitLossByCoinPair? profitLossByCoinPair;

  FutureMarketData({this.coins, this.highestVolumePair, this.profitLossByCoinPair});

  factory FutureMarketData.fromJson(Map<String, dynamic> json) => FutureMarketData(
        coins: json["coins"] == null ? null : List<CoinPair>.from(json["coins"].map((x) => CoinPair.fromJson(x))),
        highestVolumePair: json["getHighestVolumePair"] == null ? null : HighestVolumePair.fromJson(json["getHighestVolumePair"]),
        profitLossByCoinPair: json["profit_loss_by_coin_pair"] == null ? null : ProfitLossByCoinPair.fromJson(json["profit_loss_by_coin_pair"]),
      );
}

class HighestVolumePair {
  int? shortAccount;
  int? longAccount;
  int? ratio;
  String? coinPair;
  String? type;
  int? hour;

  HighestVolumePair({
    this.shortAccount,
    this.longAccount,
    this.ratio,
    this.coinPair,
    this.type,
    this.hour,
  });

  factory HighestVolumePair.fromJson(Map<String, dynamic> json) => HighestVolumePair(
        shortAccount: json["short_account"],
        longAccount: json["long_account"],
        ratio: json["ratio"],
        coinPair: json["coin_pair"],
        type: json["type"],
        hour: json["hour"],
      );
}

class ProfitLossByCoinPair {
  EstPnl? highestPnl;
  EstPnl? lowestPnl;

  ProfitLossByCoinPair({this.highestPnl, this.lowestPnl});

  factory ProfitLossByCoinPair.fromJson(Map<String, dynamic> json) => ProfitLossByCoinPair(
        highestPnl: json["highest_PNL"] == null ? null : EstPnl.fromJson(json["highest_PNL"]),
        lowestPnl: json["highest_PNL"] == null ? null : EstPnl.fromJson(json["lowest_PNL"]),
      );
}

class EstPnl {
  int? coinPairId;
  String? coinType;
  String? symbol;
  double? totalAmount;

  EstPnl({this.coinPairId, this.coinType, this.symbol, this.totalAmount});

  factory EstPnl.fromJson(Map<String, dynamic> json) => EstPnl(
        coinPairId: json["coin_pair_id"],
        coinType: json["coin_type"],
        symbol: json["symbol"],
        totalAmount: makeDouble(json["total_amount"]),
      );
}

class FutureTrade {
  int? id;
  String? uid;
  int? side;
  int? userId;
  int? baseCoinId;
  int? tradeCoinId;
  dynamic parentId;
  double? entryPrice;
  double? existPrice;
  double? price;
  double? avgClosePrice;
  double? pnl;
  double? amountInBaseCoin;
  double? amountInTradeCoin;
  double? takeProfitPrice;
  double? stopLossPrice;
  double? liquidationPrice;
  double? margin;
  double? fees;
  double? comission;
  double? executedAmount;
  int? leverage;
  int? marginMode;
  int? tradeType;
  int? isPosition;
  dynamic futureTradeTime;
  dynamic closedTime;
  int? status;
  int? isMarket;
  int? orderType;
  double? stopPrice;
  int? triggerCondition;
  double? currentMarketPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProfitLossCalculation? profitLossCalculation;
  String? symbol;
  String? baseCoinType;
  String? tradeCoinType;
  List<FutureTrade>? children;

  int? isLimitLocal;

  FutureTrade({
    this.id,
    this.uid,
    this.side,
    this.userId,
    this.baseCoinId,
    this.tradeCoinId,
    this.parentId,
    this.entryPrice,
    this.existPrice,
    this.price,
    this.avgClosePrice,
    this.pnl,
    this.amountInBaseCoin,
    this.amountInTradeCoin,
    this.takeProfitPrice,
    this.stopLossPrice,
    this.liquidationPrice,
    this.margin,
    this.fees,
    this.comission,
    this.executedAmount,
    this.leverage,
    this.marginMode,
    this.tradeType,
    this.isPosition,
    this.futureTradeTime,
    this.closedTime,
    this.status,
    this.isMarket,
    this.orderType,
    this.stopPrice,
    this.triggerCondition,
    this.currentMarketPrice,
    this.createdAt,
    this.updatedAt,
    this.profitLossCalculation,
    this.symbol,
    this.baseCoinType,
    this.tradeCoinType,
    this.children,
    this.isLimitLocal,
  });

  factory FutureTrade.fromJson(Map<String, dynamic> json) => FutureTrade(
      id: json["id"],
      uid: json["uid"],
      side: json["side"],
      userId: json["user_id"],
      baseCoinId: json["base_coin_id"],
      tradeCoinId: json["trade_coin_id"],
      parentId: json["parent_id"],
      entryPrice: makeDouble(json["entry_price"]),
      existPrice: makeDouble(json["exist_price"]),
      price: makeDouble(json["price"]),
      avgClosePrice: makeDouble(json["avg_close_price"]),
      pnl: makeDouble(json["pnl"]),
      amountInBaseCoin: makeDouble(json["amount_in_base_coin"]),
      amountInTradeCoin: makeDouble(json["amount_in_trade_coin"]),
      takeProfitPrice: makeDouble(json["take_profit_price"]),
      stopLossPrice: makeDouble(json["stop_loss_price"]),
      liquidationPrice: makeDouble(json["liquidation_price"]),
      margin: makeDouble(json["margin"]),
      fees: makeDouble(json["fees"]),
      comission: makeDouble(json["comission"]),
      executedAmount: makeDouble(json["executed_amount"]),
      leverage: json["leverage"],
      marginMode: json["margin_mode"],
      tradeType: json["trade_type"],
      isPosition: json["is_position"],
      futureTradeTime: json["future_trade_time"],
      closedTime: json["closed_time"],
      status: json["status"],
      isMarket: json["is_market"],
      orderType: json["order_type"],
      stopPrice: makeDouble(json["stop_price"]),
      triggerCondition: json["trigger_condition"],
      currentMarketPrice: makeDouble(json["current_market_price"]),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      profitLossCalculation: json["profit_loss_calculation"] == null ? null : ProfitLossCalculation.fromJson(json["profit_loss_calculation"]),
      children: json["children"] == null ? null : List<FutureTrade>.from(json["children"].map((x) => FutureTrade.fromJson(x))),
      symbol: json["symbol"],
      baseCoinType: json["base_coin_type"],
      tradeCoinType: json["trade_coin_type"],
      isLimitLocal: 1);
}

class ProfitLossCalculation {
  bool? success;
  double? pnl;
  double? roe;
  double? marginRatio;
  String? symbol;
  String? baseCoinType;
  String? tradeCoinType;
  double? marketPrice;

  ProfitLossCalculation({
    this.success,
    this.pnl,
    this.roe,
    this.marginRatio,
    this.symbol,
    this.baseCoinType,
    this.tradeCoinType,
    this.marketPrice,
  });

  factory ProfitLossCalculation.fromJson(Map<String, dynamic> json) => ProfitLossCalculation(
        success: json["success"],
        pnl: makeDouble(json["pnl"]),
        roe: makeDouble(json["roe"]),
        marginRatio: makeDouble(json["margin_ratio"]),
        symbol: json["symbol"],
        baseCoinType: json["base_coin_type"],
        tradeCoinType: json["trade_coin_type"],
        marketPrice: makeDouble(json["market_price"]),
      );
}

class FutureTransaction {
  int? id;
  int? userId;
  int? orderId;
  int? futureWalletId;
  int? coinPairId;
  int? type;
  double? amount;
  String? coinType;
  String? symbol;
  DateTime? createdAt;
  DateTime? updatedAt;

  FutureTransaction({
    this.id,
    this.userId,
    this.orderId,
    this.futureWalletId,
    this.coinPairId,
    this.type,
    this.amount,
    this.coinType,
    this.symbol,
    this.createdAt,
    this.updatedAt,
  });

  factory FutureTransaction.fromJson(Map<String, dynamic> json) => FutureTransaction(
        id: json["id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        futureWalletId: json["future_wallet_id"],
        coinPairId: json["coin_pair_id"],
        type: json["type"],
        amount: makeDouble(json["amount"]),
        coinType: json["coin_type"],
        symbol: json["symbol"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class FTPreOrderData {
  double? walletBalance;
  double? longCostFundingFees;
  double? longCostCommissionFees;
  double? longCost;
  double? shortCostFundingFees;
  double? shortCostCommissionFees;
  double? shortCost;
  double? maxSizeOpenLongBaseFundingFees;
  double? maxSizeOpenLongBaseCommissionFees;
  double? maxSizeOpenLongBase;
  double? maxSizeOpenShortBaseFundingFees;
  double? maxSizeOpenShortBaseCommissionFees;
  double? maxSizeOpenShortBase;
  double? maxSizeOpenLongTrade;
  double? maxSizeOpenShortTrade;

  FTPreOrderData({
    this.walletBalance,
    this.longCostFundingFees,
    this.longCostCommissionFees,
    this.longCost,
    this.shortCostFundingFees,
    this.shortCostCommissionFees,
    this.shortCost,
    this.maxSizeOpenLongBaseFundingFees,
    this.maxSizeOpenLongBaseCommissionFees,
    this.maxSizeOpenLongBase,
    this.maxSizeOpenShortBaseFundingFees,
    this.maxSizeOpenShortBaseCommissionFees,
    this.maxSizeOpenShortBase,
    this.maxSizeOpenLongTrade,
    this.maxSizeOpenShortTrade,
  });

  factory FTPreOrderData.fromJson(Map<String, dynamic> json) => FTPreOrderData(
        walletBalance: makeDouble(json["wallet_balance"]),
        longCostFundingFees: makeDouble(json["long_cost_funding_fees"]),
        longCostCommissionFees: makeDouble(json["long_cost_commission_fees"]),
        longCost: makeDouble(json["long_cost"]),
        shortCostFundingFees: makeDouble(json["short_cost_funding_fees"]),
        shortCostCommissionFees: makeDouble(json["short_cost_commission_fees"]),
        shortCost: makeDouble(json["short_cost"]),
        maxSizeOpenLongBaseFundingFees: makeDouble(json["max_size_open_long_base_funding_fees"]),
        maxSizeOpenLongBaseCommissionFees: makeDouble(json["max_size_open_long_base_commission_fees"]),
        maxSizeOpenLongBase: makeDouble(json["max_size_open_long_base"]),
        maxSizeOpenShortBaseFundingFees: makeDouble(json["max_size_open_short_base_funding_fees"]),
        maxSizeOpenShortBaseCommissionFees: makeDouble(json["max_size_open_short_base_commission_fees"]),
        maxSizeOpenShortBase: makeDouble(json["max_size_open_short_base"]),
        maxSizeOpenLongTrade: makeDouble(json["max_size_open_long_trade"]),
        maxSizeOpenShortTrade: makeDouble(json["max_size_open_short_trade"]),
      );
}

class CreateTrade {
  int? coinPairId;
  int? tradeType;
  int? marginMode;
  int? leverageAmount;
  int? orderType;
  int? amountType;
  double? amount;
  double? price;
  double? stopPrice;
  double? takeProfit;
  double? stopLoss;

  CreateTrade({
    this.coinPairId,
    this.tradeType,
    this.marginMode,
    this.leverageAmount,
    this.orderType,
    this.amountType,
    this.amount,
    this.price,
    this.stopPrice,
    this.takeProfit,
    this.stopLoss,
  });

  Map<String, dynamic> makeJson(String fromKey) {
    final mapObj = <String, dynamic>{};
    mapObj[APIKeyConstants.coinPairId] = coinPairId;
    if (fromKey == FromKey.check) {
      mapObj[APIKeyConstants.tradeType] = tradeType;
    } else {
      mapObj[APIKeyConstants.side] = tradeType;
    }
    mapObj[APIKeyConstants.marginMode] = marginMode;
    mapObj[APIKeyConstants.leverageAmount] = leverageAmount;
    mapObj[APIKeyConstants.orderType] = orderType;
    mapObj[APIKeyConstants.amountType] = amountType;
    mapObj[APIKeyConstants.amount] = amount;
    if (price != null) mapObj[APIKeyConstants.price] = price;
    if (stopPrice != null) mapObj[APIKeyConstants.stopPrice] = stopPrice;
    if (takeProfit != null) mapObj[APIKeyConstants.takeProfit] = takeProfit;
    if (stopLoss != null) mapObj[APIKeyConstants.stopLoss] = stopLoss;
    return mapObj;
  }
}

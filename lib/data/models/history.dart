import 'dart:convert';

import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

import 'fiat_deposit.dart';

///final history = historyFromJson(jsonString);
List<History> historyFromJson(String str) => List<History>.from(json.decode(str).map((x) => History.fromJson(x)));

String historyToJson(List<History> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class History {
  History({
    required this.id,
    this.userId,
    this.name,
    this.coinId,
    this.key,
    this.type,
    this.coinType,
    this.status,
    this.isPrimary,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.walletId,
    this.amount,
    this.btc,
    this.dollar,
    this.addressType,
    this.address,
    this.transactionId,
    this.usedGas,
    this.receiverWalletId,
    this.transactionHash,
    this.confirmations,
    this.fees,
    this.message,
  });

  int id;
  int? userId;
  String? name;
  int? coinId;
  dynamic key;
  int? type;
  String? coinType;
  int? status;
  int? isPrimary;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? walletId;
  int? addressType;
  String? address;
  String? transactionId;
  String? transactionHash;
  int? receiverWalletId;
  int? confirmations;
  String? message;

  double? balance;
  double? usedGas;
  double? fees;
  double? amount;
  double? btc;
  double? dollar;

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"] ?? 0,
        userId: json["user_id"],
        name: json["name"],
        coinId: json["coin_id"],
        key: json["key"],
        type: json["type"],
        coinType: json["coin_type"],
        status: makeInt(json["status"]),
        isPrimary: json["is_primary"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        walletId: json["wallet_id"],
        fees: makeDouble(json["fees"]),
        balance: makeDouble(json["balance"]),
        amount: makeDouble(json["amount"]),
        btc: makeDouble(json["btc"]),
        dollar: makeDouble(json["doller"]),
        usedGas: makeDouble(json["used_gas"]),
        addressType: makeInt(json["address_type"]),
        address: json["address"],
        transactionId: json["transaction_id"],
        transactionHash: json["transaction_hash"],
        receiverWalletId: makeInt(json["receiver_wallet_id"]),
        confirmations: makeInt(json["confirmations"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "coin_id": coinId,
        "key": key,
        "type": type,
        "coin_type": coinType,
        "status": status,
        "is_primary": isPrimary,
        "balance": balance,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "wallet_id": walletId,
        "amount": amount,
        "btc": btc,
        "doller": dollar,
        "address_type": addressType,
        "address": address,
        "transaction_id": transactionId,
        "transaction_hash": transactionHash,
        "used_gas": usedGas,
        "receiver_wallet_id": receiverWalletId,
        "confirmations": confirmations,
        "fees": fees,
        "message": message,
      };
}


class SwapHistory {
  SwapHistory({
    required this.id,
    this.userId,
    this.fromWalletId,
    this.toWalletId,
    this.fromCoinType,
    this.toCoinType,
    this.requestedAmount,
    this.convertedAmount,
    this.rate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.fromWallet,
    this.toWallet,
    this.swapHistoryFromWallet,
    this.swapHistoryToWallet,
  });

  int id;
  int? userId;
  int? fromWalletId;
  int? toWalletId;
  String? fromCoinType;
  String? toCoinType;
  double? requestedAmount;
  double? convertedAmount;
  double? rate;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fromWallet;
  String? toWallet;
  Wallet? swapHistoryFromWallet;
  Wallet? swapHistoryToWallet;

  factory SwapHistory.fromJson(Map<String, dynamic> json) => SwapHistory(
        id: json["id"],
        userId: json["user_id"],
        fromWalletId: json["from_wallet_id"],
        toWalletId: json["to_wallet_id"],
        fromCoinType: json["from_coin_type"],
        toCoinType: json["to_coin_type"],
        requestedAmount: makeDouble(json["requested_amount"]),
        convertedAmount: makeDouble(json["converted_amount"]),
        rate: makeDouble(json["rate"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        fromWallet: json["fromWallet"],
        toWallet: json["toWallet"],
        swapHistoryFromWallet: json["from_wallet"] == null ? null : Wallet.fromJson(json["from_wallet"]),
        swapHistoryToWallet: json["to_wallet"] == null ? null : Wallet.fromJson(json["to_wallet"]),
      );

}

class FiatHistory {
  FiatHistory({
    required this.id,
    this.uniqueCode,
    this.userId,
    this.walletId,
    this.fromWalletId,
    this.paymentMethodId,
    this.currency,
    this.currencyAmount,
    this.coinAmount,
    this.rate,
    this.fees,
    this.status,
    this.updatedBy,
    this.bankReceipt,
    this.bankSlip,
    this.bankId,
    this.transactionId,
    this.createdAt,
    this.updatedAt,
    this.coinType,
    this.wallet,
    this.bank,
    this.paymentInfo,
  });

  int id;
  String? uniqueCode;
  int? userId;
  int? walletId;
  int? fromWalletId;
  int? paymentMethodId;
  String? currency;
  double? currencyAmount;
  double? coinAmount;
  double? rate;
  int? status;
  double? fees;
  dynamic updatedBy;
  String? bankReceipt;
  String? bankSlip;
  int? bankId;
  String? transactionId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coinType;
  Wallet? wallet;
  Bank? bank;
  String? paymentInfo;

  factory FiatHistory.fromJson(Map<String, dynamic> json) => FiatHistory(
        id: json["id"],
        uniqueCode: json["unique_code"],
        userId: json["user_id"],
        walletId: json["wallet_id"],
        fromWalletId: json["from_wallet_id"],
        paymentMethodId: json["payment_method_id"],
        currency: json["currency"],
        currencyAmount: makeDouble(json["currency_amount"]),
        coinAmount: makeDouble(json["coin_amount"]),
        rate: makeDouble(json["rate"]),
        fees: makeDouble(json["fees"]),
        status: json["status"],
        updatedBy: json["updated_by"],
        bankReceipt: json["bank_receipt"],
        bankSlip: json["bank_slip"],
        bankId: makeInt(json["bank_id"]),
        transactionId: json["transaction_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        coinType: json["coin_type"],
        paymentInfo: json["payment_info"],
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
        bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
      );
}

class WalletCurrencyHistory {
  int? id;
  int? userId;
  int? walletId;
  int? coinId;
  int? bankId;
  String? coinType;
  String? paymentType;
  String? paymentTitle;
  double? amount;
  double? fees;
  String? status;
  String? bankReceipt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? bankTitle;
  Bank? bank;

  WalletCurrencyHistory({
    this.id,
    this.userId,
    this.walletId,
    this.coinId,
    this.bankId,
    this.coinType,
    this.amount,
    this.fees,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.bankTitle,
    this.bank,
    this.paymentType,
    this.paymentTitle,
    this.bankReceipt,
  });

  factory WalletCurrencyHistory.fromJson(Map<String, dynamic> json) => WalletCurrencyHistory(
        id: json["id"],
        userId: json["user_id"],
        walletId: json["wallet_id"],
        paymentType: json["payment_type"],
        paymentTitle: json["payment_title"],
        coinId: json["coin_id"],
        bankId: json["bank_id"],
        coinType: json["coin_type"],
        amount: makeDouble(json["amount"]),
        fees: makeDouble(json["fees"]),
        status: json["status"],
        bankReceipt: json["bank_recipt"] ?? json["receipt"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        bankTitle: json["bank_title"],
        bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
      );
}

import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

class Wallet {
  Wallet({
    required this.id,
    this.userId,
    this.name,
    this.coinId,
    this.key,
    this.type,
    this.coinType,
    this.status,
    this.isPrimary,
    this.isDeposit,
    this.isWithdrawal,
    this.tradeStatus,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.coinIcon,
    this.onOrder,
    this.availableBalance,
    this.total,
    this.onOrderUsd,
    this.availableBalanceUsd,
    this.totalBalanceUsd,
    this.network,
    this.networkName,
    this.minimumWithdrawal,
    this.maximumWithdrawal,
    this.withdrawalFees,
    this.withdrawalFeesType,
    this.encryptId,
    this.currencyType,
  });

  int id;
  int? userId;
  String? encryptId;
  String? name;
  int? coinId;
  dynamic key;
  int? type;
  String? coinType;
  int? status;
  int? isPrimary;
  int? isDeposit;
  int? isWithdrawal;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coinIcon;
  int? network;
  String? networkName;
  int? tradeStatus;
  int? currencyType;

  double? balance;
  double? onOrder;
  double? availableBalance;
  double? total;
  double? onOrderUsd;
  double? availableBalanceUsd;
  double? totalBalanceUsd;
  double? minimumWithdrawal;
  double? maximumWithdrawal;
  double? withdrawalFees;
  int? withdrawalFeesType;

  factory Wallet.fromJson(Map<String?, dynamic> json) => Wallet(
        id: json["id"] ?? 0,
        userId: json["user_id"],
        encryptId: json["encryptId"],
        name: json["name"] ?? json["wallet_name"],
        coinId: json["coin_id"],
        key: json["key"],
        type: json["type"],
        coinType: json["coin_type"],
        status: json["status"],
        currencyType: json["currency_type"],
        isPrimary: json["is_primary"],
        isDeposit: json["is_deposit"],
        isWithdrawal: json["is_withdrawal"],
        tradeStatus: json["trade_status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        coinIcon: json["coin_icon"],
        balance: makeDouble(json["balance"]),
        onOrder: makeDouble(json["on_order"]),
        availableBalance: makeDouble(json["available_balance"]),
        total: makeDouble(json["total"]),
        onOrderUsd: makeDouble(json["on_order_usd"]),
        availableBalanceUsd: makeDouble(json["available_balance_usd"]),
        totalBalanceUsd: makeDouble(json["total_balance_usd"]),
        network: json["network"],
        networkName: json["network_name"],
        minimumWithdrawal: makeDouble(json["minimum_withdrawal"]),
        maximumWithdrawal: makeDouble(json["maximum_withdrawal"]),
        withdrawalFees: makeDouble(json["withdrawal_fees"]),
        withdrawalFeesType: makeInt(json["withdrawal_fees_type"]),
      );
}

class Network {
  Network({
    required this.id,
    this.walletId,
    this.coinId,
    this.baseType,
    this.address,
    this.networkType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.networkName,
  });

  int id;
  int? walletId;
  int? coinId;
  int? baseType;
  String? address;
  String? networkType;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? networkName;

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        id: json["id"],
        walletId: json["wallet_id"],
        coinId: json["coin_id"],
        baseType: json["base_type"],
        address: json["address"],
        networkType: json["network_type"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        networkName: json["network_name"] ?? json["name"],
      );
}

class WalletDeposit {
  WalletDeposit({
    this.success,
    this.wallet,
    this.address,
    this.message,
    this.data,
  });

  bool? success;
  Wallet? wallet;
  String? address;
  String? message;
  dynamic data;

  factory WalletDeposit.fromJson(Map<String, dynamic> json) => WalletDeposit(
        success: json["success"],
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
        address: json["address"] is bool ? null : json["address"],
        message: json["message"],
        data: json["data"],
        // data: json["data"] == null ? null : NetworkData.fromJson(json["data"]),
      );
}

class PreWithdraw {
  String? coinType;
  double? fees;
  double? amount;
  double? feesPercentage;
  int? feesType;

  PreWithdraw({
    this.coinType,
    this.fees,
    this.amount,
    this.feesPercentage,
    this.feesType,
  });

  factory PreWithdraw.fromJson(Map<String, dynamic> json) => PreWithdraw(
        coinType: json["coin_type"],
        fees: makeDouble(json["fees"]),
        amount: makeDouble(json["amount"]),
        feesPercentage: makeDouble(json["fees_percentage"]),
        feesType: json["fees_type"],
      );
}

class WalletOverview {
  double? spotWallet;
  double? spotWalletUsd;
  double? futureWallet;
  double? futureWalletUsd;
  double? p2PWallet;
  double? p2PWalletUsd;
  double? total;
  double? totalUsd;
  List<String>? coins;
  String? selectedCoin;
  String? banner;
  List<History>? withdraw;
  List<History>? deposit;

  WalletOverview({
    this.spotWallet,
    this.spotWalletUsd,
    this.futureWallet,
    this.futureWalletUsd,
    this.p2PWallet,
    this.p2PWalletUsd,
    this.total,
    this.totalUsd,
    this.coins,
    this.selectedCoin,
    this.banner,
    this.withdraw,
    this.deposit,
  });

  factory WalletOverview.fromJson(Map<String, dynamic> json) => WalletOverview(
        spotWallet: makeDouble(json["spot_wallet"]),
        spotWalletUsd: makeDouble(json["spot_wallet_usd"]),
        futureWallet: makeDouble(json["future_wallet"]),
        futureWalletUsd: makeDouble(json["future_wallet_usd"]),
        p2PWallet: makeDouble(json["p2p_wallet"]),
        p2PWalletUsd: makeDouble(json["p2p_wallet_usd"]),
        total: makeDouble(json["total"]),
        totalUsd: makeDouble(json["total_usd"]),
        selectedCoin: json["selected_coin"],
        banner: json["banner"],
        coins: json["coins"] == null ? null : List<String>.from(json["coins"].map((x) => x)),
        withdraw: json["withdraw"] == null ? null : List<History>.from(json["withdraw"].map((x) => History.fromJson(x))),
        deposit: json["deposit"] == null ? null : List<History>.from(json["deposit"].map((x) => History.fromJson(x))),
      );
}

class TotalBalance {
  String? currency;
  double? total;

  TotalBalance({this.currency, this.total});

  factory TotalBalance.fromJson(Map<String, dynamic> json) => TotalBalance(currency: json["currency"], total: makeDouble(json["total"]));
}


class NetworkAddress {
  int? networkId;
  String? address;

  NetworkAddress({this.networkId, this.address});

  factory NetworkAddress.fromJson(Map<String, dynamic> json) => NetworkAddress(
        networkId: json["network_id"],
        address: json["address"],
      );
}

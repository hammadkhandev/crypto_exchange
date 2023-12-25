import 'dart:io';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

class FiatDeposit {
  FiatDeposit({
    this.banks,
    this.paymentMethods,
    this.walletList,
    this.currencyList,
  });

  List<Bank>? banks;
  List<PaymentMethod>? paymentMethods;
  List<Wallet>? walletList;
  List<FiatCurrency>? currencyList;

  factory FiatDeposit.fromJson(Map<String, dynamic> json) => FiatDeposit(
        banks: json["banks"] == null ? null : List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
        paymentMethods:
            json["payment_methods"] == null ? null : List<PaymentMethod>.from(json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
        walletList: json["wallet_list"] == null ? null : List<Wallet>.from(json["wallet_list"].map((x) => Wallet.fromJson(x))),
        currencyList: json["currency_list"] == null ? null : List<FiatCurrency>.from(json["currency_list"].map((x) => FiatCurrency.fromJson(x))),
      );
}

class Bank {
  Bank({
    required this.id,
    this.accountHolderName,
    this.accountHolderAddress,
    this.bankName,
    this.bankAddress,
    this.country,
    this.swiftCode,
    this.iban,
    this.note,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String? accountHolderName;
  String? accountHolderAddress;
  String? bankName;
  String? bankAddress;
  String? country;
  String? swiftCode;
  String? iban;
  String? note;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        accountHolderName: json["account_holder_name"],
        accountHolderAddress: json["account_holder_address"],
        bankName: json["bank_name"],
        bankAddress: json["bank_address"],
        country: json["country"],
        swiftCode: json["swift_code"],
        iban: json["iban"],
        note: json["note"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == 0 ? null : id,
        "account_holder_name": accountHolderName,
        "account_holder_address": accountHolderAddress,
        "bank_name": bankName,
        "bank_address": bankAddress,
        "country": country,
        "swift_code": swiftCode,
        "iban": iban,
        "note": note,
      };

  String toCopy() =>
      "Account Holder Name: $accountHolderName,  Bank Name: $bankName, Bank Address: $bankAddress, Country: $country, Swift Code: $swiftCode, Account Number: $iban";
}

class FiatCurrency {
  FiatCurrency({
    required this.id,
    this.name,
    this.code,
    this.symbol,
    this.rate,
    this.status,
    this.isPrimary,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String? name;
  String? code;
  String? symbol;
  String? rate;
  int? status;
  int? isPrimary;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FiatCurrency.fromJson(Map<String, dynamic> json) => FiatCurrency(
        id: json["id"] ?? 0,
        name: json["name"],
        code: json["code"],
        symbol: json["symbol"],
        rate: json["rate"],
        status: json["status"],
        isPrimary: json["is_primary"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class PaymentMethod {
  PaymentMethod({
    required this.id,
    this.title,
    this.paymentMethod,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String? title;
  int? paymentMethod;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        title: json["title"],
        paymentMethod: json["payment_method"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
}

class FiatWithdrawal {
  FiatWithdrawal({this.myWallet, this.currency, this.myBank, this.paymentMethodList});

  List<Wallet>? myWallet;
  List<FiatCurrency>? currency;
  List<Bank>? myBank;
  List<PaymentMethod>? paymentMethodList;

  factory FiatWithdrawal.fromJson(Map<String, dynamic> json) => FiatWithdrawal(
        myWallet: json["my_wallet"] == null ? null : List<Wallet>.from(json["my_wallet"].map((x) => Wallet.fromJson(x))),
        currency: json["currency"] == null ? null : List<FiatCurrency>.from(json["currency"].map((x) => FiatCurrency.fromJson(x))),
        myBank: json["my_bank"] == null ? null : List<Bank>.from(json["my_bank"].map((x) => Bank.fromJson(x))),
        paymentMethodList:
            json["payment_method_list"] == null ? null : List<PaymentMethod>.from(json["payment_method_list"].map((x) => PaymentMethod.fromJson(x))),
      );
}

class FiatWithdrawalRate {
  FiatWithdrawalRate({
    this.amount,
    this.rate,
    this.convertAmount,
    this.fees,
    this.netAmount,
    this.currency,
  });

  double? amount;
  double? rate;
  double? convertAmount;
  double? fees;
  double? netAmount;
  String? currency;

  factory FiatWithdrawalRate.fromJson(Map<String, dynamic> json) => FiatWithdrawalRate(
        amount: makeDouble(json["amount"]),
        rate: makeDouble(json["rate"]),
        convertAmount: makeDouble(json["convert_amount"]),
        fees: makeDouble(json["fees"]),
        netAmount: makeDouble(json["net_amount"]),
        currency: json["currency"],
      );
}

class CreateDeposit {
  CreateDeposit(
      {this.walletId,
      this.paymentId,
      this.bankId,
      this.walletIdFrom,
      this.amount,
      this.currency,
      this.stripeToken,
      this.paypalToken,
      this.code,
      this.file});

  int? walletId;
  int? paymentId;
  int? bankId;
  int? walletIdFrom;
  double? amount;
  String? currency;
  String? stripeToken;
  String? paypalToken;
  String? code;
  File? file;

  Future<Map<String, dynamic>> toJson() async {
    final mapObj = <String, dynamic>{};
    mapObj[APIKeyConstants.paymentMethodId] = paymentId;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.walletId] = walletId;
    if (currency.isValid) mapObj[APIKeyConstants.currency] = currency;
    if (bankId != null) {
      mapObj[APIKeyConstants.bankId] = bankId;
      if (file != null) mapObj[APIKeyConstants.bankReceipt] = await APIRepository().makeMultipartFile(file!);
    }
    if (walletIdFrom != null) mapObj[APIKeyConstants.fromWalletId] = walletIdFrom;
    if (stripeToken.isValid) mapObj[APIKeyConstants.stripeToken] = stripeToken;
    if (paypalToken.isValid) mapObj[APIKeyConstants.paypalToken] = paypalToken;
    if (code.isValid) mapObj[APIKeyConstants.code] = code;
    return mapObj;
  }
}

class Currency {
  String? label;
  String? value;

  Currency({this.label, this.value});

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(label: json["label"], value: json["value"]);
}

class CreateWithdrawal {
  double? amount;
  int? bankId;
  String? currency;
  int? paymentMethodId;
  int? paymentMethodType;
  String? paymentInfo;
  String? type;
  String? walletId;

  CreateWithdrawal({
    this.walletId,
    this.paymentMethodId,
    this.bankId,
    this.amount,
    this.currency,
    this.paymentInfo,
    this.paymentMethodType,
    this.type,
  });

  Future<Map<String, dynamic>> toJson() async {
    final mapObj = <String, dynamic>{};
    mapObj[APIKeyConstants.amount] = amount;
    if (paymentMethodId != null) mapObj[APIKeyConstants.paymentMethodId] = paymentMethodId;
    if (walletId.isValid) mapObj[APIKeyConstants.walletId] = walletId;
    if (currency.isValid) mapObj[APIKeyConstants.currency] = currency;
    if (bankId != null) mapObj[APIKeyConstants.bankId] = bankId;
    if (type != null) mapObj[APIKeyConstants.type] = type;
    if (paymentMethodType != null) mapObj[APIKeyConstants.paymentMethodType] = paymentMethodType;
    if (paymentInfo != null) mapObj[APIKeyConstants.paymentInfo] = paymentInfo;

    return mapObj;
  }
}


import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/data/models/future_data.dart';
import 'package:tradexpro_flutter/data/remote/socket_provider.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/language_util.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/models/response.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'api_provider.dart';
import 'http_api_provider.dart';

class APIRepository {
  final provider = Get.find<APIProvider>();
  final socketProvider = Get.find<SocketProvider>();

  Map<String, String> authHeader() {
    String? token = GetStorage().read(PreferenceKey.accessToken);
    String? type = GetStorage().read(PreferenceKey.accessType);
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.accept] = APIKeyConstants.vAccept;
    mapObj[APIKeyConstants.userApiSecret] = dotenv.env[EnvKeyValue.kApiSecret] ?? "";
    mapObj[APIKeyConstants.lang] = LanguageUtil.getCurrentKey();
    mapObj[APIKeyConstants.userAgent] = gUserAgent;
    if (token != null && token.isNotEmpty) {
      mapObj[APIKeyConstants.authorization] = "${type ?? APIKeyConstants.vBearer} $token";
    }
    //printFunction("authHeader", mapObj[APIKeyConstants.authorization]);
    return mapObj;
  }

  Map<String, String> authHeaderEvm() {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.accept] = APIKeyConstants.vAccept;
    mapObj[APIKeyConstants.evmApiSecret] = getSettingsLocal()?.evmApiSecret ?? "";
    String? token = GetStorage().read(PreferenceKey.accessTokenEvm);
    if (token != null && token.isNotEmpty) mapObj[APIKeyConstants.token] = token;
    //printFunction("authHeaderEvm", mapObj[APIKeyConstants.authorization]);
    return mapObj;
  }

  /// *** POST requests *** ///

  Future<ServerResponse> registerUser(String firstName, String lastName, String email, String password) async {
    var mapObj = {};
    mapObj[APIKeyConstants.firstName] = firstName;
    mapObj[APIKeyConstants.lastName] = lastName;
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.password] = password;
    mapObj[APIKeyConstants.confirmPassword] = password;
    mapObj[APIKeyConstants.recaptcha] = "noReCAPTCHA";
    return provider.postRequest(APIURLConstants.signUp, mapObj, authHeader());
  }

  Future<ServerResponse> verifyEmail(String email, String code) async {
    var mapObj = {};
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.verifyCode] = code;
    return provider.postRequest(APIURLConstants.verifyEmail, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> loginUser(String email, String password) async {
    var mapObj = {};
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.password] = password;
    //mapObj[APIKeyConstants.recaptcha] = "noReCAPTCHA";
    return provider.postRequest(APIURLConstants.signIn, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> verify2FACodeLogin(String code, int userId) async {
    var mapObj = {};
    mapObj[APIKeyConstants.code] = code;
    mapObj[APIKeyConstants.userId] = userId;
    return provider.postRequest(APIURLConstants.g2FAVerify, mapObj, authHeader());
  }

  Future<ServerResponse> forgetPassword(String email) async {
    var mapObj = {};
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.recaptcha] = "noReCAPTCHA";
    return provider.postRequest(APIURLConstants.forgotPassword, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> resetPassword(String email, String code, String password) async {
    var mapObj = {};
    mapObj[APIKeyConstants.email] = email;
    mapObj[APIKeyConstants.token] = code;
    mapObj[APIKeyConstants.password] = password;
    mapObj[APIKeyConstants.confirmPassword] = password;
    return provider.postRequest(APIURLConstants.resetPassword, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> changePassword(String currentPass, String newPass, String confirmPass) async {
    var mapObj = {};
    mapObj[APIKeyConstants.oldPassword] = currentPass;
    mapObj[APIKeyConstants.password] = newPass;
    mapObj[APIKeyConstants.confirmPassword] = confirmPass;
    return provider.postRequest(APIURLConstants.changePassword, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> logoutUser() async {
    return provider.postRequest(APIURLConstants.logoutApp, {}, authHeader());
  }

  Future<ServerResponse> walletNetworkAddress(int walletId, String networkType) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId.toString();
    mapObj[APIKeyConstants.networkType] = networkType;
    return provider.postRequest(APIURLConstants.walletNetworkAddress, mapObj, authHeader());
  }

  Future<ServerResponse> createNetworkAddress(int networkId, String coinType) async {
    var mapObj = {};
    mapObj[APIKeyConstants.coinType] = coinType;
    mapObj[APIKeyConstants.network] = networkId.toString();
    final url = (getSettingsLocal()?.evmApiUrl ?? "") + APIURLConstants.evmCreateWallet;
    return HttpAPIProvider().postRequest(url, mapObj, authHeaderEvm());
  }

  Future<ServerResponse> withdrawProcess(int walletId, String address, double amount, String networkType, String code) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.address] = address;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.code] = code;
    mapObj[APIKeyConstants.networkType] = networkType;
    return provider.postRequest(APIURLConstants.walletWithdrawalProcess, mapObj, authHeader());
  }

  Future<ServerResponse> withdrawProcessEvm(
      int walletId, String address, double amount, String code, int? networkId, String? networkType, int? baseType) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.address] = address;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.code] = code;
    if (networkId != null && networkId > 0) mapObj[APIKeyConstants.networkId] = networkId;
    mapObj[APIKeyConstants.networkType] = networkType ?? "";
    mapObj[APIKeyConstants.baseType] = baseType ?? "";
    return provider.postRequest(APIURLConstants.walletWithdrawalProcess, mapObj, authHeader());
  }

  Future<ServerResponse> swapCoinProcess(int fromCoinId, int toCoinId, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.fromCoinId] = fromCoinId;
    mapObj[APIKeyConstants.toCoinId] = toCoinId;
    mapObj[APIKeyConstants.amount] = amount;
    return provider.postRequest(APIURLConstants.swapCoinApp, mapObj, authHeader());
  }

  Future<ServerResponse> preWithdrawalProcess(String address, double amount, int walletId, String note, String code, {String? network}) async {
    var mapObj = {};
    mapObj[APIKeyConstants.address] = address;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.walletId] = walletId;
    if (network.isValid) mapObj[APIKeyConstants.networkType] = network;
    mapObj[APIKeyConstants.note] = note;
    mapObj[APIKeyConstants.code] = code;
    return provider.postRequest(APIURLConstants.preWithdrawalProcess, mapObj, authHeader());
  }

  Future<ServerResponse> preWithdrawalProcessEvm(String address, double amount, int walletId, String note,
      {String? code, int? networkId, String? networkType}) async {
    var mapObj = {};
    mapObj[APIKeyConstants.address] = address;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.note] = note;
    if (networkType.isValid) mapObj[APIKeyConstants.networkType] = networkType;
    if (networkId != null) mapObj[APIKeyConstants.networkId] = networkId;
    if (code.isValid) mapObj[APIKeyConstants.code] = code;
    return provider.postRequest(APIURLConstants.preWithdrawalProcess, mapObj, authHeader());
  }

  Future<ServerResponse> updateProfile(User user, File imageFile) async {
    var mapObj = <String, dynamic>{};
    mapObj[APIKeyConstants.firstName] = user.firstName;
    mapObj[APIKeyConstants.lastName] = user.lastName;
    mapObj[APIKeyConstants.nickName] = user.nickName;
    mapObj[APIKeyConstants.phone] = user.phone;
    mapObj[APIKeyConstants.country] = user.country;
    mapObj[APIKeyConstants.gender] = user.gender;

    if (imageFile.path.isNotEmpty) {
      mapObj[APIKeyConstants.photo] = await makeMultipartFile(imageFile);
    }
    return provider.postRequestFormData(APIURLConstants.updateProfile, mapObj, authHeader());
  }

  Future<ServerResponse> sendPhoneSMS() async {
    return provider.postRequest(APIURLConstants.sendPhoneVerificationSms, {}, authHeader());
  }

  Future<ServerResponse> verifyPhone(String code) async {
    return provider.postRequest(APIURLConstants.phoneVerify, {APIKeyConstants.verifyCode: code}, authHeader());
  }

  Future<MultipartFile> makeMultipartFile(File file) async {
    List<int> arrayData = await file.readAsBytes();
    MultipartFile multipartFile = MultipartFile(arrayData, filename: file.path);
    return multipartFile;
  }

  Future<ServerResponse> setupGoogleSecret(String code, String secret, bool isAdd) async {
    var mapObj = {};
    mapObj[APIKeyConstants.code] = code;
    mapObj[APIKeyConstants.setup] = isAdd ? "add" : "remove";
    mapObj[APIKeyConstants.google2faSecret] = secret;
    return provider.postRequest(APIURLConstants.google2faSetup, mapObj, authHeader());
  }

  Future<ServerResponse> profileDeleteRequest(String reason, String password) async {
    var mapObj = {};
    mapObj[APIKeyConstants.deleteRequestReason] = reason;
    mapObj[APIKeyConstants.password] = password;
    return provider.postRequest(APIURLConstants.profileDeleteRequest, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> updateCurrency(String code) async {
    var mapObj = {};
    mapObj[APIKeyConstants.code] = code;
    return provider.postRequest(APIURLConstants.updateCurrency, mapObj, authHeader());
  }

  Future<ServerResponse> updateLanguage(String language) async {
    var mapObj = {};
    mapObj[APIKeyConstants.language] = language;
    return provider.postRequest(APIURLConstants.languageSetup, mapObj, authHeader());
  }

  Future<ServerResponse> thirdPartyKycVerified(String inquiryId) async {
    var mapObj = {};
    mapObj[APIKeyConstants.inquiryId] = inquiryId;
    return provider.postRequest(APIURLConstants.thirdPartyKycVerified, mapObj, authHeader());
  }

  Future<ServerResponse> uploadIdVerificationFiles(IdVerificationType type, File frontFile, File backFile, File selfieFile) async {
    var mapObj = <String, dynamic>{};
    if (frontFile.path.isNotEmpty) {
      mapObj[APIKeyConstants.fileTwo] = await makeMultipartFile(frontFile);
    }
    if (backFile.path.isNotEmpty) {
      mapObj[APIKeyConstants.fileThree] = await makeMultipartFile(backFile);
    }
    if (selfieFile.path.isNotEmpty) {
      mapObj[APIKeyConstants.fileSelfie] = await makeMultipartFile(selfieFile);
    }
    String url = "";
    switch (type) {
      case IdVerificationType.none:
        break;
      case IdVerificationType.nid:
        url = APIURLConstants.uploadNID;
        break;
      case IdVerificationType.passport:
        url = APIURLConstants.uploadPassport;
        break;
      case IdVerificationType.driving:
        url = APIURLConstants.uploadDrivingLicence;
        break;
      case IdVerificationType.voter:
        url = APIURLConstants.uploadVoterCard;
        break;
    }
    return provider.postRequestFormData(url, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> updateNotificationStatus(List<int> ids) async {
    var mapObj = {};
    mapObj[APIKeyConstants.ids] = ids;
    return provider.postRequest(APIURLConstants.notificationSeen, mapObj, authHeader());
  }

  Future<ServerResponse> placeOrderLimit(bool isBuy, int baseCoinId, int tradeCoinId, double price, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.price] = price;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId;
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId;
    final url = isBuy ? APIURLConstants.buyLimitApp : APIURLConstants.sellLimitApp;
    return provider.postRequest(url, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> placeOrderMarket(bool isBuy, int baseCoinId, int tradeCoinId, double price, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.price] = price;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId;
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId;
    final url = isBuy ? APIURLConstants.buyMarketApp : APIURLConstants.sellMarketApp;
    return provider.postRequest(url, mapObj, authHeader());
  }

  Future<ServerResponse> placeOrderStopMarket(bool isBuy, int baseCoinId, int tradeCoinId, double amount, double limit, double stop) async {
    var mapObj = {};
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.limit] = limit;
    mapObj[APIKeyConstants.stop] = stop;
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId;
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId;
    final url = isBuy ? APIURLConstants.buyStopLimitApp : APIURLConstants.sellStopLimitApp;
    return provider.postRequest(url, mapObj, authHeader());
  }

  Future<ServerResponse> cancelOpenOrderApp(String type, int id) async {
    var mapObj = {};
    mapObj[APIKeyConstants.type] = type;
    mapObj[APIKeyConstants.id] = id;
    return provider.postRequest(APIURLConstants.cancelOpenOrderApp, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> getCurrencyDepositRate(int walletId, int paymentMethodId, double amount,
      {String? currency, String? code, int? bankId, int? walletIdFrom}) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.paymentMethodId] = paymentMethodId;
    mapObj[APIKeyConstants.amount] = amount;

    if (currency.isValid) mapObj[APIKeyConstants.currency] = currency;
    if (code.isValid) mapObj[APIKeyConstants.code] = code;
    if (bankId != null) mapObj[APIKeyConstants.bankId] = bankId;
    if (walletIdFrom != null) mapObj[APIKeyConstants.fromWalletId] = walletIdFrom;
    return provider.postRequest(APIURLConstants.currencyDepositRate, mapObj, authHeader());
  }

  Future<ServerResponse> getFiatWithdrawalRate(String walletId, String currency, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.walletId] = walletId;
    mapObj[APIKeyConstants.currency] = currency;
    mapObj[APIKeyConstants.amount] = amount;
    return provider.postRequest(APIURLConstants.getFiatWithdrawalRate, mapObj, authHeader());
  }

  Future<ServerResponse> currencyDepositProcess(CreateDeposit deposit) async {
    final mapObj = await deposit.toJson();
    return provider.postRequestFormData(APIURLConstants.currencyDepositProcess, mapObj, authHeader());
  }

  Future<ServerResponse> walletCurrencyDeposit(CreateDeposit deposit) async {
    final mapObj = await deposit.toJson();
    return provider.postRequestFormData(APIURLConstants.walletCurrencyDeposit, mapObj, authHeader());
  }

  Future<ServerResponse> walletCurrencyWithdraw(CreateWithdrawal withdraw) async {
    final mapObj = await withdraw.toJson();
    return provider.postRequestFormData(APIURLConstants.walletCurrencyWithdraw, mapObj, authHeader());
  }

  Future<ServerResponse> userBankSave(Bank bank) async {
    var mapObj = bank.toJson();
    return provider.postRequest(APIURLConstants.userBankSave, mapObj, authHeader());
  }

  Future<ServerResponse> userBankDelete(int id) async {
    return provider.postRequest(APIURLConstants.userBankDelete, {APIKeyConstants.id: id}, authHeader());
  }

  Future<ServerResponse> fiatWithdrawalProcess(CreateWithdrawal withdrawal) async {
    var mapObj = await withdrawal.toJson();
    return provider.postRequest(APIURLConstants.fiatWithdrawalProcess, mapObj, authHeader());
  }

  Future<ServerResponse> investmentCanceled(String uid) async {
    var mapObj = {};
    mapObj[APIKeyConstants.uid] = uid;
    return provider.postRequest(APIURLConstants.investmentCanceled, mapObj, authHeader());
  }

  Future<ServerResponse> totalInvestmentBonus(String uid, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.uid] = uid;
    mapObj[APIKeyConstants.amount] = amount;
    return provider.postRequest(APIURLConstants.totalInvestmentBonus, mapObj, authHeader());
  }

  Future<ServerResponse> investmentSubmit(String uid, double amount, int autoRenew) async {
    var mapObj = {};
    mapObj[APIKeyConstants.uid] = uid;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.autoRenewStatus] = autoRenew;
    return provider.postRequest(APIURLConstants.investmentSubmit, mapObj, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> giftCardBuy(
      String bannerId, String coinType, int walletType, double amount, int quantity, int lock, int bulk, String note) async {
    var mapObj = {};
    mapObj[APIKeyConstants.bannerId] = bannerId;
    mapObj[APIKeyConstants.coinType] = coinType;
    mapObj[APIKeyConstants.walletType] = walletType;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.quantity] = quantity;
    mapObj[APIKeyConstants.lock] = lock;
    mapObj[APIKeyConstants.bulk] = bulk;
    mapObj[APIKeyConstants.note] = note;
    return provider.postRequest(APIURLConstants.giftCardBuyCard, mapObj, authHeader());
  }

  Future<ServerResponse> giftCardUpdate(String cardUid, int lock, String from) async {
    var mapObj = {};
    mapObj[APIKeyConstants.cardUid] = cardUid;
    mapObj[APIKeyConstants.lock] = lock;
    mapObj[APIKeyConstants.from] = from;
    return provider.postRequest(APIURLConstants.giftCardUpdateCard, mapObj, authHeader());
  }

  Future<ServerResponse> p2pWalletBalanceTransfer(String coinType, double amount, int type) async {
    final mapObj = {};
    mapObj[APIKeyConstants.coin] = coinType;
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.type] = type;
    return provider.postRequest(APIURLConstants.p2pWalletBalanceTransfer, mapObj, APIRepository().authHeader());
  }

  Future<ServerResponse> futureTradeWalletBalanceTransfer(int transferFrom, String coinType, double amount) async {
    var mapObj = {};
    mapObj[APIKeyConstants.transferFrom] = transferFrom;
    mapObj[APIKeyConstants.coinType] = coinType;
    mapObj[APIKeyConstants.amount] = amount;
    return provider.postRequest(APIURLConstants.futureTradeWalletBalanceTransfer, mapObj, authHeader());
  }

  Future<ServerResponse> futureTradeUpdateProfitLossLongShortOrder(String orderUid, double takeProfit, double stopLoss) async {
    var mapObj = {};
    mapObj[APIKeyConstants.orderUid] = orderUid;
    mapObj[APIKeyConstants.takeProfit] = takeProfit;
    mapObj[APIKeyConstants.stopLoss] = stopLoss;
    return provider.postRequest(APIURLConstants.futureTradeUpdateProfitLossLongShortOrder, mapObj, authHeader());
  }

  Future<ServerResponse> futureTradeCanceledLongShortOrder(String orderUid) async {
    var mapObj = {};
    mapObj[APIKeyConstants.uid] = orderUid;
    return provider.postRequest(APIURLConstants.futureTradeCanceledLongShortOrder, mapObj, authHeader());
  }

  Future<ServerResponse> futureTradeCloseLongShortAllOrders(int coinPairId, List<Map> dataList) async {
    var mapObj = {};
    mapObj[APIKeyConstants.coinPairId] = coinPairId;
    mapObj[APIKeyConstants.data] = dataList;
    return provider.postRequest(APIURLConstants.futureTradeCloseLongShortAllOrders, mapObj, authHeader());
  }

  Future<ServerResponse> futureTradePrePlaceOrderData(CreateTrade trade) async {
    final mapObj = trade.makeJson(FromKey.check);
    return provider.postRequest(APIURLConstants.futureTradePrePlaceOrderData, mapObj, authHeader());
  }

  Future<ServerResponse> futureTradePlacedBuyOrder(CreateTrade trade) async {
    final mapObj = trade.makeJson(FromKey.buy);
    return provider.postRequest(APIURLConstants.futureTradePlacedBuyOrder, mapObj, authHeader());
  }

  Future<ServerResponse> futureTradePlacedSellOrder(CreateTrade trade) async {
    final mapObj = trade.makeJson(FromKey.sell);
    return provider.postRequest(APIURLConstants.futureTradePlacedSellOrder, mapObj, authHeader());
  }

  Future<ServerResponse> futureTradePlaceCloseLongShortOrder(CreateTrade trade) async {
    final mapObj = trade.makeJson(FromKey.close);
    return provider.postRequest(APIURLConstants.futureTradePlaceCloseLongShortOrder, mapObj, authHeader());
  }

  /// *** ------------ *** ///
  /// *** GET requests *** ///
  /// *** ------------ *** ///

  Future<ServerResponse> getDashBoardData(String key) async {
    return provider.getRequest(APIURLConstants.getAppDashboard + key, authHeader());
  }

  Future<ServerResponse> getExchangeChartDataApp(int baseCoinId, int tradeCoinId, int interval) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.interval] = interval.toString();
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getExchangeChartDataApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getExchangeOrderList(String orderType, int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.dashboardType] = "dashboard";
    mapObj[APIKeyConstants.orderType] = orderType;
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getExchangeAllOrdersApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getExchangeTradeList(int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.dashboardType] = "dashboard";
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getExchangeMarketTradesApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getTradeHistoryList(int baseCoinId, int tradeCoinId, String orderType) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.dashboardType] = "dashboard";
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    if (orderType != FromKey.trade) mapObj[APIKeyConstants.orderType] = orderType;
    final url = orderType == FromKey.trade ? APIURLConstants.getMyTradesApp : APIURLConstants.getMyAllOrdersApp;
    return provider.getRequest(url, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getSelfProfile() async {
    return provider.getRequest(APIURLConstants.getProfile, authHeader());
  }

  Future<ServerResponse> getKYCDetails() async {
    return provider.getRequest(APIURLConstants.getKYCDetails, authHeader());
  }

  Future<ServerResponse> getUserKYCSettingsDetails() async {
    return provider.getRequest(APIURLConstants.getUserKYCSettingsDetails, authHeader());
  }

  Future<ServerResponse> getUserSetting() async {
    return provider.getRequest(APIURLConstants.getUserSetting, authHeader());
  }

  Future<ServerResponse> getUserActivityList() async {
    return provider.getRequest(APIURLConstants.getActivityList, authHeader());
  }

  Future<ServerResponse> getCommonSettings() async {
    return provider.getRequest(APIURLConstants.getCommonSettingsWithLanding, authHeader());
  }

  Future<ServerResponse> getWalletBalanceDetails(String coinType) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.coinType] = coinType;
    return provider.getRequest(APIURLConstants.getWalletBalanceDetails, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getWalletList(int page, {int? type, String? search}) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.perPage] = DefaultValue.listLimitLarge.toString();
    mapObj[APIKeyConstants.search] = search ?? "";
    if (type != WalletViewType.p2p) mapObj[APIKeyConstants.type] = type.toString();
    final url = type == WalletViewType.p2p
        ? APIURLConstants.getP2pWalletList
        : (type == WalletViewType.future ? APIURLConstants.getFutureTradeWalletList : APIURLConstants.getWalletList);
    return provider.getRequest(url, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getWalletDeposit(int id) async {
    return provider.getRequest(APIURLConstants.getWalletDeposit + id.toString(), authHeader(), isDynamic: true);
  }

  Future<ServerResponse> getWalletWithdrawal(int id) async {
    return provider.getRequest(APIURLConstants.getWalletWithdrawal + id.toString(), authHeader(), isDynamic: true);
  }

  Future<ServerResponse> getActivityList(int page, String type, {String? search, bool? isFiat}) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.perPage] = DefaultValue.listLimitMedium.toString();
    if (search.isValid) mapObj[APIKeyConstants.search] = search ?? "";
    if (type != HistoryType.stopLimit) mapObj[APIKeyConstants.type] = type;
    mapObj[APIKeyConstants.columnName] = type == HistoryType.transaction ? APIKeyConstants.time : APIKeyConstants.createdAt;
    mapObj[APIKeyConstants.orderBy] = APIKeyConstants.vOrderDESC;
    String url = "";
    if (type == HistoryType.deposit) {
      url = isFiat ?? false ? APIURLConstants.getWalletCurrencyDepositHistory : APIURLConstants.getWalletHistoryApp;
    } else if (type == HistoryType.withdraw) {
      url = isFiat ?? false ? APIURLConstants.getWalletCurrencyWithdrawHistory : APIURLConstants.getWalletHistoryApp;
    } else if (type == HistoryType.swap) {
      url = APIURLConstants.getCoinConvertHistoryApp;
    } else if (type == HistoryType.buyOrder) {
      url = APIURLConstants.getAllBuyOrdersHistoryApp;
    } else if (type == HistoryType.sellOrder) {
      url = APIURLConstants.getAllSellOrdersHistoryApp;
    } else if (type == HistoryType.transaction) {
      url = APIURLConstants.getAllTransactionHistoryApp;
    } else if (type == HistoryType.fiatDeposit) {
      url = APIURLConstants.getCurrencyDepositHistory;
    } else if (type == HistoryType.fiatWithdrawal) {
      url = APIURLConstants.getFiatWithdrawalHistory;
    } else if (type == HistoryType.stopLimit) {
      url = APIURLConstants.getAllStopLimitOrdersApp;
    } else if (type == HistoryType.refEarningTrade || type == HistoryType.refEarningWithdrawal) {
      mapObj[APIKeyConstants.type] = (type == HistoryType.refEarningTrade ? 2 : 1).toString();
      url = APIURLConstants.getReferralHistory;
    }
    return provider.getRequest(url, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getCoinRate(String amount, int fromId, int toId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.amount] = amount;
    mapObj[APIKeyConstants.fromCoinId] = fromId.toString();
    mapObj[APIKeyConstants.toCoinId] = toId.toString();
    return provider.getRequest(APIURLConstants.getRateApp, authHeader(), query: mapObj, isDynamic: true);
  }

  Future<ServerResponse> getCoinSwapApp() async {
    return provider.getRequest(APIURLConstants.getCoinSwapApp, authHeader());
  }

  Future<ServerResponse> twoFALoginEnableDisable() async {
    return provider.getRequest(APIURLConstants.getSetupGoogle2faLogin, authHeader());
  }

  Future<ServerResponse> getFAQList(int page, {int? type}) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.perPage] = DefaultValue.listLimitLarge.toString();
    if (type != null) {
      mapObj[APIKeyConstants.faqTypeId] = type.toString();
    }
    return provider.getRequest(APIURLConstants.getFaqList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getNotifications() async {
    return provider.getRequest(APIURLConstants.getNotifications, authHeader());
  }

  Future<ServerResponse> getReferralApp() async {
    return provider.getRequest(APIURLConstants.getReferralApp, authHeader());
  }

  Future<ServerResponse> getCurrencyDepositData() async {
    return provider.getRequest(APIURLConstants.getCurrencyDeposit, authHeader());
  }

  Future<ServerResponse> getWalletCurrencyDeposit() async {
    return provider.getRequest(APIURLConstants.getWalletCurrencyDeposit, authHeader());
  }

  Future<ServerResponse> getWalletCurrencyWithdraw() async {
    return provider.getRequest(APIURLConstants.getWalletCurrencyWithdraw, authHeader());
  }

  Future<ServerResponse> getFiatWithdrawal() async {
    return provider.getRequest(APIURLConstants.getFiatWithdrawal, authHeader());
  }

  Future<ServerResponse> getUserBankList() async {
    return provider.getRequest(APIURLConstants.getUserBankList, authHeader());
  }

  Future<ServerResponse> getCurrencyList() async {
    return provider.getRequest(APIURLConstants.getCurrencyList, authHeader());
  }

  Future<ServerResponse> getMarketOverviewCoinStatisticList(String currency) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.currencyType] = currency;
    return provider.getRequest(APIURLConstants.getMarketOverviewCoinStatisticList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getMarketOverviewTopCoinList(int page, String currency, int type, {String? search}) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.limit] = DefaultValue.listLimitLarge.toString();
    mapObj[APIKeyConstants.currencyType] = currency;
    mapObj[APIKeyConstants.type] = type.toString();
    mapObj[APIKeyConstants.search] = search ?? "";
    return provider.getRequest(APIURLConstants.getMarketOverviewTopCoinList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getStakingOfferList() async {
    return provider.getRequest(APIURLConstants.getStakingOfferList, authHeader());
  }

  Future<ServerResponse> getStakingLandingDetails() async {
    return provider.getRequest(APIURLConstants.getStakingLandingDetails, authHeader());
  }

  Future<ServerResponse> getStakingInvestmentStatistics() async {
    return provider.getRequest(APIURLConstants.getStakingInvestmentStatistics, authHeader());
  }

  Future<ServerResponse> getStakingOfferDetails(String uid) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.uid] = uid;
    return provider.getRequest(APIURLConstants.getStakingOfferDetails, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getStakingInvestmentList(int page) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.limit] = DefaultValue.listLimitMedium.toString();
    return provider.getRequest(APIURLConstants.getStakingInvestmentList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getStakingInvestmentPaymentList(int page) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.limit] = DefaultValue.listLimitMedium.toString();
    return provider.getRequest(APIURLConstants.getStakingInvestmentPaymentList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardMainPageData() async {
    return provider.getRequest(APIURLConstants.getGiftCardMainPage, authHeader());
  }

  Future<ServerResponse> getGiftCardCheck(String code) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.code] = code;
    return provider.getRequest(APIURLConstants.getGiftCardCheck, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardRedeemCode(String uid, String pasword) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.cardUid] = uid;
    mapObj[APIKeyConstants.password] = pasword;
    return provider.getRequest(APIURLConstants.getGiftCardRedeemCode, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardThemeData() async {
    return provider.getRequest(APIURLConstants.getGiftCardThemeData, authHeader());
  }

  Future<ServerResponse> getGiftCardThemes(int page, String uid) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.limit] = DefaultValue.listLimitLarge.toString();
    mapObj[APIKeyConstants.uid] = uid;
    return provider.getRequest(APIURLConstants.getGiftCardThemes, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardMyPageData() async {
    return provider.getRequest(APIURLConstants.getGiftCardMyPageData, authHeader());
  }

  Future<ServerResponse> getGiftCardMyCardList(int page, String status) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.limit] = DefaultValue.listLimitLarge.toString();
    mapObj[APIKeyConstants.status] = status;
    return provider.getRequest(APIURLConstants.getGiftCardMyCardList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardBuyData(String uid) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.uid] = uid;
    return provider.getRequest(APIURLConstants.getGiftCardBuyData, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardWalletData(String coinType) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.coinType] = coinType;
    return provider.getRequest(APIURLConstants.getGiftCardWalletData, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardRedeem(String code) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.code] = code;
    return provider.getRequest(APIURLConstants.getGiftCardRedeem, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardAdd(String code) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.code] = code;
    return provider.getRequest(APIURLConstants.getGiftCardAdd, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getGiftCardSend(String cardUid, int sendType, String sendId, String? message) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.cardUid] = cardUid;
    mapObj[APIKeyConstants.sendBy] = sendType.toString();
    if (GiftCardSendType.email == sendType) {
      mapObj[APIKeyConstants.toEmail] = sendId;
    } else if (GiftCardSendType.phone == sendType) {
      mapObj[APIKeyConstants.toPhone] = sendId;
    }
    mapObj[APIKeyConstants.message] = message ?? "";
    return provider.getRequest(APIURLConstants.getGiftCardSend, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureExchangeMarketDetail(int page, String type) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = "$page";
    mapObj[APIKeyConstants.limit] = DefaultValue.listLimitMedium.toString();
    mapObj[APIKeyConstants.type] = type;
    return provider.getRequest(APIURLConstants.getFutureTradeExchangeMarketDetail, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeAppDashboard(String key) async {
    return provider.getRequest(APIURLConstants.getFutureTradeAppDashboard + key, authHeader(), isDynamic: true);
  }

  Future<ServerResponse> getFutureTradeExchangeMarketTradesApp(int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.dashboardType] = "dashboard";
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getFutureTradeExchangeMarketTradesApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeLongShortPositionOrderList(int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getFutureTradeLongShortPositionOrderList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeLongShortOpenOrderList(int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getFutureTradeLongShortOpenOrderList, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeLongShortOrderHistory(int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getFutureTradeLongShortOrderHistory, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeLongShortTransactionHistory(int coinPairId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.coinPairId] = coinPairId.toString();
    return provider.getRequest(APIURLConstants.getFutureTradeLongShortTransactionHistory, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeLongShortTradeHistory(int baseCoinId, int tradeCoinId) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.baseCoinId] = baseCoinId.toString();
    mapObj[APIKeyConstants.tradeCoinId] = tradeCoinId.toString();
    return provider.getRequest(APIURLConstants.getFutureTradeLongShortTradeHistory, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeMyAllOrdersApp() async {
    var mapObj = <String, String>{};
    return provider.getRequest(APIURLConstants.getFutureTradeMyAllOrdersApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeMyTradesApp() async {
    var mapObj = <String, String>{};
    return provider.getRequest(APIURLConstants.getFutureTradeMyTradesApp, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getFutureTradeTakeProfitStopLossDetails(String uid) async {
    var mapObj = <String, String>{};
    return provider.getRequest(APIURLConstants.getFutureTradeTakeProfitStopLossDetails + uid, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getBlogNewsSettings() async {
    return provider.getRequest(APIURLConstants.getBlogNewsSettings, authHeader());
  }

  Future<ServerResponse> getBlogCategoryList() async {
    return provider.getRequest(APIURLConstants.getBlogCategory, authHeader());
  }

  Future<ServerResponse> getBlogListType(int type, int limit, int page) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = page.toString();
    mapObj[APIKeyConstants.limit] = limit.toString();
    mapObj[APIKeyConstants.type] = type.toString();
    return provider.getRequest(APIURLConstants.getBlogListType, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getBlogListCategory(String id, int limit, int page) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = page.toString();
    mapObj[APIKeyConstants.limit] = limit.toString();
    mapObj[APIKeyConstants.category] = id;
    mapObj[APIKeyConstants.subCategory] = "0";
    return provider.getRequest(APIURLConstants.getBlogListType, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getBlogSearch(String query) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.value] = query;
    return provider.getRequest(APIURLConstants.getBlogSearch, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getBlogDetails(String slug) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.id] = slug;
    return provider.getRequest(APIURLConstants.getBlogDetails, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getNewsCategoryList() async {
    return provider.getRequest(APIURLConstants.getNewsCategory, authHeader());
  }

  Future<ServerResponse> getNewsListType(int type, int limit, int page) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = page.toString();
    mapObj[APIKeyConstants.limit] = limit.toString();
    mapObj[APIKeyConstants.type] = type.toString();
    return provider.getRequest(APIURLConstants.getNewsListType, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getNewsListCategory(String id, int limit, int page) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.page] = page.toString();
    mapObj[APIKeyConstants.limit] = limit.toString();
    mapObj[APIKeyConstants.category] = id;
    mapObj[APIKeyConstants.subCategory] = "0";
    return provider.getRequest(APIURLConstants.getNewsListType, authHeader(), query: mapObj);
  }

  Future<ServerResponse> getNewsDetails(String slug) async {
    var mapObj = <String, String>{};
    mapObj[APIKeyConstants.id] = slug;
    return provider.getRequest(APIURLConstants.getNewsDetails, authHeader(), query: mapObj);
  }

  /// *** ---------------- *** ///
  /// *** SOCKET requests *** ///
  /// *** -------------- *** ///
  void subscribeEvent(String channel, SocketListener listener) {
    socketProvider.subscribeEvent(channel, listener);
  }

  void unSubscribeEvent(String channel, SocketListener? listener) {
    socketProvider.unSubscribeEvent(channel, listener);
  }

  void unSubscribeAllChannels() {
    socketProvider.unSubscribeAllChannel();
  }

  /// *** ---------------- *** ///
  /// *** Others requests *** ///
  /// *** -------------- *** ///
// Future<ServerResponse> getMarketPrice(String currency, List<String> idList) async {
//   var mapObj = <String, dynamic>{};
//   mapObj["fsyms"] = idList;
//   mapObj["tsyms"] = currency;
//   return provider.getRequestWithFullUrl(URLConstants.cryptoComparePriceFull, query: mapObj);
// }
//
// Future<ServerResponse> getNetworkInfo() async {
//   return provider.getRequestWithFullUrl(URLConstants.networkInfo);
// }
}

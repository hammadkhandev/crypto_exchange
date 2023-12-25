import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tradexpro_flutter/data/models/dashboard_data.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/utils/colors.dart';

Rx<User> gUserRx = User(id: 0).obs;
bool gIsDarkMode = !false;
bool gIsLandingScreenShowed = false;
String gUserAgent = "";
Color gBuyColor = Colors.green;
Color gSellColor = Colors.red;
BuildContext? currentContext;

class TemporaryData {
  static bool? isFutureTradeViewShowing;
  static CoinPair? futureCoinPair;
  static String? activityType;
}

enum IdVerificationType { none, nid, passport, driving, voter }

enum PhotoType { front, back, selfie }

class AssetConstants {
  //ICONS
  static const basePathIcons = "assets/icons/";
  static String icLogo = gIsDarkMode ? icLogoDark : icLogoLight;
  static const icLogoLight =  "${basePathIcons}icLogo.svg";
  static const icLogoDark = "${basePathIcons}icLogoDark.png";
  static const icLogoWithTitle = "${basePathIcons}icLogoWithTitle.svg";
  static const icBottomBgMark = "${basePathIcons}icBottomBgMark.svg";
  static const icBottomBgMarkDark = "${basePathIcons}icBottomBgMarkDark.svg";
  static const icBottomBgAuth = "${basePathIcons}icBottomBgAuth.svg";
  static const icTopBgMark = "${basePathIcons}icTopBgMark.svg";
  static const icEllipseBg = "${basePathIcons}icEllipseBg.svg";
  static const icEmail = "${basePathIcons}ic_email.svg";
  static const icFingerprintScan = "${basePathIcons}ic_fingerprint_scan.svg";
  static const icKey = "${basePathIcons}ic_key.svg";
  static const icDelete = "${basePathIcons}ic_delete.svg";
  static const icSmartphone = "${basePathIcons}ic_smartphone.svg";
  static const icUpload = "${basePathIcons}ic_upload.svg";
  static const icRibbon = "${basePathIcons}ic_ribbon.png";
  static const icInfoCircle = "${basePathIcons}ic_info_circle.svg";
  static const icMessage = "${basePathIcons}ic_message.svg";
  static const icStaking = "${basePathIcons}ic_staking.png";
  static const icGift = "${basePathIcons}ic_gift.png";
  static const icFuture = "${basePathIcons}ic_future.png";
  static const icMarket = "${basePathIcons}ic_market.png";
  static const icIco = "${basePathIcons}ic_ico.png";
  static const icBlog = "${basePathIcons}ic_blog.png";
  static const icNewspaper = "${basePathIcons}ic_newspaper.png";


  ///IMAGES
  static const basePathImages = "assets/images/";
  static const bgSplash = "${basePathImages}bgSplash.png";
  static const icAuthenticator = "${basePathImages}icGoogleAuthenticatorLogo.png";
  static const imgDrivingLicense = "${basePathImages}img_driving_license.png";
  static const imgNID = "${basePathImages}img_NID.png";
  static const imgPassport = "${basePathImages}img_passport.png";
  static const imgVoterCard = "${basePathImages}img_voter_card.png";

  //////////
  static const pathTempImageFolder = "/tmpImages/";
  static const pathTempFrontImageName = "_frontImage_id_verify.jpeg";
  static const pathTempBackImageName = "_backImage_id_verify.jpeg";

  static const avatar = "${basePathImages}avatar.png";
  static const noImage = "${basePathImages}noImage.png";
  static const imgNotAvailable = "${basePathImages}imageNotAvailable.png";

  static const bgScreen = "${basePathImages}bgScreen.png";
  static const bgAuth = "${basePathImages}bgAuth.png";
  static const bgAuthTop = "${basePathImages}bgAuthTop.png";
  static const bgAuthMiddle = "${basePathImages}bgAuthMiddle.png";
  static const bgAuthMiddleDark = "${basePathImages}bgAuthMiddleDark.png";
  static const bgAuthBottomLeft = "${basePathImages}bgAuthBottomLeft.png";
  static const bgAppBar = "${basePathImages}bgAppBar.png";
  static const bgAppBar2 = "${basePathImages}bgAppBar2.png";
  static const bg = "${basePathImages}bg.png";
  static const bg2 = "${basePathImages}bg2.png";
  static const bgNavHeader = "${basePathImages}bgNavHeader.png";
  static const qr = "${basePathImages}qr.png";
  static const btcChart = "${basePathImages}btcChart.png";
  static const learn = "${basePathImages}learn.png";

  static const bgOnBoarding = "${basePathImages}bgOnBoarding.png";
  static const onBoarding0 = "${basePathImages}onBoarding0.png";
  static const onBoarding1 = "${basePathImages}onBoarding1.png";
  static const onBoarding2 = "${basePathImages}onBoarding2.png";

  static const icGoogleAuthenticatorLogo = "${basePathImages}icGoogleAuthenticatorLogo.png";
  static const icEmptyDataPng = "${basePathImages}icEmptyDataPng.png";
  static const chartOverview = "${basePathImages}chartOverview.png";

  static const icArrowLeft = "${basePathIcons}ic_arrow_left.svg";
  static const icArrowRight = "${basePathIcons}ic_arrow_right.svg";
  static const icArrowDown = "${basePathIcons}ic_arrow_down.svg";
  static const icCloseBox = "${basePathIcons}ic_close_box.svg";
  static const icPasswordHide = "${basePathIcons}ic_password_hide.svg";
  static const icPasswordShow = "${basePathIcons}ic_password_show.svg";
  static const icBoxSquare = "${basePathIcons}ic_box_square.svg";
  static const icTickRound = "${basePathIcons}ic_tick_round.svg";
  static const icTickSquare = "${basePathIcons}ic_tick_square.svg";
  static const icTickLarge = "${basePathIcons}icTickLarge.svg";
  static const icTime = "${basePathIcons}icTime.svg";
  static const icBoxFilterAll = "${basePathIcons}icBoxFilterAll.svg";
  static const icBoxFilterSell = "${basePathIcons}icBoxFilterSell.svg";
  static const icBoxFilterBuy = "${basePathIcons}icBoxFilterBuy.svg";
  static const icCrossIsolated = "${basePathIcons}icCrossIsolated.svg";
  static const icAccentDot = "${basePathIcons}icAccentDot.svg";

  static const icCamera = "${basePathIcons}ic_camera.svg";
  static const icNotification = "${basePathIcons}icNotification.svg";
  static const icMenu = "${basePathIcons}icMenu.svg";
  static const icDashboard = "${basePathIcons}icDashboard.svg";
  static const icActivity = "${basePathIcons}icActivity.svg";
  static const icWallet = "${basePathIcons}icWallet.svg";
  static const icProfile = "${basePathIcons}ic_profile.svg";

  static const icNavActivity = "${basePathIcons}icNavActivity.svg";
  static const icNavLogout = "${basePathIcons}icNavLogout.svg";
  static const icNavPersonalVerification = "${basePathIcons}icNavPersonalVerification.svg";
  static const icNavProfile = "${basePathIcons}icNavProfile.svg";
  static const icNavReferrals = "${basePathIcons}icNavReferrals.svg";
  static const icNavResetPassword = "${basePathIcons}icNavResetPassword.svg";
  static const icNavSecurity = "${basePathIcons}icNavSecurity.svg";
  static const icNavSettings = "${basePathIcons}icNavSettings.svg";

  static const icHomeTabSelected = "${basePathIcons}ic_home_tab_selected.svg";
  static const icExplore = "${basePathIcons}ic_explore.svg";
  static const icExploreTabSelected = "${basePathIcons}ic_explore_tab_selected.svg";
  static const icFavorite = "${basePathIcons}ic_favorite.svg";
  static const icFavoriteTabSelected = "${basePathIcons}ic_favorite_tab_selected.svg";
  static const icFavoriteFill = "${basePathIcons}ic_favorite_fill.svg";
  static const icCategory = "${basePathIcons}ic_category.svg";
  static const icCategoryFill = "${basePathIcons}ic_category_fill.svg";
  static const icCategoryTabSelected = "${basePathIcons}ic_category_tab_selected.svg";
  static const icStatus = "${basePathIcons}ic_status.svg";
  static const icStatusTabSelected = "${basePathIcons}ic_status_tab_selected.svg";

  static const icOption = "${basePathIcons}icOption.svg";
  static const icFilter = "${basePathIcons}icFilter.svg";
  static const icFilterTwo = "${basePathIcons}icFilterTwo.svg";
  static const icFavoriteStar = "${basePathIcons}icFavoriteStar.svg";
  static const icEmptyData = "${basePathIcons}icEmptyData.svg";
  static const icBack = "${basePathIcons}icBack.svg";
  static const icSearch = "${basePathIcons}icSearch.svg";
  static const icCoinLogo = "${basePathIcons}icCoinLogo.svg";

  static const icTether = "${basePathIcons}icTether.svg";
  static const icTotalHoldings = "${basePathIcons}icTotalHoldings.svg";
  static const icCryptoFill = "${basePathIcons}icCryptoFill.svg";
  static const icCross = "${basePathIcons}icCross.svg";
  static const icCopy = "${basePathIcons}icCopy.svg";
  static const icCelebrate = "${basePathIcons}icCelebrate.svg";
  static const icTwitter = "${basePathIcons}ic_twitter.svg";
  static const icLinkedin = "${basePathIcons}ic_linkedin.svg";


  static const icEditRoundBg = "${basePathIcons}icEditRoundBg.png";
}

class FromKey {
  static const up = "up";
  static const down = "down";
  static const buy = "buy";
  static const sell = "sell";
  static const all = "all";
  static const buySell = "buy_sell";
  static const trade = "trade";
  static const dashboard = "dashboard";
  static const check = "check";
  static const home = "home";
  static const future = "future";
  static const open = "open";
  static const close = "close";
}

class HistoryType {
  static const deposit = "deposit";
  static const withdraw = "withdraw";
  static const stopLimit = "stop_limit";
  static const swap = "swap";
  static const buyOrder = "buy_order";
  static const sellOrder = "sell_order";
  static const transaction = "transaction";
  static const fiatDeposit = "fiat_deposit";
  static const fiatWithdrawal = "fiat_withdrawal";
  static const refEarningWithdrawal = "ref_earning_withdrawal";
  static const refEarningTrade = "ref_earning_trade";
}

class PreferenceKey {
  static const isDark = 'is_dark';
  static const languageKey = "language_key";
  static const isOnBoardingDone = 'is_on_boarding_done';
  static const isLoggedIn = "is_logged_in";
  static const accessToken = "access_token";
  static const accessTokenEvm = "evm_access_token";
  static const accessType = "access_type";
  static const userObject = "user_object";
  static const settingsObject = "settings_object";
  static const mediaList = "media_list";
  static const buySellColorIndex = "buy_sell_color_index";
  static const buySellUpDown = "buy_sell_up_down";
}

class DefaultValue {
  static const int kPasswordLength = 6;
  static const int codeLength = 6;
  static const String currency = "USD";
  static const String currencySymbol = "\$";
  static const String crispKey = "encrypt";

  static const int listLimitLarge = 20;
  static const int listLimitMedium = 10;
  static const int listLimitOrderBook = 10;
  static const int listLimitShort = 5;

  static const bool showLanding = true;

  static const String randomImage =
      "https://media.istockphoto.com/photos/high-angle-view-of-a-lake-and-forest-picture-id1337232523"; //"https://picsum.photos/200";
}

class ListConstants {
  static const List<String> percents = ['25', '50', '75', '100'];
  static const List<int> leverages = [1, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

  static const List<String> coinType = ["BTC", "LTCT", "ETH", "LTC", "DOGE", "BCH", "DASH", "ETC", "USDT"];
  static const kCategoryColorList = [Color(0xff1F78FC), Color(0xffE30261), Color(0xffD200A4), Color(0xffFFA800), cUfoGreen, cSlateGray];
}

class EnvKeyValue {
  static const kStripKey = "stripKey";
  static const kEnvFile = ".env";
  static const kModePaypal = "modePaypal";
  static const kClientIdPaypal = "clientIdPaypal";
  static const kSecretPaypal = "secretPaypal";
  static const kApiSecret = "apiSecret";
}

class IdVerificationStatus {
  static const notSubmitted = "Not Submitted";
  static const pending = "Pending";
  static const accepted = "Approved";
  static const rejected = "Rejected";
}

class UserStatus {
  static const pending = 0;
  static const accepted = 1;
  static const rejected = 2;
  static const suspended = 4;
  static const deleted = 5;
}

class PaymentMethodType {
  static const paypal = 3;
  static const bank = 4;
  static const card = 5;
  static const wallet = 6;
}

class FAQType {
  static const main = 1;
  static const deposit = 2;
  static const withdrawn = 3;
  static const buy = 4;
  static const sell = 5;
  static const coin = 6;
  static const wallet = 7;
  static const trade = 8;
}

class StakingInvestmentStatus {
  static const running = 1;
  static const canceled = 2;
  static const unpaid = 3;
  static const paid = 4;
  static const success = 5;
}

class StakingTermsType {
  static const strict = 1;
  static const flexible = 2;
}

class StakingRenewType {
  static const manual = 1;
  static const auto = 2;
}

class GiftCardStatus {
  static const active = 1;
  static const redeemed = 2;
  static const transferred = 3;
  static const trading = 4;
  static const locked = 5;
}

class GiftCardCheckStatus {
  static const redeem = 1;
  static const add = 2;
  static const check = 3;
}

class GiftCardSendType {
  static const email = 1;
  static const phone = 2;
}

class WalletType {
  static const spot = 1;
  static const p2p = 2;
}

class FutureMarketKey {
  static const assets = "assets";
  static const hour = "hour";
  static const new_ = "new";
}

class FTTransactionType {
  static const transfer = 1;
  static const commission = 2;
  static const fundingFee = 3;
  static const realizedPnl = 4;
}

class FutureTradeType {
  static const open = 1;
  static const close = 2;
  static const takeProfitClose = 3;
  static const stopLossClose = 4;
}

class TradeType {
  static const buy = 1;
  static const sell = 2;
}

class OrderType {
  static const limit = 1;
  static const market = 2;
  static const stopLimit = 3;
  static const stopMarket = 4;
}

class MarginMode {
  static const isolate = 1;
  static const cross = 2;
}

class CurrencyType {
  static const crypto = 1;
  static const fiat = 2;
}

class WalletViewType {
  static const overview = 0;
  static const spot = 1;
  static const future = 2;
  static const p2p = 3;
}

/// # trc20Token, evmBaseCoin => network list; # coinPayment && USDT => network list(coin payment)
class NetworkType {
  static const coinPayment = 1;
  static const bitcoinApi = 2;
  static const bitGoApi = 3;
  static const trc20Token = 6;
  static const evmBaseCoin = 8;
}

class BlogNewsType {
  static const recent = 1;
  static const popular = 2;
  static const feature = 3;
}
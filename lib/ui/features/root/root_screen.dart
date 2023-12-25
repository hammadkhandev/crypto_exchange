import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/models/settings.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/activity/activity_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/dashboard/dashboard_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/fiat/fiat_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/future_trade/future_trade_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/market/market_future/future_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/market/market_spot/market_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/wallet_screen.dart';
import 'package:tradexpro_flutter/ui/features/root/custom_icon_icons.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/blog/blog_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/faq/faq_page.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/gift_cards/gift_cards_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/profile/profile_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/referrals/referrals_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/settings/settings_screen.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/staking/staking_screen.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/colors.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/support/crisp_chat.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/landing/landing_screen.dart';
import 'package:tradexpro_flutter/ui/features/side_navigation/news/news_screen.dart';
import 'root_controller.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  final RootController _controller = Get.put(RootController());
  final autoSizeGroup = AutoSizeGroup();
  final iconList = <IconData>[CustomIcons.dashboard, CustomIcons.wallet, CustomIcons.market, CustomIcons.activity];
  RxBool isKeyBoardShowing = false.obs;
  bool isCurrencyDeposit = false;
  late StreamSubscription<bool> keyboardSubscription;
  Animation<double>? animation;

  int selectedMarketIndex = 0;

  @override
  void initState() {
    currentContext = context;
    isCurrencyDeposit = getSettingsLocal()?.currencyDepositStatus == "1";
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) => isKeyBoardShowing.value = visible);
    if (isCurrencyDeposit) initAnimation();
    _controller.changeBottomNavIndex = changeBottomNavTab;
  }

  @override
  void dispose() {
    hideKeyboard();
    keyboardSubscription.cancel();
    super.dispose();
    currentContext = null;
  }

  void changeBottomNavTab(int index, bool isShowMenu) async {
    final settings = getSettingsLocal();
    if (index == 0 && isShowMenu) {
      List<PopupMenuItem<int>> menuList = [makeMenu('Spot Trading'.tr, 0)];
      if (settings?.enableFutureTrade == 1) menuList.add(makeMenu('Future Trading'.tr, 1));

      if (menuList.length > 1) {
        final menuView = await showMenu<int>(
          context: context,
          items: menuList,
          color: context.theme.focusColor,
          position: RelativeRect.fromLTRB(20, Get.height - 150, Get.width - 150, 0.0),
        );
        if (menuView != null) {
          _controller.selectedTradeIndex = menuView;
          setState(() => _controller.bottomNavIndex = index);
        }
        return;
      }
    } else if (index == 2 && isShowMenu) {
      List<PopupMenuItem<int>> menuList = [makeMenu('Market'.tr, 0)];
      if (settings?.enableFutureTrade == 1) menuList.add(makeMenu('Future Market'.tr, 1));
      if (menuList.length > 1) {
        final menuView = await showMenu<int>(
          context: context,
          items: menuList,
          color: context.theme.focusColor,
          position: RelativeRect.fromLTRB(20, Get.height - 150, 0, 0.0),
        );
        if (menuView != null) {
          selectedMarketIndex = menuView;
          setState(() => _controller.bottomNavIndex = index);
        }
        return;
      }
    }
    _controller.selectedTradeIndex = TemporaryData.futureCoinPair != null ? 1 : 0;
    setState(() => _controller.bottomNavIndex = index);
  }

  PopupMenuItem<int> makeMenu(String title, int value) => PopupMenuItem(
      height: 40, value: value, child: Text(title, style: Get.theme.textTheme.titleSmall!.copyWith(fontSize: Dimens.regularFontSizeMid)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      floatingActionButton: isCurrencyDeposit ? _floatingButtonView() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: _getDrawerNew(),
      bottomNavigationBar: _bottomNavigationView(),
      body: BGViewMain(
        child: SafeArea(
          child: Padding(padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop), child: _getBody()),
        ),
      ),
    );
  }

  void initAnimation() {
    AnimationController animationController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 0.9).animate(curve);
    Future.delayed(const Duration(seconds: 1), () => animationController.forward());
  }

  Widget _floatingButtonView() {
    return Obx(() {
      return isKeyBoardShowing.value
          ? vSpacer0()
          : ScaleTransition(
              scale: animation!,
              child: FloatingActionButton(
                  backgroundColor: Get.theme.focusColor,
                  onPressed: () => changeBottomNavTab(13, false),
                  child: const Icon(Icons.add, size: Dimens.iconSizeMid)));
    });
  }

  Widget _bottomNavigationView() {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final iconColor = gIsDarkMode
            ? Colors.white
            : isActive
                ? context.theme.colorScheme.background
                : context.theme.colorScheme.secondary;
        final bgColor = isActive ? context.theme.colorScheme.secondary : context.theme.colorScheme.background;
        return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
            child: Icon(iconList[index], size: index == 2 ? Dimens.iconSizeMid : Dimens.iconSizeMin, color: iconColor));
      },
      activeIndex: _controller.bottomNavIndex,
      backgroundColor: context.theme.colorScheme.background,
      splashColor: context.theme.colorScheme.secondary,
      leftCornerRadius: Dimens.radiusCornerLarge,
      rightCornerRadius: Dimens.radiusCornerLarge,
      onTap: (index) => changeBottomNavTab(index, true),
      gapLocation: isCurrencyDeposit ? GapLocation.center : GapLocation.none,
      notchAndCornersAnimation: isCurrencyDeposit ? animation : null,
      splashSpeedInMilliseconds: isCurrencyDeposit ? 300 : null,
      notchSmoothness: isCurrencyDeposit ? NotchSmoothness.sharpEdge : null,
    );
  }

  Widget _getBody() {
    switch (_controller.bottomNavIndex) {
      case 0:
        if (_controller.selectedTradeIndex == 0) {
          return const DashboardScreen();
        } else if (_controller.selectedTradeIndex == 1) {
          return const FutureTradeScreen();
        } else {
          return Container();
        }
      case 1:
        return const WalletScreen();
      case 2:
        if (selectedMarketIndex == 0) {
          return const MarketScreen();
        } else if (selectedMarketIndex == 1) {
          return const FutureScreen();
        } else {
          return Container();
        }
      case 3:
        return const ActivityScreen();
      case 13:
        if (DefaultValue.showLanding && !gIsLandingScreenShowed) {
          gIsLandingScreenShowed = true;
          return const LandingScreen();
        }
        return const FiatScreen();
      default:
        return Container();
    }
  }

  _getDrawerNew() {
    return BGViewMain(
      child: Theme(
        data: context.theme.copyWith(canvasColor: Colors.transparent),
        child: Drawer(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            elevation: 0,
            width: context.width,
            child: SafeArea(
              child: Obx(() {
                final hasUser = gUserRx.value.id > 0;
                return ListView(
                  padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        buttonOnlyIcon(
                            iconPath: AssetConstants.icCloseBox, iconColor: context.theme.primaryColorDark, onPressCallback: () => Get.back()),
                      ],
                    ),
                    if (hasUser) _profileView(gUserRx.value) else signInNeedView(isDrawer: true),
                    vSpacer20(),
                    _drawerMenusView(hasUser),
                  ],
                );
              }),
            )),
      ),
    );
  }

  Widget _profileView(User user) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => const ProfileScreen()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showCircleAvatar(user.photo),
            vSpacer10(),
            textAutoSizeKarla(getName(user.firstName, user.lastName), fontSize: Dimens.regularFontSizeLarge),
            vSpacer5(),
            textAutoSizeKarla(user.email ?? "", fontSize: Dimens.regularFontSizeMid, fontWeight: FontWeight.normal),
          ],
        ),
      ),
    );
  }

  _drawerMenusView(bool hasUser) {
    final settings = getSettingsLocal();
    return Column(
      children: [
        if (hasUser)
          _drawerNavMenuItem(navTitle: 'Profile'.tr, iconPath: AssetConstants.icProfile, navAction: () => Get.to(() => const ProfileScreen())),
        if (hasUser)
          _drawerNavMenuItem(
              navTitle: 'Referrals'.tr,
              iconPath: AssetConstants.icNavReferrals,
              navAction: () {
                Get.back();
                Get.to(() => const ReferralsScreen());
              }),
        if (hasUser)
          _drawerNavMenuItem(
              navTitle: 'Activity'.tr,
              iconPath: AssetConstants.icNavActivity,
              navAction: () {
                Get.back();
                changeBottomNavTab(3, false);
              }),
        if (hasUser)
          _drawerNavMenuItem(
              navTitle: 'Settings'.tr,
              iconPath: AssetConstants.icNavSettings,
              navAction: () {
                Get.back();
                Get.to(() => const SettingsScreen());
              }),
        if (hasUser && settings?.liveChatStatus == "1")
          _drawerNavMenuItem(navTitle: 'Support'.tr, iconPath: AssetConstants.icMessage, navAction: () => Get.to(() => const CrispChat())),
        _drawerNavMenuItem(navTitle: 'Staking'.tr, iconPath: AssetConstants.icStaking, navAction: () => Get.to(() => const StakingScreen())),
        if (settings?.enableGiftCard == 1)
          _drawerNavMenuItem(navTitle: 'Gift Cards'.tr, iconPath: AssetConstants.icGift, navAction: () => Get.to(() => const GiftCardsScreen())),
        if (settings?.blogNewsModule == 1)
          _drawerNavMenuItem(navTitle: 'Blog'.tr, iconPath: AssetConstants.icBlog, navAction: () => Get.to(() => const BlogScreen())),
        if (settings?.blogNewsModule == 1)
          _drawerNavMenuItem(navTitle: 'News'.tr, iconPath: AssetConstants.icNewspaper, navAction: () => Get.to(() => const NewsScreen())),
        _drawerNavMenuItem(navTitle: 'FAQ'.tr, iconPath: AssetConstants.icInfoCircle, navAction: () => Get.to(() => const FAQPage())),
        if (hasUser) _drawerNavMenuItem(navTitle: 'Log out'.tr, iconPath: AssetConstants.icNavLogout, navAction: () => _showLogOutAlert()),
        _bottomView(settings),
      ],
    );
  }

  _drawerNavMenuItem({required String navTitle, required String iconPath, VoidCallback? navAction}) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: Dimens.paddingLargeDouble),
      leading: showImageAsset(imagePath: iconPath, color: context.theme.primaryColorLight, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin),
      title: textAutoSizeKarla(navTitle,
          color: context.theme.primaryColorLight, fontWeight: FontWeight.normal, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.left),
      onTap: navAction,
    );
  }

  void _showLogOutAlert() {
    alertForAction(context, title: "Log out".tr, subTitle: "Are you want to logout from app".tr, buttonTitle: "YES".tr, onOkAction: () {
      Get.back();
      _controller.logOut();
    });
  }

  _bottomView(CommonSettings? cSettings) {
    final socialView = _socialMediaView();
    return Container(
      margin: const EdgeInsets.all(Dimens.paddingLarge),
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingLarge, horizontal: Dimens.paddingMid),
      decoration: boxDecorationRoundCorner(),
      child: Column(
        children: [
          if (socialView != null) socialView,
          if (socialView != null) vSpacer10(),
          if (cSettings?.copyrightText.isValid ?? false)
            textSpanWithAction(cSettings?.copyrightText ?? "", " ${cSettings?.appTitle ?? ""}", () => openUrlInBrowser(URLConstants.website),
                maxLines: 2),
        ],
      ),
    );
  }

  _socialMediaView() {
    final objMap = GetStorage().read(PreferenceKey.mediaList);
    if (objMap != null) {
      try {
        final mList = List<SocialMedia>.from(objMap.map((element) => SocialMedia.fromJson(element)));
        if (mList.isValid) {
          return Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: Dimens.paddingMid,
              runSpacing: Dimens.paddingMid,
              children: List.generate(mList.length, (index) {
                final item = mList[index];
                final isValid = item.mediaIcon.isValid && item.mediaLink.isValid;
                return isValid
                    ? showImageNetwork(
                        imagePath: item.mediaIcon,
                        height: Dimens.iconSizeMid,
                        width: Dimens.iconSizeMid,
                        bgColor: Colors.transparent,
                        onPressCallback: () => openUrlInBrowser(item.mediaLink ?? ""))
                    : vSpacer0();
              }));
        }
      } catch (_) {
        printFunction("_socialMediaView error", _);
      }
    }
    return null;
  }
}

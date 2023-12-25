import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/swap/swap_screen.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/wallet/wallet_overview_page.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'wallet_controller.dart';
import 'wallet_list_page.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  WalletScreenState createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> {
  final _controller = Get.put(WalletController());
  late bool isSwap;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      isSwap = (getSettingsLocal()?.swapStatus ?? 0) == 1;
      return gUserRx.value.id == 0
          ? Column(children: [appBarMain(context, title: "Wallet".tr), signInNeedView()])
          : Column(
              children: [
                appBarMain(context, title: "Wallet".tr, subActionIcon: isSwap ? Icons.swap_horizontal_circle_outlined : null, subIconPress: () {
                  if (isSwap) Get.to(() => const SwapScreen());
                }),
                dropDownListIndex(_controller.getTypeMap().values.toList(), _controller.selectedTypeIndex.value, "".tr,
                    (value) => _controller.selectedTypeIndex.value = value),
                _topButtonView(),
                _getBodyPage()
              ],
            );
    });
  }

  _getBodyPage() {
    int key = _controller.getTypeMap().keys.toList()[_controller.selectedTypeIndex.value];
    switch (key) {
      case WalletViewType.overview:
        return const WalletOverviewPage();
      case WalletViewType.spot:
      case WalletViewType.future:
      case WalletViewType.p2p:
        return WalletListPage(fromType: key);
      default:
        return Container();
    }
  }

  _topButtonView() {
    final pColor = context.theme.primaryColor;
    return Row(
      children: [
        hSpacer10(),
        buttonOnlyIcon(
            iconData: Icons.wallet_rounded,
            iconColor: pColor,
            size: Dimens.iconSizeMid,
            visualDensity: minimumVisualDensity,
            onPressCallback: () => _openActivityPage(HistoryType.deposit)),
        hSpacer10(),
        buttonOnlyIcon(
            iconData: Icons.drive_folder_upload_rounded,
            iconColor: pColor,
            size: Dimens.iconSizeMid,
            visualDensity: minimumVisualDensity,
            onPressCallback: () => _openActivityPage(HistoryType.withdraw)),
        hSpacer10(),
        buttonOnlyIcon(
            iconData: Icons.view_list_rounded,
            iconColor: pColor,
            size: Dimens.iconSizeMid,
            visualDensity: minimumVisualDensity,
            onPressCallback: () => _openActivityPage(HistoryType.transaction)),
        hSpacer10(),
        if (_controller.selectedTypeIndex.value != WalletViewType.overview)
          Expanded(
              child: textFieldSearch(
                  controller: _controller.searchController, height: Dimens.btnHeightMid, margin: 0, onTextChange: _controller.onTextChanged)),
        hSpacer10(),
      ],
    );
  }

  void _openActivityPage(String type) {
    TemporaryData.activityType = type;
    getRootController().changeBottomNavIndex(3, false);
  }
}

import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'wallet_controller.dart';
import 'wallet_widgets.dart';

// ignore_for_file: must_be_immutable
class WalletListPage extends StatelessWidget {
  WalletListPage({super.key, required this.fromType});

  final int fromType;
  final _controller = Get.find<WalletController>();
  final _scrollController = ScrollController();

  void initViewData() {
    _controller.walletListFromType = fromType;
    _controller.clearListView();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.refreshController.callRefresh();
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          if (_controller.hasMoreData) _controller.getWalletList(isFromLoadMore: true);
        }
      });
    });
  }

  Future<void> _getWalletListData() async => _controller.getWalletList(isFromLoadMore: false);

  @override
  Widget build(BuildContext context) {
    initViewData();
    return Expanded(
      child: EasyRefresh(
        controller: _controller.refreshController,
        refreshOnStart: false,
        onRefresh: _getWalletListData,
        header: ClassicHeader(showText: false, iconTheme: const IconThemeData().copyWith(color: context.theme.colorScheme.secondary)),
        child: Obx(() {
          String? currencyName = getSettingsLocal()?.currency;
          final total = _controller.totalBalance.value;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid, vertical: Dimens.paddingMin),
            controller: _scrollController,
            children: [
              if (_controller.walletListFromType == WalletViewType.spot)
                Container(
                  decoration: boxDecorationRoundCorner(),
                  padding: const EdgeInsets.all(Dimens.paddingMid),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textAutoSizePoppins('Total Balance'.tr, color: context.theme.primaryColor),
                      vSpacer5(),
                      textAutoSizeKarla("${currencyFormat(total.total)} ${currencyName ?? total.currency}", fontSize: Dimens.regularFontSizeLarge),
                    ],
                  ),
                ),
              _controller.walletList.isEmpty
                  ? showEmptyView(message: "Your wallets will listed here".tr, height: Dimens.mainContendGapTop)
                  : Container(
                      decoration: boxDecorationRoundCorner(),
                      margin: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
                      child: Column(
                          children: List.generate(_controller.walletList.length, (index) {
                        final item = _controller.walletList[index];
                        if (_controller.walletListFromType == WalletViewType.spot) {
                          return SpotWalletView(wallet: item);
                        } else if (_controller.walletListFromType == WalletViewType.future || _controller.walletListFromType == WalletViewType.p2p) {
                          return CommonWalletItem(wallet: item, fromType: _controller.walletListFromType);
                        }
                        return vSpacer0();
                      }))),
              vSpacer10()
            ],
          );
        }),
      ),
    );
  }
}

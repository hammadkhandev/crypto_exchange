import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/faq.dart';
import 'package:tradexpro_flutter/data/models/history.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'wallet_deposit_controller.dart';

class WalletDepositScreen extends StatefulWidget {
  const WalletDepositScreen({Key? key, required this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  State<WalletDepositScreen> createState() => _WalletDepositScreenState();
}

class _WalletDepositScreenState extends State<WalletDepositScreen> {
  final _controller = Get.put(WalletDepositController());
  Rx<Wallet> walletRx = Wallet(id: 0).obs;
  RxString selectedAddress = "".obs;
  RxList<Network> networkList = <Network>[].obs;
  RxList<NetworkAddress> addressList = <NetworkAddress>[].obs;
  Rx<Network> selectedNetwork = Network(id: 0).obs;
  RxList<History> historyList = <History>[].obs;
  RxList<FAQ> faqList = <FAQ>[].obs;
  RxInt baseNetworkType = 0.obs;

  @override
  void initState() {
    walletRx.value = widget.wallet;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getWalletDeposit(widget.wallet.id, (value) {
          _setViewData(value);
          _controller.getHistoryListData(HistoryType.deposit, (list) => historyList.value = list);
          _controller.getFAQList(FAQType.deposit, (list) => faqList.value = list);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BGViewMain(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
          child: Column(
            children: [
              appBarBackWithActions(title: "Deposit".tr),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(Dimens.paddingMid),
                  children: [
                    vSpacer10(),
                    walletTopView(walletRx.value),
                    vSpacer10(),
                    Obx(() => twoTextSpaceBackground("Balance".tr, coinFormat(walletRx.value.balance), textColor: context.theme.primaryColor)),
                    vSpacer10(),
                    Container(
                      padding: const EdgeInsets.all(Dimens.paddingMid),
                      decoration: boxDecorationRoundCorner(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              textAutoSizeKarla("Warning".tr, fontSize: Dimens.regularFontSizeMid, color: Colors.red),
                              hSpacer10(),
                              showImageAsset(icon: Icons.warning_outlined, width: Dimens.iconSizeMin, height: Dimens.iconSizeMin, color: Colors.red)
                            ],
                          ),
                          vSpacer10(),
                          textAutoSizePoppins("Sending_any_other_asset_message".trParams({"coinName": walletRx.value.coinType ?? ""}),
                              textAlign: TextAlign.start, maxLines: 5, color: Colors.red),
                          _networkView(),
                          vSpacer20(),
                          _addressView(),
                          vSpacer10(),
                        ],
                      ),
                    ),
                    vSpacer20(),
                    _historyListView(),
                    _faqView()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void _setViewData(WalletDeposit dData) {
    if (dData.wallet != null) walletRx.value = dData.wallet!;
    if (dData.address.isValid) selectedAddress.value = dData.address!;

    if (getSettingsLocal()?.isEvmWallet ?? false) {
      baseNetworkType.value = makeInt(dData.data[APIKeyConstants.baseType]);
      if (dData.data != null && dData.data is Map) {
        final nList = dData.data[APIKeyConstants.networks] ?? dData.data[APIKeyConstants.coinPaymentNetworks] ?? [];
        networkList.value = List<Network>.from(nList.map((x) => Network.fromJson(x)));
      }
      if ([NetworkType.trc20Token, NetworkType.evmBaseCoin].contains(baseNetworkType.value)) {
        final aList = dData.data[APIKeyConstants.address] ?? [];
        addressList.value = List<NetworkAddress>.from(aList.map((x) => NetworkAddress.fromJson(x)));
      } else {
        if (selectedAddress.value.isEmpty && networkList.isNotEmpty) {
          final net = networkList.firstWhereOrNull((element) => element.id == walletRx.value.network);
          if (net != null) selectedNetwork.value = net;
          selectedAddress.value = selectedNetwork.value.address ?? "";
        }
      }
    } else {
      if (dData.data != null && dData.data is List) {
        networkList.value = List<Network>.from(dData.data.map((x) => Network.fromJson(x)));
      }
      if (selectedAddress.value.isEmpty && networkList.isNotEmpty) {
        final net = networkList.firstWhereOrNull((element) => element.id == walletRx.value.network);
        if (net != null) selectedNetwork.value = net;
        selectedAddress.value = selectedNetwork.value.address ?? "";
      }
    }
  }

  Widget _networkView() {
    return Obx(() => networkList.isNotEmpty
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSpacer10(),
            textAutoSizeKarla(networkList.isNotEmpty ? "Select Network".tr : "Network Name".tr,
                fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
            vSpacer5(),
            if (networkList.isNotEmpty)
              dropDownNetworks(networkList, selectedNetwork.value, "Select".tr, onChange: (value) {
                selectedNetwork.value = value;
                if ([NetworkType.trc20Token, NetworkType.evmBaseCoin].contains(baseNetworkType.value)) {
                  selectedAddress.value = addressList.firstWhere((element) => element.networkId == selectedNetwork.value.id).address ?? "";
                } else {
                  selectedAddress.value = selectedNetwork.value.address ?? "";
                }
              })
            else
              Container(
                height: 50,
                alignment: Alignment.centerLeft,
                width: context.width,
                padding: const EdgeInsets.all(10),
                decoration: boxDecorationRoundBorder(),
                child: textAutoSizeKarla(walletRx.value.networkName ?? "", fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
              )
          ],
        )
        : const SizedBox.shrink()
    );
  }

  Widget _addressView() {
    return Obx(() {
      if ([NetworkType.trc20Token, NetworkType.evmBaseCoin].contains(baseNetworkType.value) && selectedNetwork.value.id == 0) {
        return vSpacer0();
      } else {
        return Container(
          width: context.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: boxDecorationRoundBorder(),
          child: selectedAddress.value.isNotEmpty
              ? Column(
                  children: [
                    qrView(selectedAddress.value),
                    vSpacer20(),
                    textWithCopyButton(selectedAddress.value),
                  ],
                )
              : Column(
                  children: [
                    textAutoSizePoppins("Address not found".tr, fontSize: Dimens.regularFontSizeMid),
                    selectedNetwork.value.id != 0
                        ? Column(children: [vSpacer20(), buttonRoundedMain(text: "Get Address".tr, onPressCallback: () => _getNetworkAddress())])
                        : vSpacer0()
                  ],
                ),
        );
      }
    });
  }

  void _getNetworkAddress() {
    if ([NetworkType.trc20Token, NetworkType.evmBaseCoin].contains(baseNetworkType.value)) {
      _controller.createNetworkAddress(selectedNetwork.value, walletRx.value.coinType ?? "", (address) {
        selectedNetwork.value.address = address;
        addressList.add(NetworkAddress(networkId: selectedNetwork.value.id, address: address));
        selectedAddress.value = address ?? "";
      });
    } else {
      _controller.walletNetworkAddress(selectedNetwork.value, (address) {
        selectedNetwork.value.address = address;
        selectedAddress.value = address ?? "";
      });
    }
  }

  Widget _historyListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textAutoSizeKarla("Recent Deposits".tr, fontSize: Dimens.regularFontSizeMid, textAlign: TextAlign.start),
        Obx(() => historyList.isEmpty
            ? showEmptyView(height: 50)
            : Column(
                children: List.generate(historyList.length, (index) => historyItemView(historyList[index], HistoryType.deposit)),
              ))
      ],
    );
  }

  Widget _faqView() {
    return Obx(() => faqList.isEmpty
        ? vSpacer2()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpacer30(),
              textAutoSizeTitle("FAQ".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: List.generate(faqList.length, (index) => faqItem(faqList[index])))
            ],
          ));
  }
}

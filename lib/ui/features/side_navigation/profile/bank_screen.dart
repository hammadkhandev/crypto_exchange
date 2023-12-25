import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/fiat_deposit.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import 'package:tradexpro_flutter/utils/common_widgets.dart';
import 'my_profile_controller.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({Key? key}) : super(key: key);

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final _controller = Get.find<MyProfileController>();
  RxList<Bank> userBanks = <Bank>[].obs;
  RxBool isDataLoading = true.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _controller.getUserBankList((success, list) {
          userBanks.value = list;
          isDataLoading.value = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textAutoSizePoppins("Bank List".tr, fontSize: Dimens.regularFontSizeExtraMid),
              buttonText("Add Bank".tr, onPressCallback: () => _addOrUpdateBankAction(null))
            ],
          ),
        ),
        vSpacer10(),
        _userBankListView()
      ]),
    );
  }

  Widget _userBankListView() {
    return Obx(() => userBanks.isEmpty
        ? handleEmptyViewWithLoading(isDataLoading.value, message: "Your bank list will appear here".tr)
        : Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingMid),
              shrinkWrap: true,
              itemCount: userBanks.length,
              itemBuilder: (BuildContext context, int index) {
                return _userBankItem(userBanks[index]);
              },
            ),
          ));
  }

  Widget _userBankItem(Bank bank) {
    final colorPL = context.theme.primaryColorLight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingMid),
      child: Column(
        children: [
          twoTextSpaceFixed("Bank Name".tr, bank.bankName ?? "", color: colorPL),
          twoTextSpaceFixed("Account Name".tr, bank.accountHolderName ?? "", color: colorPL, flex: 4),
          twoTextSpaceFixed("Country".tr, bank.country ?? "", color: colorPL),
          twoTextSpaceFixed("Date".tr, formatDate(bank.createdAt, format: dateFormatMMMMDddYyy), color: colorPL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textAutoSizeKarla("${"Actions".tr}: ", color: colorPL, fontSize: Dimens.regularFontSizeMid),
              buttonText("Edit".tr, bgColor: Colors.grey, onPressCallback: () => _addOrUpdateBankAction(bank)),
            ],
          ),
          dividerHorizontal()
        ],
      ),
    );
  }

  void _addOrUpdateBankAction(Bank? bank) {
    final currentBank = bank ?? Bank(id: 0);
    final btnTitle = bank == null ? "Create Bank".tr : "Update Bank".tr;
    final title = bank == null ? "Add New Bank".tr : "Edit Bank".tr;
    final view = Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          textFieldWithSuffixIcon(
              controller: TextEditingController(text: currentBank.accountHolderName ?? ""),
              labelText: "Account Holder Name".tr,
              hint: "".tr,
              onTextChange: (text) => currentBank.accountHolderName = text),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(text: currentBank.accountHolderAddress ?? ""),
              labelText: "Account Holder Address".tr,
              hint: "".tr,
              onTextChange: (text) => currentBank.accountHolderAddress = text),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(text: currentBank.bankName ?? ""),
              labelText: "Bank Name".tr,
              hint: "".tr,
              onTextChange: (text) => currentBank.bankName = text),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(text: currentBank.bankAddress ?? ""),
              labelText: "Bank Address".tr,
              hint: "".tr,
              onTextChange: (text) => currentBank.bankAddress = text),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(text: currentBank.country ?? ""),
              labelText: "Country".tr,
              hint: "".tr,
              onTextChange: (text) => currentBank.country = text),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(text: currentBank.swiftCode ?? ""),
              labelText: "Swift Code".tr,
              hint: "".tr,
              onTextChange: (text) => currentBank.swiftCode = text),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(text: currentBank.iban ?? ""),
              labelText: "IBAN".tr,
              hint: "".tr,
              onTextChange: (text) => currentBank.iban = text),
          vSpacer10(),
          textFieldWithSuffixIcon(
              controller: TextEditingController(text: currentBank.note ?? ""),
              labelText: "Note".tr,
              hint: "".tr,
              onTextChange: (text) => currentBank.note = text),
          vSpacer30(),
          buttonRoundedMain(text: btnTitle, onPressCallback: () => _checkInputs(currentBank)),
          vSpacer10(),
          if (bank != null) buttonRoundedMain(text: "Delete Bank".tr, bgColor: Colors.red.withOpacity(0.5), onPressCallback: () => _deleteBank(bank)),
        ],
      ),
    );

    showBottomSheetFullScreen(context, view, title: title);
  }

  void _checkInputs(Bank bank) {
    if (!bank.accountHolderName.isValid) {
      showToast("Account holder name required".tr);
      return;
    }
    if (!bank.accountHolderAddress.isValid) {
      showToast("Account holder address required".tr);
      return;
    }
    if (!bank.bankName.isValid) {
      showToast("bank name required".tr);
      return;
    }
    if (!bank.bankAddress.isValid) {
      showToast("bank address required".tr);
      return;
    }
    if (!bank.country.isValid) {
      showToast("bank country required".tr);
      return;
    }
    if (!bank.swiftCode.isValid) {
      showToast("bank swift code required".tr);
      return;
    }
    if (!bank.iban.isValid) {
      showToast("bank iban code required".tr);
      return;
    }
    if (!bank.note.isValid) {
      showToast("bank note required".tr);
      return;
    }
    hideKeyboard(context: context);
    _controller.userBankSave(bank, () {
      Get.back();
      _controller.getUserBankList((success, list) => userBanks.value = list);
    });
  }

  void _deleteBank(Bank bank) {
    alertForAction(context,
        title: "Delete Bank".tr,
        subTitle: "bank delete message".tr,
        buttonTitle: "Delete".tr,
        buttonColor: Colors.red.withOpacity(0.5), onOkAction: () {
      _controller.userBankDelete(bank, () {
        Get.back();
        userBanks.remove(bank);
        Get.back();
      });
    });
  }
}

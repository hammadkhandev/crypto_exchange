import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persona_flutter/persona_flutter.dart';
import 'package:tradexpro_flutter/data/models/kyc_details.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'common_utils.dart';

///persona_flutter: ^3.1.0
class PersonaUtil {
  late InquiryConfiguration _configuration;
  late User myUser;
  late Function(bool success, String inquiryld) onSuccess;

  void start(ThemeData theme, User user, PersonaCredentialDetails? personaDetails, Function(bool success, String inquiryld) onResult) async {
    myUser = user;
    onSuccess = onResult;
    final templateId = personaDetails?.personaKycTemplatedId;
    if (!templateId.isValid) {
      showToast("Api key not found".tr);
      return;
    }
    init(theme, templateId ?? "",  personaDetails?.personaKycMode ?? "");
  }

  void init(ThemeData theme, String templateId, String environment) {
    _configuration = TemplateIdConfiguration(
      templateId: templateId,
      environment: environment == "sandbox" ? InquiryEnvironment.sandbox : InquiryEnvironment.production,
      fields: {},
      theme: InquiryTheme(
        source: InquiryThemeSource.client,
        accentColor: theme.focusColor,
        primaryColor: theme.focusColor,
        buttonBackgroundColor: theme.focusColor,
        darkPrimaryColor: theme.primaryColorDark,
        buttonCornerRadius: 5,
        textFieldCornerRadius: 5,
      ),
    );
    PersonaInquiry.init(configuration: _configuration);
    PersonaInquiry.onComplete.listen(onInquirySuccess);
    PersonaInquiry.onCanceled.listen(onInquiryCancelled);
    PersonaInquiry.onError.listen(onInquiryError);
    PersonaInquiry.start();
  }

  void onInquirySuccess(InquiryComplete event) {
    printFunction("onInquirySuccess inquiryId", "${event.inquiryId} ${event.status}");
    if (event.status == "completed" && event.inquiryId.isValid) {
      onSuccess(true, event.inquiryId!);
    }
  }

  void onInquiryCancelled(InquiryCanceled event) {
    printFunction("onInquiryCancelled inquiryId", "${event.inquiryId} ${event.sessionToken}");
    onSuccess(false, "");
  }

  void onInquiryError(InquiryError? event) {
    printFunction("onInquiryError", event);
    showToast(event?.error ?? "", isError: true);
    onSuccess(false, "");
  }
}

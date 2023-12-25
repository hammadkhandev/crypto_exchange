import 'dart:convert';

KycSettings kycSettingsFromJson(String str) => KycSettings.fromJson(json.decode(str));

class KycSettings {
  KycSettings({required this.enabledKycType, this.personaCredentialsDetails, this.enabledKycUserDetails});

  int enabledKycType;
  PersonaCredentialDetails? personaCredentialsDetails;
  dynamic enabledKycUserDetails;

  factory KycSettings.fromJson(Map<String, dynamic> json) {
    final dynamic kycDetails;
    if (json["enabled_kyc_user_details"] == null) {
      kycDetails = null;
    } else if (json["enabled_kyc_user_details"]["persona"] != null) {
      kycDetails = EnabledKycUserDetails.fromJson(json["enabled_kyc_user_details"]);
    } else {
      kycDetails = KycDetails.fromJson(json["enabled_kyc_user_details"]);
    }
    return KycSettings(
      enabledKycType: json["enabled_kyc_type"],
      personaCredentialsDetails:
          json["perona_credentials_details"] == null ? null : PersonaCredentialDetails.fromJson(json["perona_credentials_details"]),
      enabledKycUserDetails: kycDetails,
    );
  }
}

class EnabledKycUserDetails {
  EnabledKycUserDetails({this.persona});

  Persona? persona;

  factory EnabledKycUserDetails.fromJson(Map<String, dynamic> json) =>
      EnabledKycUserDetails(persona: json["persona"] == null ? null : Persona.fromJson(json["persona"]));
}

class Persona {
  Persona({this.isVerified});

  int? isVerified;

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(isVerified: json["is_verified"]);
}

class PersonaCredentialDetails {
  PersonaCredentialDetails({this.personaKycApiKey, this.personaKycTemplatedId, this.personaKycMode, this.personaKycVersion});

  String? personaKycApiKey;
  String? personaKycTemplatedId;
  String? personaKycMode;
  DateTime? personaKycVersion;

  factory PersonaCredentialDetails.fromJson(Map<String, dynamic> json) => PersonaCredentialDetails(
        personaKycApiKey: json["PERSONA_KYC_API_KEY"],
        personaKycTemplatedId: json["PERSONA_KYC_TEMPLATED_ID"],
        personaKycMode: json["PERSONA_KYC_MODE"],
        personaKycVersion: DateTime.parse(json["PERSONA_KYC_VERSION"]),
      );
}

KycDetails kycDetailsFromJson(String str) => KycDetails.fromJson(json.decode(str));

String kycDetailsToJson(KycDetails data) => json.encode(data.toJson());

class KycDetails {
  KycDetails({this.nid, this.passport, this.driving, this.voter});

  KycObject? nid;
  KycObject? passport;
  KycObject? driving;
  KycObject? voter;

  factory KycDetails.fromJson(Map<String, dynamic> json) => KycDetails(
        nid: json["nid"] == null ? null : KycObject.fromJson(json["nid"]),
        passport: json["passport"] == null ? null : KycObject.fromJson(json["passport"]),
        driving: json["driving"] == null ? null : KycObject.fromJson(json["driving"]),
        voter: json["voter"] == null ? null : KycObject.fromJson(json["voter"]),
      );

  Map<String, dynamic> toJson() => {
        "nid": nid == null ? null : nid!.toJson(),
        "passport": passport == null ? null : passport!.toJson(),
        "driving": driving == null ? null : driving!.toJson(),
        "voter": voter == null ? null : voter!.toJson(),
      };
}

class KycObject {
  KycObject({this.frontImage, this.backImage, this.selfieImage, this.status});

  String? frontImage;
  String? backImage;
  String? selfieImage;
  String? status;

  factory KycObject.fromJson(Map<String, dynamic> json) => KycObject(
        frontImage: json["front_image"],
        backImage: json["back_image"],
        selfieImage: json["selfie"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "front_image": frontImage,
        "back_image": backImage,
        "selfie": selfieImage,
        "status": status,
      };
}

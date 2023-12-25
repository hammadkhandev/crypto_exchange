import 'dart:convert';

import 'package:tradexpro_flutter/data/models/list_response.dart';

/// *** Common Server Response *** ///

ServerResponse responseFromJson(String str) => ServerResponse.fromJson(json.decode(str));

String responseToJson(ServerResponse data) => json.encode(data.toJson());

class ServerResponse {
  ServerResponse({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  dynamic data;

  factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data,
      };

  static bool isServerResponse(Map<String, dynamic> json) => json["success"] != null && json["message"] != null && json["data"] != null;
}

/// final historyResponse = historyResponseFromJson(jsonString);
HistoryResponse historyResponseFromJson(String str) => HistoryResponse.fromJson(json.decode(str));


class HistoryResponse {
  HistoryResponse({
    this.type,
    this.subMenu,
    this.title,
    this.histories,
    this.status,
  });

  String? type;
  String? subMenu;
  String? title;
  ListResponse? histories;
  Map<String, String>? status;

  factory HistoryResponse.fromJson(Map<String, dynamic> json) => HistoryResponse(
      type: json["type"],
      subMenu: json["sub_menu"],
      title: json["title"],
      status: json["status"] == null ? null : Map.from(json["status"]).map((k, v) => MapEntry<String, String>(k, v)),
      histories: json["histories"] != null
          ? ListResponse.fromJson(json["histories"])
          : json["list"] != null
              ? ListResponse.fromJson(json["list"])
              : json["items"] != null
                  ? ListResponse.fromJson(json["items"])
                  : null);

}

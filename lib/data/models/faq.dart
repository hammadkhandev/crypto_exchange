import 'dart:convert';
import 'package:tradexpro_flutter/utils/date_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';

FAQ faqFromJson(String str) => FAQ.fromJson(json.decode(str));

class FAQ {
  FAQ({
    this.id,
    this.faqTypeId,
    this.question,
    this.answer,
    this.status,
    this.author,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? faqTypeId;
  String? question;
  String? answer;
  int? status;
  int? author;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FAQ.fromJson(Map<String, dynamic> json) => FAQ(
        id: json["id"],
        faqTypeId: json["faq_type_id"],
        question: json["question"],
        answer: json["answer"],
        status: makeInt(json["status"]),
        author: makeInt(json["author"]),
        createdAt: makesDate(json, "created_at"),
        updatedAt: makesDate(json, "updated_at"),
      );
}

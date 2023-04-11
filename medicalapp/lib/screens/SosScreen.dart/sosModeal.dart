// To parse this JSON data, do
//
//     final listEmergencyContact = listEmergencyContactFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class ListEmergencyContact {
  ListEmergencyContact({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  final bool status;
  final int statuscode;
  final String message;
  final List<Datum> data;

  factory ListEmergencyContact.fromRawJson(String str) =>
      ListEmergencyContact.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListEmergencyContact.fromJson(Map<String, dynamic> json) =>
      ListEmergencyContact(
        status: json["status"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statuscode": statuscode,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.name,
    required this.mobile,
    required this.relation,
    required this.id,
  });

  final String name;
  final String mobile;
  final String relation;
  final String id;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"].toString(),
        mobile: json["mobile"].toString(),
        relation: json["relation"].toString(),
        id: json["id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
        "relation": relation,
        "id": id,
      };
}

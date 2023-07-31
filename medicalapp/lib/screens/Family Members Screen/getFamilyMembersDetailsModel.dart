// To parse this JSON data, do
//
//     final getFamilyMembers = getFamilyMembersFromJson(jsonString);

import 'dart:convert';

class GetFamilyMembers {
  final bool status;
  final int statuscode;
  final String message;
  final List<Datum> data;

  GetFamilyMembers({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory GetFamilyMembers.fromRawJson(String str) =>
      GetFamilyMembers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFamilyMembers.fromJson(Map<String, dynamic> json) =>
      GetFamilyMembers(
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
  final String id;
  final String username;
  final String profilePic;
  final String relation;
  final String emailId;

  Datum({
    required this.id,
    required this.username,
    required this.profilePic,
    required this.relation,
    required this.emailId,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        username: json["username"],
        profilePic: json["profile_pic"],
        relation: json["relation"],
        emailId: json["email_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "profile_pic": profilePic,
        "relation": relation,
        "email_id": emailId,
      };
}

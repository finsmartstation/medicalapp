import 'dart:convert';

class UserLocationList {
  final bool status;
  final int statuscode;
  final String message;
  final String longitude;
  final String latitude;
  final List<Datum> data;

  UserLocationList({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.longitude,
    required this.latitude,
    required this.data,
  });

  factory UserLocationList.fromRawJson(String str) =>
      UserLocationList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserLocationList.fromJson(Map<String, dynamic> json) =>
      UserLocationList(
        status: json["status"],
        statuscode: json["statuscode"],
        message: json["message"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statuscode": statuscode,
        "message": message,
        "longitude": longitude,
        "latitude": latitude,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final String userId;
  final String organistaionName;
  final String longitude;
  final String latitude;
  final String type;

  Datum({
    required this.userId,
    required this.organistaionName,
    required this.longitude,
    required this.latitude,
    required this.type,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        organistaionName: json["organistaion_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        type: json["type"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "organistaion_name": organistaionName,
        "longitude": longitude,
        "latitude": latitude,
        "type": type,
      };
}

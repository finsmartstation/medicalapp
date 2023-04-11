
// To parse this JSON data, do
//
//     final consultedDoctorsDateList = consultedDoctorsDateListFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class ConsultedDoctorsDateList {
    ConsultedDoctorsDateList({
        required this.status,
        required this.statuscode,
        required this.message,
        required this.data,
    });

    bool status;
    int statuscode;
    String message;
    List<Datum> data;

    factory ConsultedDoctorsDateList.fromRawJson(String str) => ConsultedDoctorsDateList.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConsultedDoctorsDateList.fromJson(Map<String, dynamic> json) => ConsultedDoctorsDateList(
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
        required this.addedDatetime,
    });

    DateTime addedDatetime;

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        addedDatetime: DateTime.parse(json["added_datetime"]),
    );

    Map<String, dynamic> toJson() => {
        "added_datetime": addedDatetime.toIso8601String(),
    };
}


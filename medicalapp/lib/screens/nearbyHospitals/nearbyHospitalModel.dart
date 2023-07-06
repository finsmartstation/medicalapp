// To parse this JSON data, do
//
//     final getNearbyHospitalModel = getNearbyHospitalModelFromJson(jsonString);

import 'dart:convert';

class GetNearbyHospitalModel {
    final bool status;
    final int statuscode;
    final List<Datum> data;
    final String message;

    GetNearbyHospitalModel({
        required this.status,
        required this.statuscode,
        required this.data,
        required this.message,
    });

    factory GetNearbyHospitalModel.fromRawJson(String str) => GetNearbyHospitalModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetNearbyHospitalModel.fromJson(Map<String, dynamic> json) => GetNearbyHospitalModel(
        status: json["status"],
        statuscode: json["statuscode"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statuscode": statuscode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
    final String id;
    final String hospitalName;

    Datum({
        required this.id,
        required this.hospitalName,
    });

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        hospitalName: json["hospital_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "hospital_name": hospitalName,
    };
}

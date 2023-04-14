// To parse this JSON data, do
//
//     final consultedDoctorsList = consultedDoctorsListFromJson(jsonString);

import 'dart:convert';

class ConsultedDoctorsList {
  ConsultedDoctorsList({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  bool status;
  int statuscode;
  String message;
  List<Datum> data;

  factory ConsultedDoctorsList.fromRawJson(String str) =>
      ConsultedDoctorsList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConsultedDoctorsList.fromJson(Map<String, dynamic> json) =>
      ConsultedDoctorsList(
        status: json["status"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: List<Datum>.from(json["data"]
            .map((datumJson) => Datum.fromJson(datumJson as dynamic))),
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
    required this.doctorId,
    required this.doctorName,
    required this.profilePic,
  });

  String doctorId;
  String doctorName;
  String profilePic;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "profile_pic": profilePic,
      };
}

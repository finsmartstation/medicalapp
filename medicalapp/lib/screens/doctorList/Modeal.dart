// To parse this JSON data, do
//
//     final listAllDoctors = listAllDoctorsFromJson(jsonString);

import 'dart:convert';

class ListAllDoctors {
  ListAllDoctors({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  bool status;
  int statuscode;
  String message;
  List<Datum> data;

  factory ListAllDoctors.fromRawJson(String str) =>
      ListAllDoctors.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListAllDoctors.fromJson(Map<String, dynamic> json) => ListAllDoctors(
        status: json["status"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: List<Datum>.from(
            json["data"].map((dynamic datumJson) => Datum.fromJson(datumJson))),
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
    required this.experience,
    required this.favouriteDoctorStatus,
    required this.familyDoctorStatus,
    required this.organisation,
    required this.specialization,
  });

  String doctorId;
  String doctorName;
  String profilePic;
  dynamic experience;
  String favouriteDoctorStatus;
  String familyDoctorStatus;
  String organisation;
  String specialization;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        profilePic: json["profile_pic"],
        experience: json["experience"],
        favouriteDoctorStatus: json["favourite_doctor_status"],
        familyDoctorStatus: json["family_doctor_status"],
        organisation: json["organisation"],
        specialization: json["specialization"],
      );

  Map<String, dynamic> toJson() => {
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "profile_pic": profilePic,
        "experience": experience,
        "favourite_doctor_status": favouriteDoctorStatus,
        "family_doctor_status": familyDoctorStatus,
        "organisation": organisation,
        "specialization": specialization,
      };
}

// To parse this JSON data, do
//
//     final doctorProfileDetails = doctorProfileDetailsFromJson(jsonString);

class DoctorProfileDetails {
  DoctorProfileDetails({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  final bool status;
  final int statuscode;
  final String message;
  final Data data;

  factory DoctorProfileDetails.fromRawJson(String str) =>
      DoctorProfileDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DoctorProfileDetails.fromJson(Map<String, dynamic> json) =>
      DoctorProfileDetails(
        status: json["status"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: Data.fromJson(json["data"] is Map ? json["data"] : {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statuscode": statuscode,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.doctorName,
    required this.profilePic,
    required this.consultingFee,
    required this.patientCount,
    required this.experience,
    required this.rating,
    required this.slotAvailableStatus,
    required this.favouriteDoctorStatus,
    required this.familyDoctorStatus,
    required this.organisation,
    required this.specialization,
    required this.designation,
  });

  final String doctorName;
  final String profilePic;
  final String consultingFee;
  final String patientCount;
  final String experience;
  final String rating;
  final String slotAvailableStatus;
  final String favouriteDoctorStatus;
  final String familyDoctorStatus;
  final String organisation;
  final String specialization;
  final String designation;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        doctorName: json["doctor_name"].toString(),
        profilePic: json["profile_pic"].toString(),
        consultingFee: json["consulting_fee"].toString(),
        patientCount: json["patient_count"].toString(),
        experience: json["experience"].toString(),
        rating: json["rating"].toString(),
        slotAvailableStatus: json["slot_available_status"].toString(),
        favouriteDoctorStatus: json["favourite_doctor_status"].toString(),
        familyDoctorStatus: json["family_doctor_status"].toString(),
        organisation: json["organisation"].toString(),
        specialization: json["specialization"].toString(),
        designation: json["designation"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "doctor_name": doctorName,
        "profile_pic": profilePic,
        "consulting_fee": consultingFee,
        "patient_count": patientCount,
        "experience": experience,
        "rating": rating,
        "slot_available_status": slotAvailableStatus,
        "favourite_doctor_status": favouriteDoctorStatus,
        "family_doctor_status": familyDoctorStatus,
        "organisation": organisation,
        "specialization": specialization,
        "designation": designation,
      };
}

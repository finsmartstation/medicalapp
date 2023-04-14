// To parse this JSON data, do
//
//     final listFavouriteFamilyDoctors = listFavouriteFamilyDoctorsFromJson(jsonString);

import 'dart:convert';

class ListFavouriteFamilyDoctors {
  ListFavouriteFamilyDoctors({
    required this.status,
    required this.statuscode,
    required this.familyDoctor,
    required this.favouriteDoctor,
    required this.recentDoctor,
    required this.familyDoctorMessage,
    required this.familyDoctorStatus,
    required this.favouriteDoctorMessage,
    required this.favouriteDoctorStatus,
    required this.recentDoctorMessage,
    required this.recentDoctorStatus,
  });

  final bool status;
  final int statuscode;
  final Doctor familyDoctor;
  final List<Doctor> favouriteDoctor;
  final List<RecentDoctor> recentDoctor;
  final String familyDoctorMessage;
  final bool familyDoctorStatus;
  final String favouriteDoctorMessage;
  final bool favouriteDoctorStatus;
  final String recentDoctorMessage;
  final bool recentDoctorStatus;

  factory ListFavouriteFamilyDoctors.fromRawJson(String str) =>
      ListFavouriteFamilyDoctors.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListFavouriteFamilyDoctors.fromJson(Map<String, dynamic> json) =>
      ListFavouriteFamilyDoctors(
        status: json["status"],
        statuscode: json["statuscode"],
        familyDoctor: Doctor.fromJson(json["family_doctor"]),
        favouriteDoctor: List<Doctor>.from(json["favourite_doctor"].map(
            (doctorJson) =>
                Doctor.fromJson(doctorJson as Map<String, dynamic>))),
        recentDoctor: List<RecentDoctor>.from(json["recent_doctor"].map(
            (recentDoctorJson) =>
                RecentDoctor.fromJson(recentDoctorJson as dynamic))),
        familyDoctorMessage: json["family_doctor_message"],
        familyDoctorStatus: json["family_doctor_status"],
        favouriteDoctorMessage: json["favourite_doctor_message"],
        favouriteDoctorStatus: json["favourite_doctor_status"],
        recentDoctorMessage: json["recent_doctor_message"],
        recentDoctorStatus: json["recent_doctor_status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statuscode": statuscode,
        "family_doctor": familyDoctor.toJson(),
        "favourite_doctor":
            List<dynamic>.from(favouriteDoctor.map((x) => x.toJson())),
        "recent_doctor":
            List<dynamic>.from(recentDoctor.map((x) => x.toJson())),
        "family_doctor_message": familyDoctorMessage,
        "family_doctor_status": familyDoctorStatus,
        "favourite_doctor_message": favouriteDoctorMessage,
        "favourite_doctor_status": favouriteDoctorStatus,
        "recent_doctor_message": recentDoctorMessage,
        "recent_doctor_status": recentDoctorStatus,
      };
}

class Doctor {
  Doctor({
    required this.username,
    required this.doctorId,
    required this.profilePic,
    required this.experience,
    required this.organisation,
    required this.specialization,
  });

  final String username;
  final String doctorId;
  final String profilePic;
  final String experience;
  final String organisation;
  final String specialization;

  factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        username: json["username"].toString(),
        doctorId: json["doctor_id"].toString(),
        profilePic: json["profile_pic"].toString(),
        experience: json["experience"].toString(),
        organisation: json["organisation"].toString(),
        specialization: json["specialization"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "doctor_id": doctorId,
        "profile_pic": profilePic,
        "experience": experience,
        "organisation": organisation,
        "specialization": specialization,
      };
}

class RecentDoctor {
  RecentDoctor({
    required this.doctorName,
    required this.doctorId,
    required this.familyMemberId,
    required this.profilePic,
    required this.experience,
    required this.organisation,
    required this.specialization,
  });

  final String doctorName;
  final String doctorId;
  final String familyMemberId;
  final String profilePic;
  final String experience;
  final String organisation;
  final String specialization;

  factory RecentDoctor.fromRawJson(String str) =>
      RecentDoctor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecentDoctor.fromJson(Map<String, dynamic> json) => RecentDoctor(
        doctorName: json["doctor_name"],
        doctorId: json["doctor_id"],
        familyMemberId: json["family_member_id"],
        profilePic: json["profile_pic"],
        experience: json["experience"],
        organisation: json["organisation"],
        specialization: json["specialization"],
      );

  Map<String, dynamic> toJson() => {
        "doctor_name": doctorName,
        "doctor_id": doctorId,
        "family_member_id": familyMemberId,
        "profile_pic": profilePic,
        "experience": experience,
        "organisation": organisation,
        "specialization": specialization,
      };
}

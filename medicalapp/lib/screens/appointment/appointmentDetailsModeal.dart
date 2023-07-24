// To parse this JSON data, do
//
//     final patientAppoinmentDetails = patientAppoinmentDetailsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class PatientAppoinmentDetails {
  final bool status;
  final int statuscode;
  final String message;
  final Data data;

  PatientAppoinmentDetails({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  factory PatientAppoinmentDetails.fromRawJson(String str) =>
      PatientAppoinmentDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PatientAppoinmentDetails.fromJson(Map<String, dynamic> json) =>
      PatientAppoinmentDetails(
        status: json["status"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statuscode": statuscode,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final String slotId;
  final String doctorId;
  final DateTime bookedDatetime;
  final DateTime bookedFor;
  final String bookingId;
  final String visitType;
  final String sickNotes;
  final DateTime nextFollowUpDate;
  final String consultingStatus;
  final String callStatus;
  final String stickers;
  final String doctorName;
  final String organizationId;
  final String reportPath;
  final String refferedDoctor;
  final String refferedLab;
  final String profilePic;
  final String refferedDoctorName;
  final String refferedLabName;
  final String prescription;
  final String consultingMessage;
  final int chatStatus;
  final String organisationName;
  final String organisationMobile;
  final String organisationEmail;
  final String organisationAddress;

  Data({
    required this.slotId,
    required this.doctorId,
    required this.bookedDatetime,
    required this.bookedFor,
    required this.bookingId,
    required this.visitType,
    required this.sickNotes,
    required this.nextFollowUpDate,
    required this.consultingStatus,
    required this.callStatus,
    required this.stickers,
    required this.doctorName,
    required this.organizationId,
    required this.reportPath,
    required this.refferedDoctor,
    required this.refferedLab,
    required this.profilePic,
    required this.refferedDoctorName,
    required this.refferedLabName,
    required this.prescription,
    required this.consultingMessage,
    required this.chatStatus,
    required this.organisationName,
    required this.organisationMobile,
    required this.organisationEmail,
    required this.organisationAddress,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        slotId: json["slot_id"],
        doctorId: json["doctor_id"],
        bookedDatetime: DateTime.parse(json["booked_datetime"]),
        bookedFor: DateTime.parse(json["booked_for"]),
        bookingId: json["booking_id"],
        visitType: json["visit_type"],
        sickNotes: json["sick_notes"],
        nextFollowUpDate: DateTime.parse(json["next_follow_up_date"]),
        consultingStatus: json["consulting_status"],
        callStatus: json["call_status"],
        stickers: json["stickers"],
        doctorName: json["doctor_name"],
        organizationId: json["organization_id"],
        reportPath: json["report_path"],
        refferedDoctor: json["reffered_doctor"] ?? '',
        refferedLab: json["reffered_lab"] ?? '',
        profilePic: json["profile_pic"] ?? '',
        refferedDoctorName: json["reffered_doctor_name"] ?? '',
        refferedLabName: json["reffered_lab_name"] ?? '',
        prescription: json["prescription"] ?? '',
        consultingMessage: json["consulting_message"] ?? '',
        chatStatus: json["chat_status"] ?? '',
        organisationName: json["organisation_name"] ?? '',
        organisationMobile: json["organisation_mobile"] ?? '',
        organisationEmail: json["organisation_email"] ?? '',
        organisationAddress: json["organisation_address"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "slot_id": slotId,
        "doctor_id": doctorId,
        "booked_datetime": bookedDatetime.toIso8601String(),
        "booked_for": bookedFor.toIso8601String(),
        "booking_id": bookingId,
        "visit_type": visitType,
        "sick_notes": sickNotes,
        "next_follow_up_date":
            "${nextFollowUpDate.year.toString().padLeft(4, '0')}-${nextFollowUpDate.month.toString().padLeft(2, '0')}-${nextFollowUpDate.day.toString().padLeft(2, '0')}",
        "consulting_status": consultingStatus,
        "call_status": callStatus,
        "stickers": stickers,
        "doctor_name": doctorName,
        "organization_id": organizationId,
        "report_path": reportPath,
        "reffered_doctor": refferedDoctor,
        "reffered_lab": refferedLab,
        "profile_pic": profilePic,
        "reffered_doctor_name": refferedDoctorName,
        "reffered_lab_name": refferedLabName,
        "prescription": prescription,
        "consulting_message": consultingMessage,
        "chat_status": chatStatus,
        "organisation_name": organisationName,
        "organisation_mobile": organisationMobile,
        "organisation_email": organisationEmail,
        "organisation_address": organisationAddress,
      };
}

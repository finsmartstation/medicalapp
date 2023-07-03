// To parse this JSON data, do
//
//     final patientAppoinmentDetails = patientAppoinmentDetailsFromJson(jsonString);

import 'dart:convert';

class PatientAppoinmentDetails {
  PatientAppoinmentDetails({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  bool status;
  int statuscode;
  String message;
  Data data;

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
    required this.stickers,
    required this.doctorName,
    required this.organizationId,
    required this.reportPath,
    required this.refferedDoctor,
    required this.refferedLab,
    required this.refferedDoctorName,
    required this.refferedLabName,
    required this.prescription,
    required this.consultingMessage,
    required this.chatStatus,
    required this.organisationName,
    required this.organisationMobile,
    required this.organisationEmail,
    required this.organisationAddress,
    required this.call_status,
  });

  String slotId;
  String doctorId;
  DateTime bookedDatetime;
  DateTime bookedFor;
  String bookingId;
  String visitType;
  String sickNotes;
  String nextFollowUpDate;
  String consultingStatus;
  String stickers;
  String doctorName;
  String organizationId;
  String reportPath;
  String refferedDoctor;
  String refferedLab;
  String refferedDoctorName;
  String refferedLabName;
  String prescription;
  String consultingMessage;
  String chatStatus;
  String organisationName;
  String organisationMobile;
  String organisationEmail;
  String organisationAddress;
  String call_status;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        slotId: json["slot_id"].toString(),
        doctorId: json["doctor_id"].toString(),
        bookedDatetime: DateTime.parse(json["booked_datetime"]),
        bookedFor: DateTime.parse(json["booked_for"]),
        bookingId: json["booking_id"].toString(),
        visitType: json["visit_type"].toString(),
        sickNotes: json["sick_notes"].toString(),
        nextFollowUpDate: json["next_follow_up_date"].toString(),
        consultingStatus: json["consulting_status"].toString(),
        stickers: json["stickers"].toString(),
        doctorName: json["doctor_name"].toString(),
        organizationId: json["organization_id"].toString(),
        reportPath: json["report_path"].toString(),
        refferedDoctor: json["reffered_doctor"].toString(),
        refferedLab: json["reffered_lab"].toString(),
        refferedDoctorName: json["reffered_doctor_name"].toString(),
        refferedLabName: json["reffered_lab_name"].toString(),
        prescription: json["prescription"].toString(),
        consultingMessage: json["consulting_message"].toString(),
        chatStatus: json["chat_status"].toString(),
        organisationName: json["organisation_name"].toString(),
        organisationMobile: json["organisation_mobile"].toString(),
        organisationEmail: json["organisation_email"].toString(),
        organisationAddress: json["organisation_address"].toString(),
        call_status: json["call_status"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "slot_id": slotId,
        "doctor_id": doctorId,
        "booked_datetime": bookedDatetime.toIso8601String(),
        "booked_for": bookedFor.toIso8601String(),
        "booking_id": bookingId,
        "visit_type": visitType,
        "sick_notes": sickNotes,
        "next_follow_up_date": nextFollowUpDate,
        "consulting_status": consultingStatus,
        "stickers": stickers,
        "doctor_name": doctorName,
        "organization_id": organizationId,
        "report_path": reportPath,
        "reffered_doctor": refferedDoctor,
        "reffered_lab": refferedLab,
        "reffered_doctor_name": refferedDoctorName,
        "reffered_lab_name": refferedLabName,
        "prescription": prescription,
        "consulting_message": consultingMessage,
        "chat_status": chatStatus,
        "organisation_name": organisationName,
        "organisation_mobile": organisationMobile,
        "organisation_email": organisationEmail,
        "organisation_address": organisationAddress,
        "call_status": call_status,
      };
}

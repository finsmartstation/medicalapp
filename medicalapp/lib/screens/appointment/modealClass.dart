// To parse this JSON data, do
//
//     final patientBookSlotHistory = patientBookSlotHistoryFromJson(jsonString);

import 'dart:convert';

class PatientBookSlotHistory {
  PatientBookSlotHistory({
    required this.loginStatus,
    required this.upcommingData,
    required this.upcommingMessage,
    required this.previousData,
    required this.previousMessage,
    required this.status,
    required this.statuscode,
  });

  final String loginStatus;
  final List<Datum> upcommingData;
  final String upcommingMessage;
  final List<Datum> previousData;
  final String previousMessage;
  final bool status;
  final int statuscode;

  factory PatientBookSlotHistory.fromRawJson(String str) =>
      PatientBookSlotHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PatientBookSlotHistory.fromJson(Map<String, dynamic> json) =>
      PatientBookSlotHistory(
        loginStatus: json["login_status"].toString(),
        upcommingData: List<Datum>.from(json["upcomming_data"]
            .map((datumJson) => Datum.fromJson(datumJson as dynamic))),
        upcommingMessage: json["upcomming_message"],
        previousData: List<Datum>.from(json["previous_data"]
            .map((datumJson) => Datum.fromJson(datumJson as dynamic))),
        previousMessage: json["previous_message"],
        status: json["status"],
        statuscode: json["statuscode"],
      );

  Map<String, dynamic> toJson() => {
        "login_status": loginStatus,
        "upcomming_data":
            List<dynamic>.from(upcommingData.map((x) => x.toJson())),
        "upcomming_message": upcommingMessage,
        "previous_data":
            List<dynamic>.from(previousData.map((x) => x.toJson())),
        "previous_message": previousMessage,
        "status": status,
        "statuscode": statuscode,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.sickNotes,
    required this.visitType,
    required this.bookedFor,
    required this.doctorId,
    required this.doctorName,
    required this.consultingMessage,
  });

  final String id;
  final String sickNotes;
  final String visitType;
  final DateTime bookedFor;
  final String doctorId;
  final String doctorName;
  final String consultingMessage;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        sickNotes: json["sick_notes"],
        visitType: json["visit_type"],
        bookedFor: DateTime.parse(json["booked_for"]),
        doctorId: json["doctor_id"],
        doctorName: json["doctor_name"],
        consultingMessage: json["consulting_message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sick_notes": sickNotes,
        "visit_type": visitType,
        "booked_for": bookedFor.toIso8601String(),
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "consulting_message": consultingMessage,
      };
}

// To parse this JSON data, do
//
//     final doctorAvailableSlotDetails = doctorAvailableSlotDetailsFromJson(jsonString);


// class DoctorAvailableSlotDetails {
//     final bool status;
//     final int statuscode;
//     final String message;
//     final  data;

//     DoctorAvailableSlotDetails({
//         required this.status,
//         required this.statuscode,
//         required this.message,
//         required this.data,
//     });

//     factory DoctorAvailableSlotDetails.fromRawJson(String str) => DoctorAvailableSlotDetails.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory DoctorAvailableSlotDetails.fromJson(Map<String, dynamic> json) => DoctorAvailableSlotDetails(
//         status: json["status"],
//         statuscode: json["statuscode"],
//         message: json["message"],
//         data: Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "statuscode": statuscode,
//         "message": message,
//         "data": data.toJson(),
//     };
// }

// class Data {
//     final List<Date> date;
//     final List<Slot> slots;

//     Data({
//         required this.date,
//         required this.slots,
//     });

//     factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         date: List<Date>.from(json["date"].map((x) => Date.fromJson(x))),
//         slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "date": List<dynamic>.from(date.map((x) => x.toJson())),
//         "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
//     };
// }

// class Date {
//     final String dateId;
//     final DateTime date;
//     final int count;

//     Date({
//         required this.dateId,
//         required this.date,
//         required this.count,
//     });

//     factory Date.fromRawJson(String str) => Date.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Date.fromJson(Map<String, dynamic> json) => Date(
//         dateId: json["date_id"],
//         date: DateTime.parse(json["date"]),
//         count: json["count"],
//     );

//     Map<String, dynamic> toJson() => {
//         "date_id": dateId,
//         "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//         "count": count,
//     };
// }

// class Slot {
//     final String id;
//     final String dateId;
//     final DateTime date;
//     final String slotTime;
//     final String appoinmentType;

//     Slot({
//         required this.id,
//         required this.dateId,
//         required this.date,
//         required this.slotTime,
//         required this.appoinmentType,
//     });

//     factory Slot.fromRawJson(String str) => Slot.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Slot.fromJson(Map<String, dynamic> json) => Slot(
//         id: json["id"],
//         dateId: json["date_id"],
//         date: DateTime.parse(json["date"]),
//         slotTime: json["slot_time"],
//         appoinmentType: json["appoinment_type"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "date_id": dateId,
//         "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//         "slot_time": slotTime,
//         "appoinment_type": appoinmentType,
//     };
// }


// To parse this JSON data, do
//
//     final doctorAvailableSlotDetails = doctorAvailableSlotDetailsFromJson(jsonString);



// To parse this JSON data, do
//
//     final doctorAvailableSlotDetails = doctorAvailableSlotDetailsFromJson(jsonString);



// To parse this JSON data, do
//
//     final doctorAvailableSlotDetails = doctorAvailableSlotDetailsFromJson(jsonString);


class DoctorAvailableSlotDetails {
    final bool status;
    final int statuscode;
    final String message;
    final Data data;

    DoctorAvailableSlotDetails({
        required this.status,
        required this.statuscode,
        required this.message,
        required this.data,
    });

    factory DoctorAvailableSlotDetails.fromRawJson(String str) => DoctorAvailableSlotDetails.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DoctorAvailableSlotDetails.fromJson(Map<String, dynamic> json) => DoctorAvailableSlotDetails(
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
    final List<Date> date;
    final List<Slot> slots;

    Data({
        required this.date,
        required this.slots,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        date: List<Date>.from(json["date"].map((x) => Date.fromJson(x))),
        slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": List<dynamic>.from(date.map((x) => x.toJson())),
        "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
    };
}

class Date {
    final String dateId;
    final DateTime date;
    final int count;

    Date({
        required this.dateId,
        required this.date,
        required this.count,
    });

    factory Date.fromRawJson(String str) => Date.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Date.fromJson(Map<String, dynamic> json) => Date(
        dateId: json["date_id"],
        date: DateTime.parse(json["date"]),
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "date_id": dateId,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "count": count,
    };
}

class Slot {
    final String id;
    final String dateId;
    final DateTime date;
    final String slotTime;
    final String appoinmentType;

    Slot({
        required this.id,
        required this.dateId,
        required this.date,
        required this.slotTime,
        required this.appoinmentType,
    });

    factory Slot.fromRawJson(String str) => Slot.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        dateId: json["date_id"],
        date: DateTime.parse(json["date"]),
        slotTime: json["slot_time"],
        appoinmentType: json["appoinment_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_id": dateId,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "slot_time": slotTime,
        "appoinment_type": appoinmentType,
    };
}

// To parse this JSON data, do
//
//     final listCaseHistory = listCaseHistoryFromJson(jsonString);

import 'dart:convert';

class ListCaseHistory {
  ListCaseHistory({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  final bool status;
  final int statuscode;
  final String message;
  final List<Datum> data;

  factory ListCaseHistory.fromRawJson(String str) =>
      ListCaseHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListCaseHistory.fromJson(Map<String, dynamic> json) =>
      ListCaseHistory(
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
    required this.id,
    required this.addedDatetime,
    required this.dateTime,
    required this.filePath,
    required this.fileType,
    required this.documentName,
  });

  final String id;
  final DateTime addedDatetime;
  final DateTime dateTime;
  final String filePath;
  final String fileType;
  final String documentName;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        addedDatetime: DateTime.parse(json["added_datetime"]),
        dateTime: DateTime.parse(json["date_time"]),
        filePath: json["file_path"],
        fileType: json["file_type"],
        documentName: json["document_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "added_datetime":
            "${addedDatetime.year.toString().padLeft(4, '0')}-${addedDatetime.month.toString().padLeft(2, '0')}-${addedDatetime.day.toString().padLeft(2, '0')}",
        "date_time": dateTime,
        "file_path": filePath,
        "file_type": fileType,
        "document_name": documentName,
      };
}

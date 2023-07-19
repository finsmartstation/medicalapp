// To parse this JSON data, do
//
//     final organizationDetails = organizationDetailsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class OrganizationDetails {
    final bool status;
    final int statuscode;
    final String message;
    final Data data;

    OrganizationDetails({
        required this.status,
        required this.statuscode,
        required this.message,
        required this.data,
    });

    factory OrganizationDetails.fromRawJson(String str) => OrganizationDetails.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OrganizationDetails.fromJson(Map<String, dynamic> json) => OrganizationDetails(
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
    final String userId;
    final String organizationName;
    final String mobile;
    final String emergencyContact;
    final String website;
    final String pincode;
    final String address;
    final String type;
    final List<Gallery> gallery;

    Data({
        required this.userId,
        required this.organizationName,
        required this.mobile,
        required this.emergencyContact,
        required this.website,
        required this.pincode,
        required this.address,
        required this.type,
        required this.gallery,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        organizationName: json["organization_name"],
        mobile: json["mobile"],
        emergencyContact: json["emergency_contact"],
        website: json["website"],
        pincode: json["pincode"],
        address: json["address"],
        type: json["type"],
        gallery: List<Gallery>.from(json["gallery"].map((x) => Gallery.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "organization_name": organizationName,
        "mobile": mobile,
        "emergency_contact": emergencyContact,
        "website": website,
        "pincode": pincode,
        "address": address,
        "type": type,
        "gallery": List<dynamic>.from(gallery.map((x) => x.toJson())),
    };
}

class Gallery {
    final String filepath;

    Gallery({
        required this.filepath,
    });

    factory Gallery.fromRawJson(String str) => Gallery.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        filepath: json["filepath"],
    );

    Map<String, dynamic> toJson() => {
        "filepath": filepath,
    };
}

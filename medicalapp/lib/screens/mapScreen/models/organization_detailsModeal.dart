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

  factory OrganizationDetails.fromRawJson(String str) =>
      OrganizationDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrganizationDetails.fromJson(Map<String, dynamic> json) =>
      OrganizationDetails(
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
  final String hospitalName;
  final String email;
  final String countryCode;
  final String mobile;
  final String profilePic;
  final dynamic logo;
  final dynamic emergencyContact;
  final dynamic website;
  final dynamic pincode;
  final dynamic licenseNo;
  final dynamic establishedDate;
  final dynamic ownership;
  final dynamic address;
  final String halfProfilePic;
  final dynamic halfLogo;

  Data({
    required this.userId,
    required this.hospitalName,
    required this.email,
    required this.countryCode,
    required this.mobile,
    required this.profilePic,
    required this.logo,
    required this.emergencyContact,
    required this.website,
    required this.pincode,
    required this.licenseNo,
    required this.establishedDate,
    required this.ownership,
    required this.address,
    required this.halfProfilePic,
    required this.halfLogo,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"] ?? '',
        hospitalName: json["hospital_name"] ?? '',
        email: json["email"] ?? '',
        countryCode: json["country_code"] ?? '',
        mobile: json["mobile"] ?? '',
        profilePic: json["profile_pic"] ?? '',
        logo: json["logo"] ?? '',
        emergencyContact: json["emergency_contact"] ?? '',
        website: json["website"] ?? '',
        pincode: json["pincode"] ?? '',
        licenseNo: json["license_no"] ?? '',
        establishedDate: json["established_date"] ?? '',
        ownership: json["ownership"] ?? '',
        address: json["address"] ?? '',
        halfProfilePic: json["half_profile_pic"] ?? '',
        halfLogo: json["half_logo"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "hospital_name": hospitalName,
        "email": email,
        "country_code": countryCode,
        "mobile": mobile,
        "profile_pic": profilePic,
        "logo": logo,
        "emergency_contact": emergencyContact,
        "website": website,
        "pincode": pincode,
        "license_no": licenseNo,
        "established_date": establishedDate,
        "ownership": ownership,
        "address": address,
        "half_profile_pic": halfProfilePic,
        "half_logo": halfLogo,
      };
}

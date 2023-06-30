// To parse this JSON data, do
//
//     final dashboardGetModel = dashboardGetModelFromJson(jsonString);

import 'dart:convert';

class DashboardGetModel {
  DashboardGetModel({
    required this.status,
    required this.statuscode,
    required this.patientDetails,
    required this.nearByHospital,
    required this.nearByPharmacy,
    required this.specializationList,
    required this.slotStickers,
    required this.bannerList,
    required this.patientMessage,
    required this.nearByHospitalMessage,
    required this.nearByPharmacyMessage,
    required this.bannerListMessage,
    required this.specializationListMessage,
    required this.slotStickersMessage,
  });

  final bool status;
  final int statuscode;
  final PatientDetails patientDetails;
  final List<NearByHospital> nearByHospital;
  final List<NearByPharmacy> nearByPharmacy;
  final List<SpecializationList> specializationList;
  final List<dynamic> slotStickers;
  final List<BannerList> bannerList;
  final String patientMessage;
  final String nearByHospitalMessage;
  final String nearByPharmacyMessage;
  final String bannerListMessage;
  final String specializationListMessage;
  final String slotStickersMessage;

  factory DashboardGetModel.fromRawJson(String str) =>
      DashboardGetModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardGetModel.fromJson(Map<String, dynamic> json) =>
      DashboardGetModel(
        status: json["status"],
        statuscode: json["statuscode"],
        patientDetails: PatientDetails.fromJson(json["patient_details"]),
        nearByHospital: List<NearByHospital>.from(
            json["near_by_hospital"].map((x) => NearByHospital.fromJson(x))),
        nearByPharmacy: List<NearByPharmacy>.from(
            json["near_by_pharmacy"].map((x) => NearByPharmacy.fromJson(x))),
        specializationList: List<SpecializationList>.from(
            json["specialization_list"]
                .map((x) => SpecializationList.fromJson(x))),
        slotStickers: List<dynamic>.from(json["slot_stickers"].map((x) => x)),
        bannerList: List<BannerList>.from(
            json["banner_list"].map((x) => BannerList.fromJson(x))),
        patientMessage: json["patient_message"],
        nearByHospitalMessage: json["near_by_hospital_message"],
        nearByPharmacyMessage: json["near_by_pharmacy_message"],
        bannerListMessage: json["banner_list_message"],
        specializationListMessage: json["specialization_list_message"],
        slotStickersMessage: json["slot_stickers_message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statuscode": statuscode,
        "patient_details": patientDetails.toJson(),
        "near_by_hospital":
            List<dynamic>.from(nearByHospital.map((x) => x.toJson())),
        "near_by_pharmacy":
            List<dynamic>.from(nearByPharmacy.map((x) => x.toJson())),
        "specialization_list":
            List<dynamic>.from(specializationList.map((x) => x.toJson())),
        "slot_stickers": List<dynamic>.from(slotStickers.map((x) => x)),
        "banner_list": List<dynamic>.from(bannerList.map((x) => x.toJson())),
        "patient_message": patientMessage,
        "near_by_hospital_message": nearByHospitalMessage,
        "near_by_pharmacy_message": nearByPharmacyMessage,
        "banner_list_message": bannerListMessage,
        "specialization_list_message": specializationListMessage,
        "slot_stickers_message": slotStickersMessage,
      };
}

class BannerList {
  BannerList({
    required this.id,
    required this.image,
    required this.type,
    required this.description,
    required this.providerId,
  });

  final String id;
  final String image;
  final String type;
  final String description;
  final String providerId;

  factory BannerList.fromRawJson(String str) =>
      BannerList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerList.fromJson(Map<String, dynamic> json) => BannerList(
        id: json["id"],
        image: json["image"],
        type: json["type"],
        description: json["description"],
        providerId: json["provider_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "type": type,
        "description": description,
        "provider_id": providerId,
      };
}

class NearByHospital {
  NearByHospital({
    required this.id,
    required this.hospitalName,
  });

  final String id;
  final String hospitalName;

  factory NearByHospital.fromRawJson(String str) =>
      NearByHospital.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearByHospital.fromJson(Map<String, dynamic> json) => NearByHospital(
        id: json["id"],
        hospitalName: json["hospital_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hospital_name": hospitalName,
      };
}

class NearByPharmacy {
  NearByPharmacy({
    required this.id,
    required this.pharmacyName,
  });

  final String id;
  final String pharmacyName;

  factory NearByPharmacy.fromRawJson(String str) =>
      NearByPharmacy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearByPharmacy.fromJson(Map<String, dynamic> json) => NearByPharmacy(
        id: json["id"],
        pharmacyName: json["pharmacy_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pharmacy_name": pharmacyName,
      };
}

class PatientDetails {
  PatientDetails({
    required this.id,
    required this.username,
    required this.accessId,
    required this.mobile,
    required this.longitude,
    required this.latitude,
    required this.emailId,
    required this.gender,
    required this.loginStatus,
    required this.profilePic,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.familyMemberId,
    required this.relation,
    required this.dob,
    required this.halfPath,
    required this.email,
    required this.familyMemberIds,
  });

  final String id;
  final String username;
  final String accessId;
  final String mobile;
  final String longitude;
  final String latitude;
  final String emailId;
  final String gender;
  final String loginStatus;
  final String profilePic;
  final String bloodGroup;
  final String height;
  final String weight;
  final String familyMemberId;
  final String relation;
  final DateTime dob;
  final String halfPath;
  final String email;
  final List<FamilyMemberId> familyMemberIds;

  factory PatientDetails.fromRawJson(String str) =>
      PatientDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PatientDetails.fromJson(Map<String, dynamic> json) => PatientDetails(
        id: json["id"],
        username: json["username"],
        accessId: json["access_id"],
        mobile: json["mobile"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        emailId: json["email_id"],
        gender: json["gender"],
        loginStatus: json["login_status"],
        profilePic: json["profile_pic"],
        bloodGroup: json["blood_group"],
        height: json["height"],
        weight: json["weight"],
        familyMemberId: json["family_member_id"],
        relation: json["relation"],
        dob: DateTime.parse(json["dob"]),
        halfPath: json["half_path"],
        email: json["email"],
        familyMemberIds: List<FamilyMemberId>.from(
            json["family_member_ids"].map((x) => FamilyMemberId.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "access_id": accessId,
        "mobile": mobile,
        "longitude": longitude,
        "latitude": latitude,
        "email_id": emailId,
        "gender": gender,
        "login_status": loginStatus,
        "profile_pic": profilePic,
        "blood_group": bloodGroup,
        "height": height,
        "weight": weight,
        "family_member_id": familyMemberId,
        "relation": relation,
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "half_path": halfPath,
        "email": email,
        "family_member_ids":
            List<dynamic>.from(familyMemberIds.map((x) => x.toJson())),
      };
}

class FamilyMemberId {
  FamilyMemberId({
    required this.familyMemberId,
    required this.familyMemberName,
    required this.relation,
    required this.profilePic,
  });

  final String familyMemberId;
  final String familyMemberName;
  final String relation;
  final String profilePic;

  factory FamilyMemberId.fromRawJson(String str) =>
      FamilyMemberId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FamilyMemberId.fromJson(Map<String, dynamic> json) => FamilyMemberId(
        familyMemberId: json["family_member_id"],
        familyMemberName: json["family_member_name"],
        relation: json["relation"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "family_member_id": familyMemberId,
        "family_member_name": familyMemberName,
        "relation": relation,
        "profile_pic": profilePic,
      };
}

class SpecializationList {
  SpecializationList({
    required this.specialization,
    required this.imagePath,
    required this.specializationId,
  });

  final String specialization;
  final String imagePath;
  final String specializationId;

  factory SpecializationList.fromRawJson(String str) =>
      SpecializationList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SpecializationList.fromJson(Map<String, dynamic> json) =>
      SpecializationList(
        specialization: json["specialization"],
        imagePath: json["image_path"],
        specializationId: json["specialization_id"],
      );

  Map<String, dynamic> toJson() => {
        "specialization": specialization,
        "image_path": imagePath,
        "specialization_id": specializationId,
      };
}
// To parse this JSON data, do
//
//     final dashboardSearch = dashboardSearchFromJson(jsonString);

class DashboardSearch {
  DashboardSearch({
    required this.status,
    required this.statuscode,
    required this.message,
    required this.data,
  });

  final bool status;
  final int statuscode;
  final String message;
  final Data data;

  factory DashboardSearch.fromRawJson(String str) =>
      DashboardSearch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardSearch.fromJson(Map<String, dynamic> json) =>
      DashboardSearch(
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
    required this.doctors,
    required this.hospital,
    required this.lab,
    required this.pharmacy,
  });

  final List<Doctor> doctors;
  final List<Hospital> hospital;
  final List<Hospital> lab;
  final List<Hospital> pharmacy;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        doctors:
            List<Doctor>.from(json["doctors"].map((x) => Doctor.fromJson(x))),
        hospital: List<Hospital>.from(
            json["hospital"].map((x) => Hospital.fromJson(x))),
        lab: List<Hospital>.from(json["lab"].map((x) => Hospital.fromJson(x))),
        pharmacy: List<Hospital>.from(
            json["pharmacy"].map((x) => Hospital.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "doctors": List<dynamic>.from(doctors.map((x) => x.toJson())),
        "hospital": List<dynamic>.from(hospital.map((x) => x.toJson())),
        "lab": List<dynamic>.from(lab.map((x) => x.toJson())),
        "pharmacy": List<dynamic>.from(pharmacy.map((x) => x.toJson())),
      };
}

class Doctor {
  Doctor({
    required this.id,
    required this.name,
    required this.profilePic,
    required this.experience,
    required this.favouriteDoctorStatus,
    required this.familyDoctorStatus,
    required this.organisation,
    required this.specialization,
  });

  final String id;
  final String name;
  final String profilePic;
  final dynamic experience;
  final String favouriteDoctorStatus;
  final String familyDoctorStatus;
  final String organisation;
  final String specialization;

  factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        name: json["name"],
        profilePic: json["profile_pic"],
        experience: json["experience"],
        favouriteDoctorStatus: json["favourite_doctor_status"],
        familyDoctorStatus: json["family_doctor_status"],
        organisation: json["organisation"],
        specialization: json["specialization"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_pic": profilePic,
        "experience": experience,
        "favourite_doctor_status": favouriteDoctorStatus,
        "family_doctor_status": familyDoctorStatus,
        "organisation": organisation,
        "specialization": specialization,
      };
}

class Hospital {
  Hospital({
    required this.id,
    required this.name,
    required this.profilePic,
    required this.specialization,
  });

  final String id;
  final String name;
  final String profilePic;
  final String specialization;

  factory Hospital.fromRawJson(String str) =>
      Hospital.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json["id"],
        name: json["name"],
        profilePic: json["profile_pic"],
        specialization: json["specialization"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_pic": profilePic,
        "specialization": specialization,
      };
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:medicalapp/screens/dashboard/nearbyHospitalModel.dart';

import '../providers/auth_provider.dart';
import '../utility/constants.dart';

class ApiService {
  final String _u_id = '';
  final String _otp = '';
  final String _access_token = '';
  AuthProvider authProvider = AuthProvider();

  // User Register

  Future<http.Response> registerUser(String cCode, String phone, String type,
      String aId, String sign,String FCM_Token) async {
    String url = '${baseUrl}register';
    var obj = {
      'country_code': cCode,
      'mobile': phone,
      'device_type': type,
      'access_id': aId,
      'app_signature_id': sign,
      'FCM_Token':FCM_Token,
    };
    print('OBJECT : $obj');
    var response = await http.post(Uri.parse(url), body: obj);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('RESPONSE: $jsonData');
      if(jsonData['status']=="false"){
      authProvider.getDetails(
          jsonData['user_id'], jsonData['otp'], jsonData['access_token']);
      }
    }
    return response;
  }

  // Resend OTP

  Future<void> resendOTP(String id) async {
    String url = '${baseUrl}resend_otp';
    var obj = {
      'user_id': id,
    };

    var response = await http.post(Uri.parse(url), body: obj);

    if (response.statusCode == 200) {
      var jsonOTP = jsonDecode(response.body)['data'];
      print('OTP : $jsonOTP');
    }
  }

  // Verify OTP

  Future<http.Response> verifyOTP(
      String userId, String accessToken, String otp) async {
    String url = '${baseUrl}verify_otp';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "otp": otp,
    };
    var response = await http.post(Uri.parse(url), body: obj);
    return response;
  }

  // Fill Profile

  Future<http.StreamedResponse> fillProfile(id, accesToken, username, email,
      lat, lon, ipAdd, File imageFile, gender) async {
    String url = '${baseUrl}fill_profile';
    print("TESTING================> : ${imageFile.path}");

    // print("OBJ UPR: ${obj}");
    // var response = await http.post(Uri.parse(url), body: {});
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var multipartFile = http.MultipartFile('profile_pic', stream, length,
        filename: imageFile.path);
    request.fields['user_id'] = id;
    request.fields['access_token'] = accesToken;
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['latitude'] = lat;
    request.fields['longitude'] = lon;
    request.fields['ip_address'] = ipAdd;
    request.fields['gender'] = gender;
    request.files.add(multipartFile);
    var resp = await request.send();

    return resp;
    /* if (response.statusCode == 200) {
      //var jsonData = jsonDecode(response.body)['data'];
      var jsonData = jsonDecode(response.body);
      print(jsonData);
      print('RESPONSE: ${jsonData}');
       return jsonData ;
      }*/
  }

  // Add Specialization

  Future<http.Response> addSpecialization(
      userId, accessToken, specialization) async {
    String url = '${baseUrl}add_employee_specialization';
    var obj = {
      'user_id': userId,
      'access_token': accessToken,
      'specialization': specialization,
    };

    var response = await http.post(Uri.parse(url));

    // if (response.statusCode == 200) {
    //   var jsonData = jsonDecode(response.body);
    //   print('RESPONSE SP: ${jsonData}');
    //
    //   return jsonData;
    // }
    return response;
  }

  //Doctor consulting fee

  Future<http.Response> addConsultingFee(
      userId, accessToken, consultingFee) async {
    String url = '${baseUrl}add_doctor_consulting_fee';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "consulting_fee": consultingFee,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print(obj);
    return response;
  }

  //Add specialization

  Future<http.Response> getSpecialization() async {
    String url = '${baseUrl}get_all_specialization';
    var response = await http.post(Uri.parse(url));
    print("success");
    //var jsonData;
    return response;
  }

//  get Userdetails

  Future<http.Response> getUserDetails(userId, accessToken) async {
    String url = '${baseUrl}get_doctor_basic_details';
    var userObj = {
      'user_id': userId,
      'access_token': accessToken,
    };
    var response = await http.post(Uri.parse(url), body: userObj);
    print("SETUP: ${response.body.length}");
    return response;
  }

  //Add Employe Experience
  Future<http.StreamedResponse> addExperience(userId, accessToken, hospital,
      years, position, experienceDocument) async {
    String url = '${baseUrl}add_employee_experience';
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath(
        'experience_document', experienceDocument));
    request.fields['user_id'] = userId;
    request.fields['access_token'] = accessToken;
    request.fields['hospital'] = hospital;
    request.fields['years'] = years;
    request.fields['position'] = position;
    var resp = await request.send();
    return resp;
  }

  //Add Employe add_employee_qualification
  Future<http.StreamedResponse> addQualification(
    userId,
    accessToken,
    qualification,
    startYear,
    endYear,
    qualificationDocument,
  ) async {
    String url = '${baseUrl}add_employee_qualification';
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath(
        'qualification_document', qualificationDocument));
    request.fields['user_id'] = userId;
    request.fields['access_token'] = accessToken;
    request.fields['qualification'] = qualification;
    request.fields['start_year'] = startYear;
    request.fields['end_year'] = endYear;
    var resp = await request.send();
    return resp;
  }

//Add Employe add_employee_specialization
  Future<http.Response> addEmployeeSpecialization(
      userId, accessToken, specialization) async {
    String url = '${baseUrl}add_employee_specialization';
    var userObj = {
      'user_id': userId,
      'access_token': accessToken,
      'specialization': specialization
    };
    var response = await http.post(Uri.parse(url), body: userObj);
    return response;
  }
  //add doctor slot

  Future<http.Response> addDoctorSlot(userId, accessToken, consultingTime,
      consultingType, startDatetime, endDatetime, breakStatus,organizationId) async {
    String url = '${baseUrl}add_doctor_slot';
    var userObj = {
      'user_id': userId,
      'access_token': accessToken,
      'consulting_time': consultingTime,
      'consulting_type': consultingType,
      'start_datetime': startDatetime,
      'end_datetime': endDatetime,
      'break_status': breakStatus,
      'organization_id':organizationId
    };
    print('obj---$userObj');
    var response = await http.post(Uri.parse(url), body: userObj);
    print('success');
    print("obj===$userObj");
    print("SETUP: ${response.body}");
    return response;
  }

  //file_upload
  Future<http.StreamedResponse> file_upload(userId, accessToken, file) async {
    String url = '${baseUrl}file_upload';
     var obj = {
      'user_id': userId,
      'access_token': accessToken,
      "file":file
    };
    print("obj==$obj");
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', file));
    request.fields['user_id'] = userId;
    request.fields['access_token'] = accessToken;
    var resp = await request.send();
    return resp;
  }

  //update_employee_qualification
  Future<http.Response> update_employee_qualification(userId, accessToken,
      qualification, startYear, endYear, uploadDocuments) async {
    String url = '${baseUrl}update_employee_qualification';
    var obj = {
      'user_id': userId,
      'access_token': accessToken,
      'qualification': qualification,
      'start_year': startYear,
      'end_year': endYear,
      'upload_documents': uploadDocuments,
    };
    print(obj);
    var respons = await http.post(Uri.parse(url), body: obj);
    print(respons.body);
    return respons;
  }

  //update_employee_experience
  Future<http.Response> update_employee_experience(userId, accessToken,
      hospital, position, years, experienceDocuments) async {
    String url = '${baseUrl}update_employee_experience';
    var obj = {
      'user_id': userId,
      'access_token': accessToken,
      'hospital': hospital,
      'position': position,
      'years': years,
      'experience_documents': experienceDocuments,
    };
    print(obj);
    var respons = await http.post(Uri.parse(url), body: obj);
    print(respons.body);
    return respons;
  }

  //add_doctor_basic_details
  Future<http.Response> add_doctor_basic_details(userId, accessToken,
      username, email, profilePic, List specialization, consultingFee) async {
    String url = '${baseUrl}add_doctor_basic_details';
    print("#######TTTTT######: $specialization");

    var userObj = {
      "user_id": userId,
      "access_token": accessToken,
      "specialization": specialization,
      "username": username,
      "email": email,
      "consulting_fee": consultingFee,
      "profile_pic": profilePic,
    };
    print("obj---$userObj");
    var response = await http.post(Uri.parse(url), body: jsonEncode(userObj));
    print("::::::Response::::: ${response.body}");
    return response;
  }

  //doctor details

  Future<http.Response> doctorDetails(userId, accessToken) async {
    String url = '${baseUrl}doctor_details';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
    };
    print("obj---$obj");
    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print(obj);
    return response;
  }

  // Future<GetPatientFamilyDoctor> getPatientFamilyDoctor(
  //     doctorId, access_token) async {
  //   String url = baseUrl + 'family_doctor_history';
  //   var obj = {"doctor_id": doctorId, "access_token": access_token};
  //   var response = await http.post(Uri.parse(url), body: obj);
  //   print("success");
  //   print(obj);
  //   print("status code---");
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     final data = GetPatientFamilyDoctor.fromJson(jsonDecode(response.body));
  //     //print(data);
  //     print("data--$data");
  //     return data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  // Future<GetPatientAppointment> getPatientAppointment(
  //     doctorId, access_token) async {
  //   String url = baseUrl + 'doctor_upcomming_appoinments';
  //   var obj = {"doctor_id": doctorId, "access_token": access_token};
  //   var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
  //   print("success");
  //   print(obj);
  //   if (response.statusCode == 200) {
  //     final data = GetPatientAppointment.fromJson(jsonDecode(response.body));
  //     print(data);
  //     return data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  // Future<GetDoctorMyAppointment> getDoctorMyAppointment(
  //     doctorId, access_token) async {
  //   String url = baseUrl + 'doctors_my_appoinment';
  //   var obj = {"doctor_id": doctorId, "access_token": access_token};
  //   var response = await http.post(Uri.parse(url), body: obj);
  //   print("success");
  //   print(obj);
  //   if (response.statusCode == 200) {
  //     final data = GetDoctorMyAppointment.fromJson(jsonDecode(response.body));
  //     print(data);
  //     return data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  // Future<http.Response> doctorStatus(
  //     String user_id, String access_token, String available_status) async {
  //   String url = baseUrl + 'doctor_available_status';
  //   var obj = {
  //     "user_id": user_id,
  //     "access_token": access_token,
  //     "available_status": available_status,
  //   };

  //   var response = await http.post(Uri.parse(url), body: obj);
  //   print("success");
  //   print("obj--$obj");
  //   print("resp:${jsonDecode(response.body)}");
  //   return response;
  // }

  // Future<GetDoctorHistory> getDoctorHistory(doctorId, access_token) async {
  //   String url = baseUrl + 'doctors_appoinment_history';
  //   var obj = {"doctor_id": doctorId, "access_token": access_token};
  //   var response = await http.post(Uri.parse(url), body: obj);
  //   print("success");
  //   print(obj);
  //   if (response.statusCode == 200) {
  //     final data = GetDoctorHistory.fromJson(jsonDecode(response.body));
  //     print(data);
  //     return data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }
  // Future<GetPatientMedicalReport> getPatientMedicalReport(doctor_id, access_token,patient_id) async {
  //   String url = baseUrl + 'list_patient_medical_history';
  //   var obj = {"doctor_id": doctor_id, "access_token": access_token,"patient_id":patient_id};
  //   var response = await http.post(Uri.parse(url), body: obj);
  //   print("success");
  //   print(obj);
  //   if (response.statusCode == 200) {
  //     final data = GetPatientMedicalReport.fromJson(jsonDecode(response.body));
  //     print(data);
  //     return data;
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }


  Future<http.Response> consultationStatus(
      String userId, String accessToken, String slotId) async {
    String url = '${baseUrl}consultation_status';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "slot_id": slotId
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }

  Future<http.Response> addPrescription(String slotId, String accessToken,
      String userId, String prescription) async {
    String url = '${baseUrl}add_prescription';
    var obj = {
      "slot_id": slotId,
      "access_token": accessToken,
      "user_id": userId,
      "prescription": prescription
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }

  Future<http.Response> generateMedicalReport(
    String userId,
      String accessToken,
      String bookingSlotId,
      String refferedDoctor  ,
      String refferedLab,
      String clinicalNotes,
      String labNote,
      String followUpDate) async {
    String url = '${baseUrl}generate_medical_report';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "booking_slot_id": bookingSlotId,
      "reffered_doctor": refferedDoctor,
      "reffered_lab": refferedLab,
      "clinical_notes": clinicalNotes,
      "lab_note":labNote,
      "follow_up_date": followUpDate,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }

  Future<http.Response> doctorFeedback(String userId, String accessToken,
      String feedback, String rating) async {
    String url = '${baseUrl}doctor_feedback';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "feedback": feedback,
      "rating": rating
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }
   Future<http.Response> deleteDoctorSlot(String userId,String doctorSlotId, String accessToken,
      ) async {
    String url = '${baseUrl}delete_doctor_slot';
    var obj = {
      "user_id": userId,
      "doctor_slot_id": doctorSlotId,
      "access_token": accessToken,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }
  Future<http.Response> editDoctorProfile(String userId, String accessToken,
      String name, String gender,String email,String profilePic) async {
    String url = '${baseUrl}edit_doctor_profile';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "name": name,
      "gender": gender,
      "email":email,
      "profile_pic":profilePic
    };
    print("obj--$obj");
    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }
  Future<http.Response> doctorBasicDetails(String userId, String accessToken,
      String name, String email,String profilePic,String gender) async {
    String url = '${baseUrl}doctor_basic_details';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
      "name": name,
      "email":email,
      "profile_pic":profilePic,
      "gender": gender,
    };
    print("obj--$obj");
    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  } 
  Future<http.Response> getOrganization(String userId,String accessToken) async {
    String url = '${baseUrl}list_all_organization';
    var obj={
      "user_id":userId,
      "access_token":accessToken
    };
    print("obj---$obj");
    var response = await http.post(Uri.parse(url),body: obj);
    print("success");
    //var jsonData;
    return response;
  }
  Future<http.Response> addOrganization(String doctorId,String accessToken,List hospitalId) async {
    String url = '${baseUrl}add_doctor_organizations';
    var obj={
      "access_token":accessToken,
      "doctor_id":doctorId,
      "hospital_ids":hospitalId
    };
    print("obj---$obj");
    var response = await http.post(Uri.parse(url),body: jsonEncode(obj));
    print("success");
    print("resp:${jsonDecode(response.body)}");
    //var jsonData;
    return response;
  }
  Future<http.Response> listDoctorOrganization(String userId,String accessToken) async {
    String url = '${baseUrl}list_doctor_current_organization';
    var obj={
      "user_id":userId,
      "access_token":accessToken,
    };
    print("obj1111---$obj");
    var response = await http.post(Uri.parse(url),body: obj);
    print("success");
    print("resp:${jsonDecode(response.body)}");
    //var jsonData;
    return response;
  }
  Future<GetNearbyHospitalModel> getNearbyHospital(
    userId, accessToken, lat,long) async {
  String url = '${baseUrl}near_by_hospital_list';
  var obj = {
    "user_id": userId,
    "access_token": accessToken,
    "latitude": lat,
    "longitude":long
  };
  print(obj);
  var respons = await http.post(
    Uri.parse(url),
    body: jsonEncode(obj),
  );
  if (respons.statusCode == 200) {
    final data = GetNearbyHospitalModel.fromJson(jsonDecode(respons.body));
    //print(data.familyDoctor);
   // print(data.data.length);
    return data;
  } else {
    throw Exception('Failed to load users');
  }
}
}

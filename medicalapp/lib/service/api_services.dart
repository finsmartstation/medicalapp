import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import '../providers/auth_provider.dart';
import '../utility/constants.dart';

class ApiService {
  String _u_id = '';
  String _otp = '';
  String _access_token = '';
  AuthProvider authProvider = AuthProvider();

  // User Register

  Future<http.Response> registerUser(String c_code, String phone, String type,
      String a_id, String sign) async {
    String url = baseUrl + 'register';
    var obj = {
      'country_code': c_code,
      'mobile': phone,
      'device_type': type,
      'access_id': a_id,
      'app_signature_id': sign,
    };
    print('OBJECT : ${obj}');
    var response = await http.post(Uri.parse(url), body: obj);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print('RESPONSE: ${jsonData}');
      if(jsonData['status']=="false"){
      authProvider.getDetails(
          jsonData['user_id'], jsonData['otp'], jsonData['access_token']);
      }
    }
    return response;
  }

  // Resend OTP

  Future<void> resendOTP(String id) async {
    String url = baseUrl + 'resend_otp';
    var obj = {
      'user_id': id,
    };

    var response = await http.post(Uri.parse(url), body: obj);

    if (response.statusCode == 200) {
      var jsonOTP = jsonDecode(response.body)['data'];
      print('OTP : ${jsonOTP}');
    }
  }

  // Verify OTP

  Future<http.Response> verifyOTP(
      String userId, String access_token, String otp) async {
    String url = baseUrl + 'verify_otp';
    var obj = {
      "user_id": userId,
      "access_token": access_token,
      "otp": otp,
    };
    var response = await http.post(Uri.parse(url), body: obj);
    return response;
  }

  // Fill Profile

  Future<http.StreamedResponse> fillProfile(id, acces_token, username, email,
      lat, lon, ip_add, File imageFile, gender) async {
    String url = baseUrl + 'fill_profile';
    print("TESTING================> : ${imageFile.path}");

    // print("OBJ UPR: ${obj}");
    // var response = await http.post(Uri.parse(url), body: {});
    var stream = new http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    var multipartFile = http.MultipartFile('profile_pic', stream, length,
        filename: imageFile.path);
    request.fields['user_id'] = id;
    request.fields['access_token'] = acces_token;
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['latitude'] = lat;
    request.fields['longitude'] = lon;
    request.fields['ip_address'] = ip_add;
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
      user_id, access_token, specialization) async {
    String url = baseUrl + 'add_employee_specialization';
    var obj = {
      'user_id': user_id,
      'access_token': access_token,
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
      user_id, access_token, consulting_fee) async {
    String url = baseUrl + 'add_doctor_consulting_fee';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
      "consulting_fee": consulting_fee,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print(obj);
    return response;
  }

  //Add specialization

  Future<http.Response> getSpecialization() async {
    String url = baseUrl + 'get_all_specialization';
    var response = await http.post(Uri.parse(url));
    print("success");
    var jsonData;
    return response;
  }

//  get Userdetails

  Future<http.Response> getUserDetails(user_id, access_token) async {
    String url = baseUrl + 'get_doctor_basic_details';
    var userObj = {
      'user_id': user_id,
      'access_token': access_token,
    };
    var response = await http.post(Uri.parse(url), body: userObj);
    print("SETUP: ${response.body.length}");
    return response;
  }

  //Add Employe Experience
  Future<http.StreamedResponse> addExperience(userId, accessToken, hospital,
      years, position, experience_document) async {
    String url = baseUrl + 'add_employee_experience';
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath(
        'experience_document', experience_document));
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
    start_year,
    end_year,
    qualification_document,
  ) async {
    String url = baseUrl + 'add_employee_qualification';
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath(
        'qualification_document', qualification_document));
    request.fields['user_id'] = userId;
    request.fields['access_token'] = accessToken;
    request.fields['qualification'] = qualification;
    request.fields['start_year'] = start_year;
    request.fields['end_year'] = end_year;
    var resp = await request.send();
    return resp;
  }

//Add Employe add_employee_specialization
  Future<http.Response> addEmployeeSpecialization(
      userId, accessToken, specialization) async {
    String url = baseUrl + 'add_employee_specialization';
    var userObj = {
      'user_id': userId,
      'access_token': accessToken,
      'specialization': specialization
    };
    var response = await http.post(Uri.parse(url), body: userObj);
    return response;
  }
  //add doctor slot

  Future<http.Response> addDoctorSlot(user_id, access_token, consulting_time,
      consulting_type, start_datetime, end_datetime, break_status,organization_id) async {
    String url = baseUrl + 'add_doctor_slot';
    var userObj = {
      'user_id': user_id,
      'access_token': access_token,
      'consulting_time': consulting_time,
      'consulting_type': consulting_type,
      'start_datetime': start_datetime,
      'end_datetime': end_datetime,
      'break_status': break_status,
      'organization_id':organization_id
    };
    print('obj---$userObj');
    var response = await http.post(Uri.parse(url), body: userObj);
    print('success');
    print("obj===$userObj");
    print("SETUP: ${response.body}");
    return response;
  }

  //file_upload
  Future<http.StreamedResponse> file_upload(user_id, access_token, file) async {
    String url = baseUrl + 'file_upload';
     var obj = {
      'user_id': user_id,
      'access_token': access_token,
      "file":file
    };
    print("obj==$obj");
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', file));
    request.fields['user_id'] = user_id;
    request.fields['access_token'] = access_token;
    var resp = await request.send();
    return resp;
  }

  //update_employee_qualification
  Future<http.Response> update_employee_qualification(user_id, access_token,
      qualification, start_year, end_year, upload_documents) async {
    String url = baseUrl + 'update_employee_qualification';
    var obj = {
      'user_id': user_id,
      'access_token': access_token,
      'qualification': qualification,
      'start_year': start_year,
      'end_year': end_year,
      'upload_documents': upload_documents,
    };
    print(obj);
    var respons = await http.post(Uri.parse(url), body: obj);
    print(respons.body);
    return respons;
  }

  //update_employee_experience
  Future<http.Response> update_employee_experience(user_id, access_token,
      hospital, position, years, experience_documents) async {
    String url = baseUrl + 'update_employee_experience';
    var obj = {
      'user_id': user_id,
      'access_token': access_token,
      'hospital': hospital,
      'position': position,
      'years': years,
      'experience_documents': experience_documents,
    };
    print(obj);
    var respons = await http.post(Uri.parse(url), body: obj);
    print(respons.body);
    return respons;
  }

  //add_doctor_basic_details
  Future<http.Response> add_doctor_basic_details(user_id, access_token,
      username, email, profile_pic, List specialization, consulting_fee) async {
    String url = baseUrl + 'add_doctor_basic_details';
    print("#######TTTTT######: ${specialization}");

    var userObj = {
      "user_id": user_id,
      "access_token": access_token,
      "specialization": specialization,
      "username": username,
      "email": email,
      "consulting_fee": consulting_fee,
      "profile_pic": profile_pic,
    };
    print("obj---$userObj");
    var response = await http.post(Uri.parse(url), body: jsonEncode(userObj));
    print("::::::Response::::: ${response.body}");
    return response;
  }

  //doctor details

  Future<http.Response> doctorDetails(user_id, access_token) async {
    String url = baseUrl + 'doctor_details';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
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
      String user_id, String access_token, String slot_id) async {
    String url = baseUrl + 'consultation_status';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
      "slot_id": slot_id
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }

  Future<http.Response> addPrescription(String slot_id, String access_token,
      String user_id, String prescription) async {
    String url = baseUrl + 'add_prescription';
    var obj = {
      "slot_id": slot_id,
      "access_token": access_token,
      "user_id": user_id,
      "prescription": prescription
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }

  Future<http.Response> generateMedicalReport(
    String user_id,
      String access_token,
      String booking_slot_id,
      String reffered_doctor  ,
      String reffered_lab,
      String clinical_notes,
      String lab_note,
      String follow_up_date) async {
    String url = baseUrl + 'generate_medical_report';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
      "booking_slot_id": booking_slot_id,
      "reffered_doctor": reffered_doctor,
      "reffered_lab": reffered_lab,
      "clinical_notes": clinical_notes,
      "lab_note":lab_note,
      "follow_up_date": follow_up_date,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }

  Future<http.Response> doctorFeedback(String user_id, String access_token,
      String feedback, String rating) async {
    String url = baseUrl + 'doctor_feedback';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
      "feedback": feedback,
      "rating": rating
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }
   Future<http.Response> deleteDoctorSlot(String user_id,String doctor_slot_id, String access_token,
      ) async {
    String url = baseUrl + 'delete_doctor_slot';
    var obj = {
      "user_id": user_id,
      "doctor_slot_id": doctor_slot_id,
      "access_token": access_token,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }
  Future<http.Response> editDoctorProfile(String user_id, String access_token,
      String name, String gender,String email,String profile_pic) async {
    String url = baseUrl + 'edit_doctor_profile';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
      "name": name,
      "gender": gender,
      "email":email,
      "profile_pic":profile_pic
    };
    print("obj--$obj");
    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  }
  Future<http.Response> doctorBasicDetails(String user_id, String access_token,
      String name, String email,String profile_pic,String gender) async {
    String url = baseUrl + 'doctor_basic_details';
    var obj = {
      "user_id": user_id,
      "access_token": access_token,
      "name": name,
      "email":email,
      "profile_pic":profile_pic,
      "gender": gender,
    };
    print("obj--$obj");
    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print("obj--$obj");
    print("resp:${jsonDecode(response.body)}");
    return response;
  } 
  Future<http.Response> getOrganization(String user_id,String access_token) async {
    String url = baseUrl + 'list_all_organization';
    var obj={
      "user_id":user_id,
      "access_token":access_token
    };
    print("obj---$obj");
    var response = await http.post(Uri.parse(url),body: obj);
    print("success");
    var jsonData;
    return response;
  }
  Future<http.Response> addOrganization(String doctor_id,String access_token,List hospital_id) async {
    String url = baseUrl + 'add_doctor_organizations';
    var obj={
      "access_token":access_token,
      "doctor_id":doctor_id,
      "hospital_ids":hospital_id
    };
    print("obj---$obj");
    var response = await http.post(Uri.parse(url),body: jsonEncode(obj));
    print("success");
    print("resp:${jsonDecode(response.body)}");
    var jsonData;
    return response;
  }
  Future<http.Response> listDoctorOrganization(String user_id,String access_token) async {
    String url = baseUrl + 'list_doctor_current_organization';
    var obj={
      "user_id":user_id,
      "access_token":access_token,
    };
    print("obj1111---$obj");
    var response = await http.post(Uri.parse(url),body: obj);
    print("success");
    print("resp:${jsonDecode(response.body)}");
    //var jsonData;
    return response;
  }
}

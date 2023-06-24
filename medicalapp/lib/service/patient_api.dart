import 'dart:convert';

import 'package:http/http.dart' as http;

import '../screens/doctorList/Modeal.dart';
import '../utility/constants.dart';

class PatientApi {
  //list all hospital

  Future<Map<String, dynamic>> listHospital(userId, accessToken) async {
    String url = '${baseUrl}list_all_hospitals';
    var obj = {
      "user_id": userId,
      "access_token": accessToken,
    };

    var response = await http.post(Uri.parse(url), body: obj);
    print("success");
    print(obj);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return {"data": data};
    } else {
      throw Exception('Failed to load users');
    }
  }

  //add_family_members
  Future<http.Response> add_family_members(userId, accessToken, gender, name,
      relation, dob, bloodGroup, height, weight, profilePic) async {
    String url = '${baseUrl}add_family_members';
    var obj = {
      "user_id": userId.toString(),
      "access_token": accessToken.toString(),
      "gender": gender,
      "name": name,
      "relation": relation,
      "dob": dob,
      "blood_group": bloodGroup,
      "height": height,
      "weight": weight,
      "profile_pic": profilePic
    };
    var response = await http.post(Uri.parse(url), body: jsonEncode(obj));
    return response;
  }
  // //get_family_members
}

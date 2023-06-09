import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medicalapp/utility/constants.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../providers/petientdetailsGetProvider.dart';
import '../../providers/phone_provider.dart';
import '../../service/api_services.dart';
import '../UserProfile/patient_basic_details.dart';
import '../dashboard/dashboardScreen.dart';

class OtpSection extends StatefulWidget {
  String phoneNum;
  String otp;
  OtpSection({Key? key, required this.phoneNum, required this.otp})
      : super(key: key);

  @override
  State<OtpSection> createState() => _OtpSectionState();
}

class _OtpSectionState extends State<OtpSection> {
  String? uName;
  String? email;
  String? profilePic;
  String? role;
  String? user_id;
  String? access_token;
  final OtpFieldController _pinController = OtpFieldController();
  Future setProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (uName!.isNotEmpty) {
      prefs.setString('userName', uName!);
    }
    if (email!.isNotEmpty) {
      prefs.setString('email', email!);
    }
    if (profilePic!.isNotEmpty) {
      prefs.setString('profilePicture', profilePic!);
    }
    prefs.setString('accessToken', access_token!);
    prefs.setString('userId', user_id!);
    print("profile set");
    print(prefs.getString("userId"));
    print(prefs.getString("accessToken"));
  }

  setUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', access_token!);
    prefs.setString('userId', user_id!);
    print("profile set");
    print(prefs.getString("userId"));
    print(prefs.getString("accessToken"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      List<String> a = widget.otp.split("");
      _pinController.setValue(a[0], 0);
      _pinController.setValue(a[1], 1);
      _pinController.setValue(a[2], 2);
      _pinController.setValue(a[3], 3);
      _pinController.setValue(a[4], 4);
      _pinController.setValue(a[5], 5);
      print("______________________");
      print(a);
      print("______________________");
    });

    print("otp");
    print(widget.otp);
    print("num");
    print(widget.phoneNum);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PhoneProvider, AuthProvider>(
        builder: (context, pValue, aValue, child) {
      String userId = aValue.u_id;
      String accessToken = aValue.access_token;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            backgroundPlusImage(),
            const SizedBox(
              height: 20,
            ),
            verifyingNumTextWidget(),
            const SizedBox(
              height: 80,
            ),
            const Center(
                child: Text("Waiting to automatically detect an SMS send to")),
            Center(
              child: Row(
                children: [
                  const Spacer(),
                  Text("${widget.phoneNum}."),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Wrong number")),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Otpfiled(aValue, userId, accessToken, context, pValue),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Enter 6 -digits code",
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            const Spacer(),
            Row(
              children: [
                const SizedBox(
                  width: 60,
                ),
                backgroundPlusImage(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Divider(
                endIndent: 40,
                thickness: 1,
                indent: 40,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Spacer(),
                const Text("If you didn't receive code?"),
                TextButton(onPressed: () {}, child: const Text("Resend")),
                const Spacer()
              ],
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      );
    });
  }

  Center Otpfiled(AuthProvider aValue, String userId, String accessToken,
      BuildContext context, PhoneProvider pValue) {
    return Center(
      child: OTPTextField(
          length: 6,
          width: 300,
          fieldWidth: 40,
          controller: _pinController,
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.box,
          style: const TextStyle(fontSize: 17),
          onChanged: (val) {
            Future.delayed(const Duration(seconds: 1), (() {
              print(val);
              print('changed');
              print(aValue.otp);
              print(_pinController);
              if (val == aValue.otp) {
                // _countDownController.pause();
                ApiService()
                    .verifyOTP(aValue.u_id, aValue.access_token, val)
                    .then((value) async {
                  // print(value.body);

                  if (value.statusCode == 200) {
                    var jsonData = jsonDecode(value.body)['data'];
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('user_id', jsonData['user_id']);
                    prefs.setString('access_token', jsonData['access_token']);

                    userId = jsonData['user_id'];
                    accessToken = jsonData['access_token'];
                    role = jsonData['user_type'];
                    setUserId();
                    print("user id");
                    print(aValue.u_id);
                    print(accessToken);
                    print("userId and token===");
                    print(userId);
                    print(accessToken);

                    print(jsonData['login_status']);
                    print(role);
                    if (role == "Patient") {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('isLogin', "patient");
                      setState(() {
                        context
                            .read<GetpetientDetails>()
                            .fetchdata(userId, accessToken);
                      });

                      if (jsonData['login_status'] == "0") {
                        print("1234New");
                        pValue.isValid(false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PatientBasicDetails()));
                      }
                      if (jsonData['login_status'] == "1") {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("isLogin", "patient");
                        pValue.isValid(false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DashboardPatient(
                                      family_member_id: "",
                                    )));
                      }
                    }
                    // _countDownController.pause();
                  }
                  // print("USER: ==> ${}")
                });
              } else {
                // print("wrogggggggggggggggggggge");
                // ScaffoldMessenger.of(context)
                //     .showSnackBar(SnackBar(
                //   content: Text(
                //     "Invalid Otp",
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   backgroundColor: Colors.blue[800],
                //   elevation: 10,
                // ));
              }

              // print(_pinController.text);
              // print(a_value.u_id);
              // print(a_value.access_token);
            }));
          },
          onCompleted: (val) {}),
    );
  }

  Center verifyingNumTextWidget() {
    return const Center(
        child: Text(
      "Verifiying your number",
      style: TextStyle(color: Colors.black, fontSize: 18),
    ));
  }

  Row backgroundPlusImage() {
    return Row(
      children: [
        SizedBox(
          height: 50,
          child: Image.asset(
            elems,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

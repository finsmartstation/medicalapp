import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:medicalapp/utility/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../providers/auth_provider.dart';
import '../../providers/phone_provider.dart';
import '../../service/api_services.dart';
import 'otpSection.dart';

class InputMobileNumScreen extends StatefulWidget {
  const InputMobileNumScreen({super.key});

  @override
  State<InputMobileNumScreen> createState() => _InputMobileNumScreenState();
}

class _InputMobileNumScreenState extends State<InputMobileNumScreen> {
  String _phone = '';
  final phoneController = TextEditingController();
  String? appSignature;
  String? otpCode;
  bool isOver = false;
  bool isOverr = false;
  bool isLoading = false;
  String? aToken;
  String? uId;

  @override
  Widget build(BuildContext context) {
    return Consumer2<PhoneProvider, AuthProvider>(
      builder: (context, pValue, aValue, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              phoneNumberTextAndImageSection(),
              const SizedBox(
                height: 30,
              ),
              NumberTextFiled(pValue),
              const Spacer(),
              SendButton(pValue, context),
              const SizedBox(
                height: 30,
              ),
              Text(
                "MEDICEAPP will verify ",
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
              Text(
                "your phone number ",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

  SizedBox SendButton(PhoneProvider pValue, BuildContext context) {
    return SizedBox(
      height: 40,
      width: 150,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () async {
            if (pValue.phone.length > 12 && pValue.phone.length < 14) {
              appSignature = await SmsAutoFill().getAppSignature;
              setState(() async {
                pValue.isValid(true);
                isLoading = true;
                isOver = false;
                //String? token = await FirebaseMessaging.instance.getToken();
                print('Fcm');
                //print(token);
                FirebaseMessaging.instance.getToken().then(
                  (value) {
                    print(value);
                    ApiService()
                        .registerUser(pValue.countryCode, _phone, pValue.type,
                            pValue.a_id, appSignature.toString(), value!)
                        .then((value) async {
                      print("_________________");
                      print(value.body);
                      var jsonVal = jsonDecode(value.body);
                      print("json val===$jsonVal");
                      if (jsonVal['status'] == false) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Message"),
                            content: Text(jsonVal['message']),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  color: Colors.blue,
                                  padding: const EdgeInsets.all(15),
                                  child: const Text(
                                    "okay",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OtpSection(
                                  otp: jsonVal['data']['otp'],
                                  phoneNum: _phone,
                                )));
                      }
                      String otp = jsonVal['data']['otp'];
                      print("___________________");
                      print(otp);
                      print("___________________");
                      var aProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      aProvider.getDetails(
                          jsonVal['data']['user_id'].toString(),
                          jsonVal['data']['otp'].toString(),
                          jsonVal['data']['access_token'].toString());
                      aToken = jsonVal['data']['access_token'].toString();
                      uId = jsonVal['data']['user_id'].toString();
                      print("token and id");
                      print(aToken);
                      print(uId);
                      SmsAutoFill().listenForCode;
                    });
                  },
                );
              });
            }
          },
          child: Text(
            "SEND",
            style: TextStyle(color: Colors.grey[600]),
          )),
    );
  }

  Row NumberTextFiled(PhoneProvider pValue) {
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          width: 350,
          child: IntlPhoneField(
              controller: phoneController,
              style: const TextStyle(color: Colors.black),
              dropdownTextStyle: const TextStyle(color: Colors.black),
              dropdownIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              initialCountryCode: 'IN',
              onChanged: (phone) async {
                if (phone.number.length == 10) {
                  FocusManager.instance.primaryFocus!.unfocus();
                }
                print(phone.completeNumber);
                _phone = phone.number;
                print(phone.countryCode.substring(1));
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("phoneNum", _phone);
                print(phone.number);
                print(phoneController.text);
                if (Device.get().isAndroid) {
                  pValue.phoneNumber(
                    phone.completeNumber,
                    phone.countryCode.substring(1),
                    'ANDROID',
                  );
                } else {
                  pValue.phoneNumber(
                    phone.completeNumber,
                    phone.countryCode.substring(1),
                    'IOS',
                  );
                }
              }),
        ),
        const Spacer(),
      ],
    );
  }

  Row phoneNumberTextAndImageSection() {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: 40,
          child: Image.asset(
            elems,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        const Text(
          "Enter your Phone number",
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const Spacer()
      ],
    );
  }
}

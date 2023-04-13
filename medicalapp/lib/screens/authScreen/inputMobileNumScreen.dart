import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:medicalapp/utility/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../providers/auth_provider.dart';
import '../../providers/phone_provider.dart';
import '../../service/api_services.dart';
import '../../utility/colors.dart';
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
      builder: (context, p_value, a_value, child) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              phoneNumberTextAndImageSection(),
              SizedBox(
                height: 30,
              ),
              NumberTextFiled(p_value),
              Spacer(),
              SendButton(p_value, context),
              SizedBox(
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
              SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

  SizedBox SendButton(PhoneProvider p_value, BuildContext context) {
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
            if (p_value.phone.length > 12 && p_value.phone.length < 14) {
              appSignature = await SmsAutoFill().getAppSignature;
              setState(() {
                p_value.isValid(true);
                isLoading = true;
                isOver = false;
                ApiService()
                    .registerUser(p_value.countryCode, _phone, p_value.type,
                        p_value.a_id, appSignature.toString())
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
                              padding: EdgeInsets.all(15),
                              child: Text(
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
                  var a_provider =
                      Provider.of<AuthProvider>(context, listen: false);
                  a_provider.getDetails(
                      jsonVal['data']['user_id'].toString(),
                      jsonVal['data']['otp'].toString(),
                      jsonVal['data']['access_token'].toString());
                  aToken = jsonVal['data']['access_token'].toString();
                  uId = jsonVal['data']['user_id'].toString();
                  print("token and id");
                  print(aToken);
                  print(uId);
                  await SmsAutoFill().listenForCode;
                });
              });
            }
          },
          child: Text(
            "SEND",
            style: TextStyle(color: Colors.grey[600]),
          )),
    );
  }

  Row NumberTextFiled(PhoneProvider p_value) {
    return Row(
      children: [
        Spacer(),
        SizedBox(
          width: 350,
          child: IntlPhoneField(
              controller: phoneController,
              style: TextStyle(color: Colors.black),
              dropdownTextStyle: TextStyle(color: Colors.black),
              dropdownIcon: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
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
                  p_value.phoneNumber(
                    phone.completeNumber,
                    phone.countryCode.substring(1),
                    'ANDROID',
                  );
                } else {
                  p_value.phoneNumber(
                    phone.completeNumber,
                    phone.countryCode.substring(1),
                    'IOS',
                  );
                }
              }),
        ),
        Spacer(),
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
        Spacer(),
        Text(
          "Enter your Phone number",
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Spacer()
      ],
    );
  }
}

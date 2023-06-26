import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/auth_provider.dart';
import '../providers/patientNewuserProdileVerifyData.dart';
import '../providers/patient_provider.dart';
import '../providers/petientdetailsGetProvider.dart';
import '../providers/phone_provider.dart';
import '../providers/reportdataVerify.dart';
import '../providers/verifiProfileEdit.dart';
import '../providers/verifiyaddFamilyMembersData.dart';

//App Config

String appName = "FSS Medical App";
double appNameSize = 38.0;
double subTextSize = 19.0;
FontWeight appNameWeight = FontWeight.bold;
FontWeight subTextWeight = FontWeight.w500;

//API Config
// String baseUrl = "https://finsmartstation.com/medicalApp/medical_app/";
// String baseUrl = "https://18f1-202-88-237-221.in.ngrok.io/medical_app/";
String baseUrl = "https://creativeapplab.in/med_app/medical_app/";

// Assets

String appLogo = 'assets/images/logo.png';
String hospital_icon = 'assets/images/hospital_icon.png';
String doctor = 'assets/images/doctor.png';
String pharmacy = 'assets/images/drugstore.png';
String hospital = 'assets/images/hospital.png';
String lab = 'assets/images/laboratory.png';
String patient = 'assets/images/patient.png';
String bg_top_gs = 'assets/images/FIRST PAGE DESIGN 01.png';
String profile_top_gs = 'assets/images/profile_top.png';
String profile_top_gs_Croped = 'assets/images/SECOND PAGE TOP with logo.png';
String bg_bottom_gs = 'assets/images/gs_bottom.png';
String profile_bottom_gs = 'assets/images/profile_bottom.png';
String elems = 'assets/images/plus_elems.png';
String locs = 'assets/images/location_pin.png';
String assistant = 'assets/images/assistant.png';
String lab_technician = 'assets/images/lab_technician.png';
String success = 'assets/images/success.png';
String folder = 'assets/images/folder_bg.png';
Color backgroundColor = const Color(0xFFE6E6E6);
List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => PhoneProvider()),
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => VerifyProfileEditData()),
  ChangeNotifierProvider(create: (_) => PatientDetailsProvider()),
  ChangeNotifierProvider(create: (_) => ReportDataVerify()),
  ChangeNotifierProvider(create: (_) => GetpetientDetails()),
  ChangeNotifierProvider(create: (_) => VerifyNewUserProfileData()),
  ChangeNotifierProvider(create: (_) => VerifyAddFamilyMembersData()),
];

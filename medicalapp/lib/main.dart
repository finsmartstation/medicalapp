import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicalapp/providers/auth_provider.dart';
import 'package:medicalapp/providers/patientNewuserProdileVerifyData.dart';
import 'package:medicalapp/providers/patient_provider.dart';
import 'package:medicalapp/providers/petientdetailsGetProvider.dart';
import 'package:medicalapp/providers/phone_provider.dart';
import 'package:medicalapp/providers/reportdataVerify.dart';
import 'package:medicalapp/providers/verifiProfileEdit.dart';
import 'package:medicalapp/providers/verifiyaddFamilyMembersData.dart';
import 'package:medicalapp/screens/appointment/videoCall.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:medicalapp/screens/splashScreen/splash_screen.dart';
import 'package:medicalapp/utility/constants.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => PhoneProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => VerifyProfileEditData()),
            ChangeNotifierProvider(create: (_) => PatientDetailsProvider()),
            ChangeNotifierProvider(create: (_) => ReportDataVerify()),
            ChangeNotifierProvider(create: (_) => GetpetientDetails()),
            ChangeNotifierProvider(create: (_) => VerifyNewUserProfileData()),
            ChangeNotifierProvider(create: (_) => VerifyAddFamilyMembersData()),
          ],
          child: const MyApp(),
        ),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: const SplashScreen());
  }
}

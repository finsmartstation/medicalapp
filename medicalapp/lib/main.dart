import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:medicalapp/screens/splashScreen/splash_screen.dart';
import 'package:medicalapp/utility/constants.dart';
import 'package:provider/provider.dart';

import 'screens/mapScreen/mapView.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.notification?.body}");
}

Future<void> main() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'downloaded_pdf',
          channelName: 'Downloaded PDFs',
          channelDescription: 'PDFs downloaded from the app',
          defaultColor: Colors.tealAccent,
          ledColor: Colors.tealAccent,
          playSound: true,
          enableVibration: true),
    ],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(
        MultiProvider(
          providers: providers,
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
        home: const MapView());
  }
}

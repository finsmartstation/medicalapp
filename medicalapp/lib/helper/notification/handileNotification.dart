import 'dart:developer';

//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicalapp/helper/helper.dart';
import '../../utility/constants.dart';

class Notifications {
  Future<void> interactedNotificationMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessage.listen(_handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        log(event.data.toString());
      },
    );
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'alert') {
      debugPrint(message.data.toString());
      showTextNotification(
        body: message.data['message'],
        title: 'alert',
        id: Helpers.convertIntoInt(message.data['appoinment_id']),
        fln: flutterLocalNotificationsPlugin,
        payload: 'custom_data',
      );
    }
  }

  static Future showTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatforms = AndroidNotificationDetails(
      'alert',
      'channel_name',
      playSound: true,

      //sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.max,
      autoCancel: false,
      visibility: NotificationVisibility.public
    );
    var not = NotificationDetails(
        android: androidPlatforms, iOS: DarwinNotificationDetails());
    await fln.show(0, title, body, not);
  }
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  final String? id = notificationResponse.notificationResponseType.toString();
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
    debugPrint('notification Id: $id');
  }
}


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.notification?.body}");
}

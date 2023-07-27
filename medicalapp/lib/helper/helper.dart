import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static String formatTime(String dateTimeString) {
    DateTime parsedTime = DateFormat('HH:mm:ss').parse(dateTimeString);
    String formattedTime = DateFormat('h:mm a').format(parsedTime);
    return formattedTime;
  }

  static double convertIntoDouble(String stringdouble) {
    return double.parse(stringdouble);
  }

  static int convertIntoInt(String stringdouble) {
    return int.parse(stringdouble);
  }

  static navigateTo(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  static showAnimatedScaffoldMessenger(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final animationDuration = Duration(seconds: 1);

    final animationController = AnimationController(
      duration: animationDuration,
      vsync: scaffoldMessenger,
    );

    final animation = Tween<Offset>(
      begin: Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    animationController.forward();
    final snackBar = SnackBar(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5,
      ))),
      backgroundColor: Colors.blue,
      behavior: SnackBarBehavior.floating,
      content: SlideTransition(
        position: animation,
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(snackBar);

    Future.delayed(animationDuration + Duration(seconds: 3), () {
      animationController.reverse();
    });
  }
}

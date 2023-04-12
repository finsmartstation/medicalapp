import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/phone_provider.dart';
import '../../utility/constants.dart';
import '../authScreen/auth_screen.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final phoneProv = Provider.of<PhoneProvider>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    child: Image.asset(bg_top_gs, fit: BoxFit.fill)),
                Positioned(
                  top: 135,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "WELCOME",
                        style: TextStyle(
                            fontSize: 52,
                            color: Colors.white70,
                            fontFamily: 'gotham'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(child: Image.asset(appLogo)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.4),
              child: SizedBox(
                width: 80,
                child: Image.asset(elems),
              ),
            ),
            Spacer(),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  phoneProv.getAcessId("3", "Patient");
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AuthScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  "GET STARTED",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Text(
                  textAlign: TextAlign.center,
                  'Read our Privacy Policy. Tap "Get Started" to \naccept the Terms of services.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

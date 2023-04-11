import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/dashboardScreen.dart';
import 'appointmentApiServices.dart';

class PaymentScreen extends StatefulWidget {
  String? family_member_id;
  String? doctorId;
  String? consultingfee;
  String? drName;
  String? drSpl;
  String? organization;
  String? book_slot_id;
  String? sick_notes;
  String? visit_typeId;
  String? visit_type;
  String? bookingDate;
  String? bookingTime;
  PaymentScreen(
      {Key? key,
      required this.visit_type,
      required this.family_member_id,
      required this.doctorId,
      required this.consultingfee,
      required this.drName,
      required this.drSpl,
      required this.organization,
      required this.book_slot_id,
      required this.bookingDate,
      required this.bookingTime,
      required this.sick_notes,
      required this.visit_typeId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? access_token;
  String? user_id;

  getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      access_token = prefs.getString('access_token');
      user_id = prefs.getString('user_id');
    });
  }

  @override
  void initState() {
    getProfileData();
    print(access_token);
    print(user_id);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          "Payment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(25)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(),
                    Text(
                      "Total Payment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "₹" + widget.consultingfee.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(),
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Payment Details",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 3,
                        spreadRadius: 3)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Dr " + widget.drName.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      widget.drSpl.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Organization: " + widget.organization.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "consulting Fees: " + widget.consultingfee.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Date : " +
                          widget.bookingDate.toString() +
                          "  Time : " +
                          widget.bookingTime.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Visit Type : " + widget.visit_type.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: (() {
                      slot_booking(
                              user_id,
                              access_token,
                              widget.doctorId,
                              widget.family_member_id,
                              widget.book_slot_id,
                              widget.sick_notes,
                              widget.visit_typeId)
                          .then((value) {
                        if (value.statusCode == 200) {
                          showSuccessDialog(
                              context,
                              "Slot booked successfully",
                              DashboardPatient(
                                family_member_id:
                                    widget.family_member_id.toString(),
                              ),
                              "Success");

                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text(
                          //     "Slot booked",
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          //   backgroundColor: Colors.blue[800],
                          //   elevation: 10,
                          // ));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => DashboardPatient(
                          //               family_member_id:
                          //                   widget.family_member_id.toString(),
                          //             )));
                          print(value.body);
                        }
                      });
                    }),
                    child: Text("Pay Now")),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showSuccessDialog(BuildContext context, String message,
    Widget navigationRoute, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        content: Text(message),
      );
    },
  );
  Future.delayed(Duration(seconds: 1), () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => navigationRoute),
    );
  });
}

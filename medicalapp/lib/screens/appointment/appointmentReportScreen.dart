import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/screens/appointment/doctor_details.dart';
import 'package:medicalapp/screens/appointment/videoCall.dart';
import 'package:medicalapp/screens/doctorList/doctorProfileDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appointmentApiServices.dart';
import 'appointmentResultPdf.dart';
import 'audioCall.dart';

class AppointmentReport extends StatefulWidget {
  String? userName;
  String? slot_id;
  String? familyMemberId;
  AppointmentReport({Key? key, required this.slot_id, required this.userName, required this.familyMemberId})
      : super(key: key);

  @override
  State<AppointmentReport> createState() => _AppointmentReportState();
}

class _AppointmentReportState extends State<AppointmentReport> {
  String? access_token;
  String? user_id;
  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      access_token = prefs.getString('access_token');
      user_id = prefs.getString('user_id');
      print("userid==$user_id");
      print("accessToken==$access_token");
    });
  }

  @override
  void initState() {
    print(widget.slot_id);
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            patient_appoinment_details(user_id, access_token, widget.slot_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      )),
                  title: const Text(
                    "Appointment Details",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    IconButton(
                        onPressed: (() {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Complete Appointment for Start Chat"),
                          ));
                        }),
                        icon: const Icon(
                          Icons.chat_rounded,
                          color: Colors.black,
                        ))
                  ],
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            color: Colors.white,
                            child: Image(
                                image:
                                    NetworkImage(snapshot.data!.data.stickers)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Date of Appointment: ${DateFormat("yyyy/MM/dd").format(snapshot.data!.data.bookedFor)}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Time of Appointment: ${DateFormat("h:mm a").format(snapshot.data!.data.bookedFor)}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Card(
                            elevation: 5,
                            shadowColor: Colors.white,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name of Doctor: ${snapshot.data!.data.doctorName}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Organization: ${snapshot.data!.data.organisationName}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Organization address: ${snapshot.data!.data.organisationAddress}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Organization Mobile Number: ${snapshot.data!.data.organisationMobile}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Organization Email: ${snapshot.data!.data.organisationEmail}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Booked Date: ${DateFormat("yyyy/MM/dd").format(snapshot.data!.data.bookedDatetime)}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      snapshot.data!.data.visitType == "0"
                                          ? "Visit Type: Offline"
                                          : "Visit Type: Online",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Appointment Status: ${snapshot.data!.data.consultingMessage}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    snapshot.data!.data.sickNotes==''?
                                    SizedBox()
                                    :Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          //height: 200,
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                Text(
                                                  snapshot.data!.data.sickNotes,
                                                  maxLines: 15,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 50,
                                          top: 0,
                                          child: Container(
                                            color: Colors.white,
                                            child: const Text(
                                              'Sick Note',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          snapshot.data!.data.consultingStatus == "1"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                          "Follow Up Date: ${DateFormat("yyyy/MM/dd").format(snapshot.data!.data.bookedDatetime)}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      snapshot.data!.data.refferedDoctor.toString()=='0'?
                                      SizedBox()
                                      :InkWell(
                                        onTap:(){ 
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                          DoctorProfileDetails(family_member_id: widget.familyMemberId, doctorId: snapshot.data!.data.refferedDoctor)));
                                        },
                                        child: Text(
                                            "Referred Doctor: ${snapshot.data!.data.refferedDoctorName}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      snapshot.data!.data.refferedLab.toString()=='0'?
                                      SizedBox()
                                      :InkWell(
                                        onTap: () {
                                          
                                        },
                                        child: Text(
                                            "Referred Lab: ${snapshot.data!.data.refferedLabName}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ])
                              :snapshot.data!.data.consultingMessage.toLowerCase()=='expired'?
                               Center(
                                  child: Text(
                                    'Expired',
                                 // snapshot.data!.data.consultingMessage,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                              : const Center(
                                  child: Text(
                                  "Waiting for Consulting...",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                        ]),
                  ),
                ),
                floatingActionButton: snapshot.data!.data.call_status == "5"
                    ? const SizedBox()
                    : snapshot.data!.data.call_status == "1 "
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 120,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue.shade700,
                                  onPressed: () {
                                    setState(() {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => AppointmentPdf(
                                      //               filePath: snapshot
                                      //                   .data!.data.reportPath
                                      //                   .toString(),
                                      //             )));
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => AudioCall(
                                      //               roomID: snapshot
                                      //                   .data!.data.slotId,
                                      //               userName: widget.userName
                                      //                   .toString(),
                                      //             )));
                                    });
                                  },
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0))),
                                  child: Row(children: const [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.call),
                                    Text(
                                      "Audio Call",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 120,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue.shade700,
                                  onPressed: () {
                                    setState(() {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => AppointmentPdf(
                                      //               filePath: snapshot
                                      //                   .data!.data.reportPath
                                      //                   .toString(),
                                      //             )));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoConferencePage(
                                                    conferenceID: snapshot
                                                        .data!.data.slotId,
                                                    user_name: widget.userName
                                                        .toString(),
                                                    userId: user_id.toString(),
                                                  )));
                                    });
                                  },
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0))),
                                  child: Row(children: const [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.video_call),
                                    Text(
                                      "Video Call",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            snapshot.data!.data.reportPath.toString()==''?
                            SizedBox()
                            :SizedBox(
                                width: 150,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue.shade700,
                                  onPressed: () {
                                    setState(() {
                                      if(snapshot.data!.data.reportPath.toString()==''){
                                         showDialog(context: context,
                                                     builder: (BuildContext context){
                                                      return AlertDialog(
                                                        title: const Text('Report not available'),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed:(){
                                                              Navigator.pop(context);
                                                            }, 
                                                            child: const Text('Ok'))
                                                        ],
                                                      );
                                                     });
                                      }
                                      else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AppointmentPdf(
                                                    filePath: snapshot
                                                        .data!.data.reportPath
                                                        .toString(),
                                                  )));
                                      }
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => VideoConferencePage(
                                      //               conferenceID: "123",
                                      //               user_name: "rishad",
                                      //               userId: user_id.toString(),
                                      //             )));
                                    });
                                  },
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16.0))),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                    // SizedBox(
                                    //   width: 8,
                                    // ),
                                    // Icon(Icons.download),
                                    Text(
                                      "Report",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                               snapshot.data!.data.prescription.toString()==''?
                            SizedBox()
                            :SizedBox(
                                width: 150,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue.shade700,
                                  onPressed: () {
                                    setState(() {
                                      if(snapshot.data!.data.prescription.toString()==''){
                                         showDialog(context: context,
                                                     builder: (BuildContext context){
                                                      return AlertDialog(
                                                        title: const Text('Prescription not available'),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed:(){
                                                              Navigator.pop(context);
                                                            }, 
                                                            child: const Text('Ok'))
                                                        ],
                                                      );
                                                     });
                                      }
                                      else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AppointmentPdf(
                                                    filePath: snapshot
                                                        .data!.data.prescription
                                                        .toString(),
                                                  )));
                                      }
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => VideoConferencePage(
                                      //               conferenceID: "123",
                                      //               user_name: "rishad",
                                      //               userId: user_id.toString(),
                                      //             )));
                                    });
                                  },
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16.0))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: const [
                                    // SizedBox(
                                    //   width: 8,
                                    // ),
                                   // Icon(Icons.download),
                                    Text(
                                      "Prescription",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                ),
                              ),
                          ],
                        ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

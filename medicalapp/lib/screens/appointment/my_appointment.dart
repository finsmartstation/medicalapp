import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UserProfile/NewUserProfile.dart';
import '../doctorList/doctorProfileDetails.dart';
import '../doctorList/doctor_list.dart';
import 'appointmentApiServices.dart';
import 'appointmentReportScreen.dart';

class MyAppointment extends StatefulWidget {
  String? family_member_id;
  String? userName;
  MyAppointment(
      {Key? key, required this.family_member_id, required this.userName})
      : super(key: key);

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Complete Your profile'),
          content: const Text('Please complete your profile to get access'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewUserProfile()));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String? access_token;
  String? user_id;
  String filterButtonIndex = "0";
  getUserData() async {
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
    setState(() {
      getUserData();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          onPressed: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DoctorList(
                          family_member_id: widget.family_member_id,
                        )));
          }),
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: const Text(
            "My Appointment",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: patientBookSlotHistory(
                      user_id, access_token, widget.family_member_id),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.previousData.isEmpty &&
                              snapshot.data!.upcommingData.isEmpty
                          ? const Center(
                              child: Text(
                                "No appointments",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            )
                          : snapshot.data!.previousData.isNotEmpty &&
                                  snapshot.data!.upcommingData.isNotEmpty
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 150,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        filterButtonIndex == "0"
                                                            ? Colors.blue
                                                            : Colors.white),
                                                onPressed: (() {
                                                  setState(() {
                                                    filterButtonIndex = "0";
                                                  });
                                                }),
                                                child: const Text(
                                                  "Upcoming",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 60,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: 150,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        filterButtonIndex == "1"
                                                            ? Colors
                                                                .blue.shade700
                                                            : Colors.white),
                                                onPressed: (() {
                                                  setState(() {
                                                    filterButtonIndex = "1";
                                                  });
                                                }),
                                                child: const Text(
                                                  "Previous",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          )
                                        ],
                                      ),
                                      filterButtonIndex == "0"
                                          ? Expanded(
                                              child: ListView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount: snapshot.data!
                                                      .upcommingData.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AppointmentReport(
                                                                            slot_id:
                                                                                snapshot.data!.upcommingData[index].id,
                                                                            userName:
                                                                                widget.userName,
                                                                          )));
                                                        },
                                                        child: Card(
                                                            elevation: 8,
                                                            shadowColor:
                                                                Colors.blue,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Column(
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => DoctorProfileDetails(
                                                                                            doctorId: snapshot.data!.upcommingData[index].doctorId,
                                                                                            family_member_id: widget.family_member_id.toString(),
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "Dr.${snapshot.data!.upcommingData[index].doctorName}",
                                                                              style: const TextStyle(fontSize: 20),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Text(
                                                                            "Status: ${snapshot.data!.upcommingData[index].consultingMessage}",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.w700),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            350,
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data!
                                                                              .upcommingData[index]
                                                                              .sickNotes,
                                                                          maxLines:
                                                                              5,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .calendar_month,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      Text(
                                                                        DateFormat('dd/MM/yyyy hh:mm a').format(snapshot
                                                                            .data!
                                                                            .upcommingData[index]
                                                                            .bookedFor),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(snapshot.data!.upcommingData[index].visitType ==
                                                                              "0"
                                                                          ? "Visit type: Offline"
                                                                          : "Visit type: Online")
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                    );
                                                  }),
                                            )
                                          : Expanded(
                                              child: ListView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount: snapshot.data!
                                                      .previousData.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AppointmentReport(
                                                                            slot_id:
                                                                                snapshot.data!.previousData[index].id,
                                                                            userName:
                                                                                widget.userName,
                                                                          )));
                                                        },
                                                        child: Card(
                                                            elevation: 8,
                                                            shadowColor:
                                                                Colors.blue,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Column(
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => DoctorProfileDetails(
                                                                                            doctorId: snapshot.data!.previousData[index].doctorId,
                                                                                            family_member_id: widget.family_member_id.toString(),
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "Dr.${snapshot.data!.previousData[index].doctorName}",
                                                                              style: const TextStyle(fontSize: 20),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Text(
                                                                            "Status: ${snapshot.data!.previousData[index].consultingMessage}",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.w700),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            350,
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data!
                                                                              .previousData[index]
                                                                              .sickNotes,
                                                                          maxLines:
                                                                              5,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .calendar_month,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      Text(
                                                                        DateFormat('dd/MM/yyyy hh:mm a').format(snapshot
                                                                            .data!
                                                                            .previousData[index]
                                                                            .bookedFor),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                      const Spacer(),
                                                                      Text(snapshot.data!.previousData[index].visitType ==
                                                                              "0"
                                                                          ? "Visit type: Offline"
                                                                          : "Visit type: Online")
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                    ],
                                  ),
                                )
                              : snapshot.data!.previousData.isEmpty &&
                                      snapshot.data!.upcommingData.isNotEmpty
                                  ? Expanded(
                                      child: Column(children: [
                                      SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            onPressed: (() {}),
                                            child: const Text(
                                              "Upcoming",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: snapshot
                                                .data!.upcommingData.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AppointmentReport(
                                                                slot_id: snapshot
                                                                    .data!
                                                                    .upcommingData[
                                                                        index]
                                                                    .id,
                                                                userName: widget
                                                                    .userName,
                                                              )));
                                                },
                                                child: Card(
                                                    elevation: 8,
                                                    shadowColor: Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => DoctorProfileDetails(
                                                                                    doctorId: snapshot.data!.upcommingData[index].doctorId,
                                                                                    family_member_id: widget.family_member_id.toString(),
                                                                                  )));
                                                                    },
                                                                    child: Text(
                                                                      "Dr.${snapshot.data!.upcommingData[index].doctorName}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    "Status: ${snapshot.data!.upcommingData[index].consultingMessage}",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                width: 350,
                                                                child: Text(
                                                                  snapshot
                                                                      .data!
                                                                      .upcommingData[
                                                                          index]
                                                                      .sickNotes,
                                                                  maxLines: 5,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(
                                                            color: Colors.grey,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .calendar_month,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                        'dd/MM/yyyy hh:mm a')
                                                                    .format(snapshot
                                                                        .data!
                                                                        .upcommingData[
                                                                            index]
                                                                        .bookedFor),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              const Spacer(),
                                                              Text(snapshot
                                                                          .data!
                                                                          .upcommingData[
                                                                              index]
                                                                          .visitType ==
                                                                      "0"
                                                                  ? "Visit type: Offline"
                                                                  : "Visit type: Online")
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              );
                                            }),
                                      )
                                    ]))
                                  : Expanded(
                                      child: Column(children: [
                                      SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            onPressed: (() {}),
                                            child: const Text(
                                              "Previous",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: snapshot
                                                .data!.previousData.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AppointmentReport(
                                                                slot_id: snapshot
                                                                    .data!
                                                                    .previousData[
                                                                        index]
                                                                    .id,
                                                                userName: widget
                                                                    .userName,
                                                              )));
                                                },
                                                child: Card(
                                                    elevation: 8,
                                                    shadowColor: Colors.blue,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => DoctorProfileDetails(
                                                                                    doctorId: snapshot.data!.previousData[index].doctorId,
                                                                                    family_member_id: widget.family_member_id.toString(),
                                                                                  )));
                                                                    },
                                                                    child: Text(
                                                                      "Dr.${snapshot.data!.previousData[index].doctorName}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    "Status: ${snapshot.data!.previousData[index].consultingMessage}",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                width: 350,
                                                                child: Text(
                                                                  snapshot
                                                                      .data!
                                                                      .previousData[
                                                                          index]
                                                                      .sickNotes,
                                                                  maxLines: 5,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(
                                                            color: Colors.grey,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .calendar_month,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                        'dd/MM/yyyy hh:mm a')
                                                                    .format(snapshot
                                                                        .data!
                                                                        .previousData[
                                                                            index]
                                                                        .bookedFor),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              const Spacer(),
                                                              Text(snapshot
                                                                          .data!
                                                                          .previousData[
                                                                              index]
                                                                          .visitType ==
                                                                      "0"
                                                                  ? "Visit type: Offline"
                                                                  : "Visit type: Online")
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              );
                                            }),
                                      )
                                    ]));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))
            ],
          ),
        ));
  }
}

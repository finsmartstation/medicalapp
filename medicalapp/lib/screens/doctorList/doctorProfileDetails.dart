import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../appointment/bookingAppoiment.dart';
import 'doctorListApiServices.dart';

class DoctorProfileDetails extends StatefulWidget {
  String? family_member_id;
  String? doctorId;
  DoctorProfileDetails(
      {super.key, required this.family_member_id, required this.doctorId});

  @override
  State<DoctorProfileDetails> createState() => _DoctorProfileDetailsState();
}

class _DoctorProfileDetailsState extends State<DoctorProfileDetails> {
  @override
  Widget build(BuildContext context) {
    AuthProvider auth({required bool renderUI}) =>
        Provider.of<AuthProvider>(context, listen: renderUI);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, "refresh");
        return Future.value(false);
      },
      child: FutureBuilder(
        future: doctor_profile_details(
            auth(renderUI: false).u_id,
            auth(renderUI: false).access_token,
            widget.doctorId,
            widget.family_member_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.data.slotAvailableStatus);
            return Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.1,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            image: DecorationImage(
                                image: NetworkImage(
                                    snapshot.data!.data.profilePic),
                                fit: BoxFit.cover),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0C84FF).withOpacity(0.9),
                                  const Color(0xFF0C84FF).withOpacity(0),
                                  const Color(0xFF0C84FF).withOpacity(0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30, left: 10, right: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 45,
                                        width: 45,
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context, "refresh");
                                            },
                                            icon: const Icon(
                                                Icons.arrow_back_ios),
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 45,
                                        width: 45,
                                        child: Center(
                                          child: snapshot.data!.data
                                                      .favouriteDoctorStatus ==
                                                  "1"
                                              ? IconButton(
                                                  onPressed: () {
                                                    print(snapshot.data!.data
                                                        .favouriteDoctorStatus);

                                                    setState(() {
                                                      removeFavoriteDoctor(
                                                              auth(
                                                                      renderUI:
                                                                          false)
                                                                  .u_id,
                                                              auth(
                                                                      renderUI:
                                                                          false)
                                                                  .access_token,
                                                              widget
                                                                  .family_member_id,
                                                              widget.doctorId)
                                                          .then((value) {
                                                        if (value.statusCode ==
                                                            200) {
                                                          var jsonData =
                                                              jsonDecode(
                                                                  value.body);
                                                          setState(() {
                                                            print(jsonData);
                                                          });
                                                        }
                                                      });
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 25,
                                                  ))
                                              : IconButton(
                                                  onPressed: () {
                                                    print(snapshot.data!.data
                                                        .favouriteDoctorStatus);

                                                    setState(() {
                                                      addFavoriteDoctor(
                                                              auth(
                                                                      renderUI:
                                                                          false)
                                                                  .u_id,
                                                              auth(
                                                                      renderUI:
                                                                          false)
                                                                  .access_token,
                                                              widget
                                                                  .family_member_id,
                                                              widget.doctorId)
                                                          .then((value) {
                                                        if (value.statusCode ==
                                                            200) {
                                                          var jsonData =
                                                              jsonDecode(
                                                                  value.body);
                                                          setState(() {
                                                            print(jsonData);
                                                          });
                                                        }
                                                      });
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.favorite,
                                                      color: Colors.grey,
                                                      size: 25)),
                                        ),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Patients",
                                          style: TextStyle(
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          snapshot.data!.data.patientCount,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Experience",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "${snapshot.data!.data.experience}yr",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Rating",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          snapshot.data!.data.rating.toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.data.doctorName,
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Designation:${snapshot.data!.data.designation}",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.blue.shade500),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.heart_broken_outlined,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Text(
                                    snapshot.data!.data.specialization,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.blue.shade500),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Consulting Fee: ${snapshot.data!.data.consultingFee}",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.blue.shade500),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Organization:${snapshot.data!.data.organisation}",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.blue.shade500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Stack(
                  children: [
                    snapshot.data!.data.familyDoctorStatus == "0"
                        ? Positioned(
                            bottom: 00,
                            right: 00,
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                addFamilyDoctor(
                                        auth(renderUI: false).u_id,
                                        auth(renderUI: false).access_token,
                                        widget.doctorId)
                                    .then((value) {
                                  if (value.statusCode == 200) {
                                    setState(() {
                                      print(value.body);
                                    });
                                  }
                                });
                              },
                              label: const Text('Add as Family Doctor'),
                              icon: const Icon(
                                Icons.family_restroom,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Positioned(
                            bottom: 00,
                            right: 00,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.red,
                              onPressed: () {
                                delete_family_doctor(auth(renderUI: false).u_id,
                                        auth(renderUI: false).access_token)
                                    .then((value) {
                                  if (value.statusCode == 200) {
                                    setState(() {
                                      print(value.body);
                                    });
                                  }
                                });
                              },
                              label: const Text('Remove Family Doctor'),
                              icon: const Icon(Icons.family_restroom),
                            ),
                          ),
                    Positioned(
                        bottom: 60,
                        right: 0,
                        child: snapshot.data!.data.slotAvailableStatus == "true"
                            ? FloatingActionButton.extended(
                                heroTag: "tag1",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BookingAppoiment(
                                                doctorId: widget.doctorId,
                                                family_member_id:
                                                    widget.family_member_id,
                                                consultingfee: snapshot
                                                    .data!.data.consultingFee,
                                                drName: snapshot
                                                    .data!.data.doctorName,
                                                drSpl: snapshot
                                                    .data!.data.specialization,
                                                organization: snapshot
                                                    .data!.data.organisation,
                                              )));
                                },
                                label: const Text('Book appointment'),
                              )
                            : FloatingActionButton.extended(
                                heroTag: "tag2",
                                onPressed: () {},
                                label: const Text('Appointment Not Available'),
                              )),
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

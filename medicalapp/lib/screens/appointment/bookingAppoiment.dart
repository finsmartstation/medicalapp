import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/helper/helper.dart';
import 'package:medicalapp/screens/appointment/paymentPage.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'appointmentApiServices.dart';

class BookingAppoiment extends StatefulWidget {
  String? family_member_id;
  String? doctorId;
  String? consultingfee;
  String? drName;
  String? drSpl;
  String? organization;
  BookingAppoiment({
    super.key,
    required this.family_member_id,
    required this.doctorId,
    required this.consultingfee,
    required this.drName,
    required this.drSpl,
    required this.organization,
  });

  @override
  State<BookingAppoiment> createState() => _BookingAppoimentState();
}

class _BookingAppoimentState extends State<BookingAppoiment> {
  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();
  int onlineOrOfflineButtonIndex = 1;
  int timeButtonIndex = 0;
  int selectDateButtonIndex = 0;
  String date_id = "";
  String visit_typeId = "";
  String onlineOrOffline = "1";
  String book_slot_id = "";
  String selectedDate = "";
  String bookingTime = "";
  String visit_type = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        noteFocusNode.unfocus();
      },
      child: FutureBuilder(
        future: doctor_available_slot_details(
            context.watch<AuthProvider>().u_id,
            context.watch<AuthProvider>().access_token,
            widget.doctorId,
            date_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (selectedDate == "") {
              selectedDate = DateFormat("dd/MM/yyyy")
                  .format(snapshot.data!.data.date[0].date);
              print(selectedDate);
            }

            if (snapshot.data!.data.slots[timeButtonIndex].appoinmentType ==
                "1") {
              visit_type = "Online";
              // bookingTime = DateFormat('hh:mm a')
              //     .format(snapshot.data!.data.slots[timeButtonIndex].slotTime);
              bookingTime = snapshot.data!.data.slots[timeButtonIndex].slotTime;
              book_slot_id =
                  snapshot.data!.data.slots[timeButtonIndex].id.toString();
              visit_typeId = snapshot
                  .data!.data.slots[timeButtonIndex].appoinmentType
                  .toString();
              print("___________________________");
              print(visit_typeId);
            } else if (snapshot
                    .data!.data.slots[timeButtonIndex].appoinmentType ==
                "0") {
              visit_type = "Offline";
              // bookingTime = DateFormat('hh:mm a')
              //     .format(snapshot.data!.data.slots[timeButtonIndex].slotTime);
              bookingTime = snapshot.data!.data.slots[timeButtonIndex].slotTime;
              book_slot_id =
                  snapshot.data!.data.slots[timeButtonIndex].id.toString();
              visit_typeId = snapshot
                  .data!.data.slots[timeButtonIndex].appoinmentType
                  .toString();
              print("___________________________");
              print(visit_typeId);
            } else if (snapshot
                    .data!.data.slots[timeButtonIndex].appoinmentType ==
                "2") {
              if (onlineOrOffline == "1") {
                visit_type = "Online";
                // bookingTime = DateFormat('hh:mm a').format(
                //     snapshot.data!.data.slots[timeButtonIndex].slotTime);
                bookingTime =
                    snapshot.data!.data.slots[timeButtonIndex].slotTime;
                book_slot_id =
                    snapshot.data!.data.slots[timeButtonIndex].id.toString();
                visit_typeId = "1";
              } else if (onlineOrOffline == "0") {
                visit_type = "Offline";
                // bookingTime = DateFormat('hh:mm a').format(
                //     snapshot.data!.data.slots[timeButtonIndex].slotTime);
                bookingTime =
                    snapshot.data!.data.slots[timeButtonIndex].slotTime;
                book_slot_id =
                    snapshot.data!.data.slots[timeButtonIndex].id.toString();
                visit_typeId = "0";
              }

              print("___________________________");
              print(visit_typeId);
            }

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.grey.shade300,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.grey.shade300,
                leading: IconButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                title: const Text(
                  "Booking Appointment",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18),
                      child: Text("Select Date",
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 170,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.data.date.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                if (index == index) {
                                  setState(() {
                                    date_id =
                                        snapshot.data!.data.date[index].dateId;
                                    selectDateButtonIndex = index;
                                    timeButtonIndex = 0;
                                    selectedDate = DateFormat("dd/MM/yyyy")
                                        .format(snapshot
                                            .data!.data.date[index].date);
                                  });
                                }
                              },
                              child: Container(
                                height: 170,
                                width: 150,
                                decoration: BoxDecoration(
                                    gradient: index == selectDateButtonIndex
                                        ? LinearGradient(colors: [
                                            Colors.blue,
                                            Colors.blue.shade700
                                          ])
                                        : const LinearGradient(colors: [
                                            Colors.white,
                                            Colors.white10
                                          ]),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      (snapshot.data!.data.date[index].date.day ==
                                                  DateTime.now().day &&
                                              snapshot.data!.data.date[index]
                                                      .date.month ==
                                                  DateTime.now().month &&
                                              snapshot.data!.data.date[index].date.year ==
                                                  DateTime.now().year)
                                          ? 'Today'
                                          : (snapshot.data!.data.date[index].date.day ==
                                                      DateTime.now()
                                                          .add(const Duration(
                                                              days: 1))
                                                          .day &&
                                                  snapshot
                                                          .data!
                                                          .data
                                                          .date[index]
                                                          .date
                                                          .month ==
                                                      DateTime.now()
                                                          .add(const Duration(
                                                              days: 1))
                                                          .month &&
                                                  snapshot
                                                          .data!
                                                          .data
                                                          .date[index]
                                                          .date
                                                          .year ==
                                                      DateTime.now()
                                                          .add(const Duration(days: 1))
                                                          .year)
                                              ? 'Tomorrow'
                                              : DateFormat.E().format(snapshot.data!.data.date[index].date),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: index == selectDateButtonIndex
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot
                                              .data!.data.date[index].date.day
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  index == selectDateButtonIndex
                                                      ? Colors.white
                                                      : Colors.black),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Text(
                                              getDayOfMonthSuffix(snapshot.data!
                                                  .data.date[index].date.day),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: index ==
                                                          selectDateButtonIndex
                                                      ? Colors.white
                                                      : Colors.black)),
                                        ),
                                        Text(
                                          " ${DateFormat.MMM().format(snapshot.data!.data.date[index].date)}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                index == selectDateButtonIndex
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                        snapshot.data!.data.date[index].count ==
                                                "1"
                                            ? "${snapshot.data!.data.date[index].count} slot Available"
                                            : "${snapshot.data!.data.date[index].count} slots Available",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                index == selectDateButtonIndex
                                                    ? Colors.white
                                                    : Colors.black))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 170,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GridView.builder(
                          itemCount: snapshot.data!.data.slots.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 30,
                          ),
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: index == timeButtonIndex
                                    ? Colors.blue.shade700
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (index == index) {
                                    timeButtonIndex = index;
                                    // visit_type = snapshot
                                    //     .data!.data.slots[index].appoinmentType
                                    //     .toString();
                                    // print(visit_type);
                                    log(snapshot
                                        .data!.data.slots[index].slotTime);

                                    log(timeButtonIndex.toString());
                                  }
                                });
                              },
                              child: Center(
                                  child: Text(
                                // DateFormat('hh:mm a').format(
                                //     snapshot.data!.data.slots[index].slotTime),
                                Helpers.formatTime(
                                  snapshot.data!.data.slots[index].slotTime,
                                ),

                                style: TextStyle(
                                    color: index == timeButtonIndex
                                        ? Colors.white
                                        : Colors.black),
                              )),
                            );
                          },
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Appointment Type",
                          style: TextStyle(color: Colors.black, fontSize: 20)),
                    ),
                    if (snapshot
                            .data!.data.slots[timeButtonIndex].appoinmentType ==
                        "1")
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Online",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    if (snapshot
                            .data!.data.slots[timeButtonIndex].appoinmentType ==
                        "0")
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Offline",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    if (snapshot
                            .data!.data.slots[timeButtonIndex].appoinmentType ==
                        "2")
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      onlineOrOfflineButtonIndex == 1
                                          ? Colors.blue.shade700
                                          : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    onlineOrOfflineButtonIndex = 1;
                                    onlineOrOffline = "1";
                                  });
                                },
                                child: Center(
                                    child: Text(
                                  "Online",
                                  style: TextStyle(
                                      color: onlineOrOfflineButtonIndex == 1
                                          ? Colors.white
                                          : Colors.black),
                                )),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      onlineOrOfflineButtonIndex == 2
                                          ? Colors.blue.shade700
                                          : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    onlineOrOfflineButtonIndex = 2;
                                    onlineOrOffline = "0";
                                    print(onlineOrOffline);
                                  });
                                },
                                child: Center(
                                    child: Text(
                                  "Offline",
                                  style: TextStyle(
                                      color: onlineOrOfflineButtonIndex == 2
                                          ? Colors.white
                                          : Colors.black),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 180,
                        width: 390,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: TextFormField(
                                controller: noteController,
                                focusNode: noteFocusNode,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'Type your message .....',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            const Text(
                              "Before meeting with doctor, you can write your problems so that it will be easier for doctor to understand before counsulting",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                        child: SizedBox(
                            height: 50,
                            width: 390,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                                onPressed: (() {
                                  print(visit_typeId);
                                  print(book_slot_id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaymentScreen(
                                                visit_type: visit_type,
                                                book_slot_id: book_slot_id,
                                                bookingDate: selectedDate,
                                                bookingTime: bookingTime,
                                                consultingfee:
                                                    widget.consultingfee,
                                                doctorId: widget.doctorId,
                                                drName: widget.drName,
                                                drSpl: widget.drSpl,
                                                family_member_id:
                                                    widget.family_member_id,
                                                organization:
                                                    widget.organization,
                                                sick_notes: noteController.text
                                                    .toString(),
                                                visit_typeId: visit_typeId,
                                              )));
                                }),
                                child: const Text("Set Appointment")))),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

String getDayOfMonthSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

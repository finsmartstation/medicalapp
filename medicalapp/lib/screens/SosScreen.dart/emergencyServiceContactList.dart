import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sosApiServices.dart';

class EmergencyServicesContact extends StatefulWidget {
  const EmergencyServicesContact({super.key});

  @override
  State<EmergencyServicesContact> createState() =>
      _EmergencyServicesContactState();
}

class _EmergencyServicesContactState extends State<EmergencyServicesContact> {
  TextEditingController nameController = TextEditingController();
  String number = "";
  TextEditingController relationController = TextEditingController();
  String user_id = "";
  String access_token = "";
  getSherPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id').toString();
      access_token = prefs.getString('access_token').toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSherPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          "Emergency Contact",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: list_emergency_contact(user_id, access_token),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  )),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 70),
                    snapshot.data!.data.length == 0
                        ? Center(
                            child: Text("Add Emergency Contact"),
                          )
                        : Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.data.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 2,
                                              spreadRadius: 1.0,
                                            )
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!.data[index]
                                                            .name +
                                                        "  (" +
                                                        snapshot
                                                            .data!
                                                            .data[index]
                                                            .relation +
                                                        ")",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15),
                                                  ),
                                                  Text(
                                                    snapshot.data!.data[index]
                                                        .mobile,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15),
                                                  )
                                                ]),
                                          ),
                                          Spacer(),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                  onPressed: (() {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Delete This Contact?"),
                                                          content: Text(
                                                              "This will delete the Contact from your Emergency Contact List."),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  "Cancel"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text("OK"),
                                                              onPressed: () {
                                                                delete_emergency_contact(
                                                                        user_id,
                                                                        access_token,
                                                                        snapshot
                                                                            .data!
                                                                            .data[
                                                                                index]
                                                                            .id)
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                          .statusCode ==
                                                                      200) {
                                                                    setState(
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("Deleted Successfully ")));
                                                                    });
                                                                    print(value
                                                                        .body);
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }),
                                                  icon: Icon(Icons.delete)),
                                              IconButton(
                                                  onPressed: (() async {
                                                    String url =
                                                        "tel:${snapshot.data!.data[index].mobile}";
                                                    if (await canLaunch(url)) {
                                                      await launch(url);
                                                    } else {
                                                      throw 'Could not launch $url';
                                                    }
                                                  }),
                                                  icon: Icon(Icons.call))
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                  ]),
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 16,
                child: SizedBox(
                  height: 360,
                  width: 500,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: "Full Name"),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 85,
                        width: 300,
                        child: IntlPhoneField(
                          initialCountryCode: 'IN',
                          onChanged: (value) {
                            number = value.completeNumber.toString();
                            print(number);
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: "Mobile Number"),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: TextField(
                          controller: relationController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: "Enter Relation"),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 110,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: (() {
                                  Navigator.pop(context);
                                }),
                                child: Text("Close")),
                          ),
                          SizedBox(
                            height: 40,
                            width: 110,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: (() {
                                  print(user_id);
                                  print(access_token);
                                  add_emergency_contact(
                                          user_id,
                                          access_token,
                                          nameController.text,
                                          number,
                                          relationController.text)
                                      .then((value) {
                                    if (value.statusCode == 200) {
                                      print(value.body);
                                      setState(() {
                                        Navigator.pop(context);
                                        nameController.text = "";
                                        relationController.text = "";
                                      });
                                    }
                                  });
                                }),
                                child: Text("Save")),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

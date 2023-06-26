import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../doctorList/doctorProfileDetails.dart';
import '../doctorList/doctor_list.dart';
import 'familyDoctorAndFavouritelistApiServices.dart';

class MyDoctor extends StatefulWidget {
  final String family_member_id;
  const MyDoctor({Key? key, required this.family_member_id}) : super(key: key);

  @override
  State<MyDoctor> createState() => _MyDoctorState();
}

class _MyDoctorState extends State<MyDoctor> {
  @override
  String? access_token;

  String? user_id;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      access_token = prefs.getString('access_token');
      user_id = prefs.getString('user_id');
      print(access_token);
      print(user_id);
      print(widget.family_member_id);
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
    return FutureBuilder(
      future: listFamilyAndFavoriteDoctors(
          user_id, access_token, widget.family_member_id),
      builder: (context, snapshot) {
        print(snapshot.hasData);
        if (snapshot.hasData) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue[900],
                onPressed: (() async {
                  String refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorList(
                                family_member_id: widget.family_member_id,
                              )));
                  if (refresh == "refresh") {
                    setState(() {
                      print("hy");
                    });
                  }
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
                  "My Doctor(s)",
                  style: TextStyle(color: Colors.black),
                ),
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const Text(
                      "Family Doctor",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    snapshot.data!.familyDoctorStatus == false
                        ? const Text('No Family Doctor')
                        : InkWell(
                            onTap: () async {
                              String refresh = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DoctorProfileDetails(
                                            doctorId: snapshot
                                                .data!.familyDoctor.doctorId,
                                            family_member_id:
                                                widget.family_member_id,
                                          )));
                              if (refresh == "refresh") {
                                setState(() {
                                  print("refresh");
                                });
                              }
                            },
                            child: Card(
                              elevation: 8,
                              shadowColor: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                            radius: 30,
                                            child: ClipOval(
                                              child: Image(
                                                height: 80,
                                                width: 80,
                                                image:
                                                    CachedNetworkImageProvider(
                                                        snapshot
                                                            .data!
                                                            .familyDoctor
                                                            .profilePic
                                                            .toString()),
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "Exp:${snapshot.data!.familyDoctor.experience}")
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot
                                            .data!.familyDoctor.username
                                            .toString()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(snapshot
                                            .data!.familyDoctor.organisation
                                            .toString()),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(snapshot
                                            .data!.familyDoctor.specialization
                                            .toString())
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    snapshot.data!.recentDoctor.isEmpty
                        ? const SizedBox()
                        : const Center(
                            child: Text(
                            "Recently visited Doctor(s)",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                    Expanded(
                      child: Column(
                        children: [
                          snapshot.data!.recentDoctor.isEmpty
                              ? const SizedBox()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.recentDoctor.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        String refresh = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DoctorProfileDetails(
                                                      doctorId: snapshot
                                                          .data!
                                                          .recentDoctor[index]
                                                          .doctorId,
                                                      family_member_id: widget
                                                          .family_member_id,
                                                    )));
                                        if (refresh == "refresh") {
                                          setState(() {
                                            print("refresh");
                                          });
                                        }
                                      },
                                      child: Card(
                                        elevation: 8,
                                        shadowColor: Colors.blue,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                      radius: 30,
                                                      child: ClipOval(
                                                        child: Image(
                                                          height: 80,
                                                          width: 80,
                                                          image: CachedNetworkImageProvider(
                                                              snapshot
                                                                  .data!
                                                                  .recentDoctor[
                                                                      index]
                                                                  .profilePic
                                                                  .toString()),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      "Exp:${snapshot.data!.recentDoctor[index].experience}")
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(snapshot
                                                      .data!
                                                      .recentDoctor[index]
                                                      .doctorName
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(snapshot
                                                      .data!
                                                      .recentDoctor[index]
                                                      .organisation
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(snapshot
                                                      .data!
                                                      .recentDoctor[index]
                                                      .specialization
                                                      .toString())
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                          const Center(
                            child: Text(
                              "Favourite Doctor(s)",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          snapshot.data!.favouriteDoctorStatus == false
                              ? const Center(child: Text('No Favourite Doctor'))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      snapshot.data!.favouriteDoctor.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        String refresh = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DoctorProfileDetails(
                                                      doctorId: snapshot
                                                          .data!
                                                          .favouriteDoctor[
                                                              index]
                                                          .doctorId,
                                                      family_member_id: widget
                                                          .family_member_id,
                                                    )));
                                        if (refresh == "refresh") {
                                          setState(() {
                                            print("refresh");
                                          });
                                        }
                                      },
                                      child: Card(
                                        elevation: 8,
                                        shadowColor: Colors.blue,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  CircleAvatar(
                                                      radius: 30,
                                                      child: ClipOval(
                                                        child: Image(
                                                          height: 80,
                                                          width: 80,
                                                          image: CachedNetworkImageProvider(
                                                              snapshot
                                                                  .data!
                                                                  .favouriteDoctor[
                                                                      index]
                                                                  .profilePic
                                                                  .toString()),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      "Exp:${snapshot.data!.favouriteDoctor[index].experience}")
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(snapshot
                                                      .data!
                                                      .favouriteDoctor[index]
                                                      .username
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(snapshot
                                                      .data!
                                                      .favouriteDoctor[index]
                                                      .organisation
                                                      .toString()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(snapshot
                                                      .data!
                                                      .favouriteDoctor[index]
                                                      .specialization
                                                      .toString())
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text(
                "My Doctor",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
            ),
            body: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                    enabled: true,
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: 100,
                        width: 20,
                      ),
                    ));
              },
            ),
          );
        }
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../doctorList/doctorProfileDetails.dart';
import 'dashboardApiService.dart';

class DashboardSearch extends StatefulWidget {
  String family_member_id = "";
  DashboardSearch({
    Key? key,
    required this.family_member_id,
  }) : super(key: key);

  @override
  State<DashboardSearch> createState() => _DashboardSearchState();
}

class _DashboardSearchState extends State<DashboardSearch> {
  String user_id = "";
  String access_token = "";
  String search = "";
  FocusNode searchInputFocus = FocusNode();

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
    return FutureBuilder(
      future: dashboard_search(user_id, access_token, search),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              searchInputFocus.unfocus();
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                title: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: TextFormField(
                    focusNode: searchInputFocus,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: Colors.blue)),
                      suffixIcon: const InkWell(
                        child: Icon(Icons.search),
                      ),
                      contentPadding: const EdgeInsets.all(10.0),
                      hintText: 'Search Doctors, Hospitals Etc...',
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    snapshot.data!.data.doctors.isEmpty
                        ? const SizedBox()
                        : const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Doctors",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.data.doctors.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DoctorProfileDetails(
                                            doctorId: snapshot
                                                .data!.data.doctors[index].id,
                                            family_member_id:
                                                widget.family_member_id,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 8,
                                shadowColor: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image(
                                              height: 110,
                                              width: 110,
                                              image: CachedNetworkImageProvider(
                                                  snapshot
                                                      .data!
                                                      .data
                                                      .doctors[index]
                                                      .profilePic),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data!.data
                                                  .doctors[index].name),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Exp:${snapshot
                                                          .data!
                                                          .data
                                                          .doctors[index]
                                                          .experience}"),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  snapshot
                                                      .data!
                                                      .data
                                                      .doctors[index]
                                                      .organisation,
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  snapshot
                                                      .data!
                                                      .data
                                                      .doctors[index]
                                                      .specialization,
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    snapshot.data!.data.hospital.isEmpty
                        ? const SizedBox()
                        : const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Hospitals",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.data.hospital.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 8,
                                shadowColor: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image(
                                              height: 110,
                                              width: 110,
                                              image: CachedNetworkImageProvider(
                                                  snapshot
                                                      .data!
                                                      .data
                                                      .hospital[index]
                                                      .profilePic),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data!.data
                                                  .hospital[index].name),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  snapshot
                                                      .data!
                                                      .data
                                                      .hospital[index]
                                                      .specialization,
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    snapshot.data!.data.lab.isEmpty
                        ? const SizedBox()
                        : const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Lab",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.data.lab.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              // String refresh = await Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             DoctorProfileDetails(
                              //               doctorId:"",
                              //               family_member_id:
                              //                  "",
                              //             )));
                              // if (refresh == "refresh") {
                              //   setState(() {});
                              //   print("object");
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 8,
                                shadowColor: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: const Image(
                                              height: 110,
                                              width: 110,
                                              image: CachedNetworkImageProvider(
                                                  "https://creativeapplab.in//med_app//medical_app//uploads//files//10//FILE_20230208111046.jpg"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot
                                                  .data!.data.lab[index].name),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: const [
                                                  Text("Experience:"),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const SizedBox(
                                                width: 200,
                                                child: Text(
                                                  "organisation",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const SizedBox(
                                                width: 200,
                                                child: Text(
                                                  "specialization",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    snapshot.data!.data.pharmacy.isEmpty
                        ? const SizedBox()
                        : const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "Pharmacy",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.data.pharmacy.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              // String refresh = await Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             DoctorProfileDetails(
                              //               doctorId:"",
                              //               family_member_id:
                              //                  "",
                              //             )));
                              // if (refresh == "refresh") {
                              //   setState(() {});
                              //   print("object");
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 8,
                                shadowColor: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: const Image(
                                              height: 110,
                                              width: 110,
                                              image: CachedNetworkImageProvider(
                                                  "https://creativeapplab.in//med_app//medical_app//uploads//files//10//FILE_20230208111046.jpg"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data!.data
                                                  .pharmacy[index].name),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: const [
                                                  Text("Experience:"),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const SizedBox(
                                                width: 200,
                                                child: Text(
                                                  "organisation",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const SizedBox(
                                                width: 200,
                                                child: Text(
                                                  "specialization",
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

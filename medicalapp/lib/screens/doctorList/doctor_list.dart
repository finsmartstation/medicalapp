import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../favouriteDoctor/familyDoctorAndFavouritelistApiServices.dart';
import '../favouriteDoctor/my_doctor.dart';
import 'doctorListApiServices.dart';
import 'doctorProfileDetails.dart';

class DoctorList extends StatefulWidget {
  String? family_member_id;
  String? splInputSearch;
  DoctorList({Key? key, this.family_member_id, this.splInputSearch})
      : super(key: key);

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  String? access_token;
  String? user_id;
  String searchkey = "";
  TextEditingController searchInput = TextEditingController();
  FocusNode searchInputFocus = FocusNode();

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      access_token = prefs.getString('access_token');
      user_id = prefs.getString('user_id');
      print(access_token);
      print(user_id);
    });
    setState(() {
      if (widget.splInputSearch!.isNotEmpty) {
        searchkey = widget.splInputSearch.toString();
        searchInput.text = widget.splInputSearch.toString();
      }
    });
  }

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, "refresh");
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            searchInputFocus.unfocus();
          });
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: (() {
                  Navigator.pop(context, "refresh");
                }),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )),
            title: Text(
              'Doctor List',
              style: TextStyle(color: Color.fromARGB(255, 36, 22, 22)),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        focusNode: searchInputFocus,
                        controller: searchInput,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.blue)),
                          suffixIcon: InkWell(
                            child: Icon(Icons.search),
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                          hintText: 'Search Doctors, Hospitals Etc...',
                        ),
                        onChanged: ((value) {
                          setState(() {
                            searchkey = value;
                          });
                        }),
                      ),
                    ),
                    IconButton(onPressed: (() {}), icon: Icon(Icons.filter_alt))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: listDoctor(
                    user_id, access_token, searchkey, widget.family_member_id),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    print('length');
                    print(snapshot.data!.data);
                    return Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                String refresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorProfileDetails(
                                              doctorId: snapshot
                                                  .data!.data[index].doctorId,
                                              family_member_id:
                                                  widget.family_member_id,
                                            )));
                                if (refresh == "refresh") {
                                  setState(() {});
                                  print("object");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                                                image:
                                                    CachedNetworkImageProvider(
                                                        snapshot
                                                            .data!
                                                            .data[index]
                                                            .profilePic),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(snapshot.data!.data[index]
                                                    .doctorName
                                                    .toString()),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "Experience:${snapshot.data!.data[index].experience}"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    snapshot.data!.data[index]
                                                        .organisation
                                                        .toString(),
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    snapshot.data!.data[index]
                                                        .specialization
                                                        .toString(),
                                                    maxLines: 5,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      addFamilyDoctor(
                                                              user_id
                                                                  .toString(),
                                                              access_token
                                                                  .toString(),
                                                              snapshot
                                                                  .data!
                                                                  .data[index]
                                                                  .doctorId
                                                                  .toString())
                                                          .then((value) {
                                                        if (value.statusCode ==
                                                            200) {
                                                          setState(() {
                                                            var jsonData =
                                                                jsonDecode(
                                                                    value.body);
                                                            print(jsonData);
                                                          });
                                                        }
                                                      });
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      )),
                                                      backgroundColor:
                                                          MaterialStateProperty.all(snapshot
                                                                      .data!
                                                                      .data[
                                                                          index]
                                                                      .familyDoctorStatus
                                                                      .toString() ==
                                                                  '1'
                                                              ? Colors.grey
                                                              : Colors.blue)),
                                                  child: Text(
                                                    snapshot.data!.data[index]
                                                                .familyDoctorStatus
                                                                .toString() ==
                                                            '1'
                                                        ? "Family Doctor"
                                                        : "Add as Family Doctor",
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  )),
                                              snapshot.data!.data[index]
                                                          .favouriteDoctorStatus ==
                                                      "1"
                                                  ? IconButton(
                                                      onPressed: () {
                                                        print(snapshot
                                                            .data!
                                                            .data[index]
                                                            .favouriteDoctorStatus);
                                                        print(
                                                            "userid---$user_id");
                                                        print(
                                                            "accesstoken---$access_token");
                                                        setState(() {
                                                          removeFavoriteDoctor(
                                                                  user_id,
                                                                  access_token,
                                                                  widget
                                                                      .family_member_id,
                                                                  snapshot
                                                                      .data!
                                                                      .data[
                                                                          index]
                                                                      .doctorId
                                                                      .toString())
                                                              .then((value) {
                                                            if (value
                                                                    .statusCode ==
                                                                200) {
                                                              var jsonData =
                                                                  jsonDecode(
                                                                      value
                                                                          .body);
                                                              print(jsonData);
                                                            }
                                                          });
                                                        });
                                                      },
                                                      icon: Icon(Icons.favorite,
                                                          color: Colors.red))
                                                  : IconButton(
                                                      onPressed: () {
                                                        print(snapshot
                                                            .data!
                                                            .data[index]
                                                            .favouriteDoctorStatus);
                                                        print(
                                                            "userid---$user_id");
                                                        print(
                                                            "accesstoken---$access_token");
                                                        setState(() {
                                                          addFavoriteDoctor(
                                                                  user_id
                                                                      .toString(),
                                                                  access_token
                                                                      .toString(),
                                                                  widget
                                                                      .family_member_id,
                                                                  snapshot
                                                                      .data!
                                                                      .data[
                                                                          index]
                                                                      .doctorId
                                                                      .toString())
                                                              .then((value) {
                                                            if (value
                                                                    .statusCode ==
                                                                200) {
                                                              var jsonData =
                                                                  jsonDecode(
                                                                      value
                                                                          .body);
                                                              print(jsonData);
                                                            }
                                                          });
                                                        });
                                                      },
                                                      icon: Icon(Icons.favorite,
                                                          color: Colors.grey)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/dashboardScreen.dart';
import 'addNewFamilyMember.dart';
import 'familyMembersApiServices.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
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
    getSherPref();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: Text(
          "My Family Members",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
          future: get_family_members(user_id, access_token),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(user_id);
              print(access_token);
              print(snapshot.data!.data);
              return ListView.builder(
                itemCount: snapshot.data!.data.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardPatient(
                                      family_member_id: snapshot
                                          .data!.data[index].id
                                          .toString(),
                                    )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 8,
                        shadowColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                    radius: 30,
                                    child: ClipOval(
                                      child: Image.network(
                                        snapshot.data!.data[index].profilePic
                                            .toString(),
                                        fit: BoxFit.fill,
                                        width: 60,
                                        height: 60,
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data!.data[index].username
                                        .toString()),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Text(snapshot.data!.data[index].emailId
                                    //     .toString()),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    Text(snapshot.data!.data[index].relation
                                        .toString())
                                  ],
                                ),
                              ),
                              Spacer(),
                              index == 0
                                  ? Spacer()
                                  : IconButton(
                                      onPressed: (() {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Delete This Family Member?"),
                                              content: Text(
                                                  "This will delete the Family Member and Member all Details."),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    delete_family_member(
                                                            user_id,
                                                            access_token,
                                                            snapshot.data!
                                                                .data[index].id
                                                                .toString())
                                                        .then((value) {
                                                      if (value.statusCode ==
                                                          200) {
                                                        setState(() {
                                                          Navigator
                                                              .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          DashboardPatient(
                                                                            family_member_id:
                                                                                snapshot.data!.data[0].id.toString(),
                                                                          )));
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: const Text(
                                                              "deleted family member",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .blue[800],
                                                            elevation: 10,
                                                          ));
                                                          print(value.body);
                                                        });
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }),
                                      icon: Icon(Icons.delete_outline)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddFamilyMember()));
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}
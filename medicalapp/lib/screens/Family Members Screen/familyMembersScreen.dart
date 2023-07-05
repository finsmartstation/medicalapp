import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../dashboard/dashboardScreen.dart';
import 'addNewFamilyMember.dart';
import 'familyMembersApiServices.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
 
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
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: const Text(
          "My Family Members",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
          future: get_family_members(context.watch<AuthProvider>().u_id, context.watch<AuthProvider>().access_token),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasData) {
             
              print(snapshot.data!.data);
              return ListView.builder(
                itemCount: snapshot.data!.data.length,
                physics: const BouncingScrollPhysics(),
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
                                    const SizedBox(
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
                              const Spacer(),
                              index == 0
                                  ? const Spacer()
                                  : IconButton(
                                      onPressed: (() {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Delete This Family Member?"),
                                              content: const Text(
                                                  "This will delete the Family Member and Member all Details."),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text("OK"),
                                                  onPressed: () {
                                                    delete_family_member(
                                                           context.watch<AuthProvider>().u_id,
                                                            context.watch<AuthProvider>().access_token,
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
                                      icon: const Icon(Icons.delete_outline)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AddFamilyMember()));
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'editProfile.dart';

class ProfilePatient extends StatefulWidget {
  String name;
  String mobile;
  String email;
  String blood;
  String gender;
  String height;
  String weight;
  String relation;
  DateTime dob;
  String profile;
  String familyMemberId;
  String half_path;

  ProfilePatient({
    Key? key,
    required this.name,
    required this.mobile,
    required this.email,
    required this.blood,
    required this.gender,
    required this.height,
    required this.dob,
    required this.profile,
    required this.relation,
    required this.weight,
    required this.familyMemberId,
    required this.half_path,
  }) : super(key: key);

  @override
  State<ProfilePatient> createState() => _ProfilePatientState();
}

class _ProfilePatientState extends State<ProfilePatient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 2))
                        ],
                        color: Colors.blue[700]),
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Name: ${widget.name}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Mobile: ${widget.mobile}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Email: ${widget.email}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Blood Group: ${widget.blood}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Gender: ${widget.gender}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Height: ${widget.height}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Weight: ${widget.weight}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  widget.relation == "self"
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Relation: ${widget.relation}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Dob: ${DateFormat("dd/MM/yyyy").format(widget.dob)}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 40,
                right: 40,
                child: Container(
                  width: 150,
                  height: 150,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    child: ClipOval(
                      child: Image(
                        image: CachedNetworkImageProvider(widget.profile),
                        fit: BoxFit.cover,
                        width: 140,
                        height: 140,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfile(
                        blood: widget.blood,
                        dob: widget.dob,
                        email: widget.email,
                        gender: widget.gender,
                        height: widget.height,
                        mobile: widget.mobile,
                        name: widget.name,
                        profile: widget.profile,
                        relation: widget.relation,
                        weight: widget.weight,
                        familyMemberId: widget.familyMemberId,
                        half_path: widget.half_path,
                      )));
        },
      ),
    );
  }
}

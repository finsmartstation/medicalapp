import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/screens/UserProfile/profileApiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service/api_services.dart';
import '../../utility/constants.dart';
import '../dashboard/dashboardScreen.dart';

class EditProfile extends StatefulWidget {
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

  EditProfile(
      {Key? key,
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
      required this.half_path})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode relationFocusNode = FocusNode();
  FocusNode dobFocusNode = FocusNode();
  FocusNode heightFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  String bloodGroup = "";
  String ApiformattedDate = "";
  String gender = "";
  String user_id = "";
  String access_token = "";

  String profilePath = "";
  String paths = "";
  var items = [
    '',
    'A-',
    'O-',
    'B-',
    'AB-',
    'A+',
    'O+',
    'B+',
    'AB+',
  ];
  getSherPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id').toString();
      access_token = prefs.getString('access_token').toString();
      nameController.text = widget.name;
      emailController.text = widget.email;
      relationController.text = widget.relation;
      dobController.text = DateFormat("dd/MM/yyyy").format(widget.dob);
      heightController.text = widget.height;
      weightController.text = widget.weight;
      bloodGroup = widget.blood;
      gender = widget.gender;
      profilePath = widget.profile;
      paths = widget.half_path;
      ApiformattedDate = DateFormat('yyyy-MM-dd').format(widget.dob);
    });
  }

  @override
  void initState() {
    getSherPref();

    print("____________________________________");
    print(ApiformattedDate);
    print(user_id);
    print(access_token);
    // TODO: implement initState
    super.initState();
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
    print(_imageFileList);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          nameFocusNode.unfocus();
          emailFocusNode.unfocus();
          dobFocusNode.unfocus();
          heightFocusNode.unfocus();
          weightFocusNode.unfocus();
          relationFocusNode.unfocus();
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text(
            "Edit profile",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 150,
                              height: 150,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.blueAccent),
                              ),
                              child: ClipOval(
                                  child: Image.network(
                                profilePath,
                                fit: BoxFit.fill,
                              ))),
                        ],
                      ),
                      Positioned(
                        top: 100,
                        left: MediaQuery.of(context).size.width / 4,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.grey,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Profile picture",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30)),
                                                            color:
                                                                Colors.white),
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        print(profilePath);
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                        XFile? pickedFile =
                                                            await _picker
                                                                .pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                          maxWidth: 1800,
                                                          maxHeight: 1800,
                                                        );
                                                        if (pickedFile !=
                                                            null) {
                                                          setState(() {
                                                            _setImageFileListFromFile(
                                                                pickedFile);

                                                            ApiService()
                                                                .file_upload(
                                                                    user_id,
                                                                    access_token,
                                                                    pickedFile
                                                                        .path)
                                                                .then(
                                                              (value) {
                                                                if (value
                                                                        .statusCode ==
                                                                    200) {
                                                                  value.stream
                                                                      .transform(utf8
                                                                          .decoder)
                                                                      .listen(
                                                                          (event) {
                                                                    var path =
                                                                        jsonDecode(
                                                                            event);
                                                                    setState(
                                                                        () {
                                                                      paths = path[
                                                                          'file_path'];
                                                                      profilePath =
                                                                          baseUrl +
                                                                              path['file_path'];

                                                                      print(
                                                                          profilePath);
                                                                    });

                                                                    print(
                                                                        profilePath);
                                                                  });
                                                                }
                                                              },
                                                            );
                                                          });
                                                        }
                                                      },
                                                      icon: const Icon(Icons
                                                          .camera_alt_rounded),
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  const Text("Camera"),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 40,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          color: Colors.white),
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      print(profilePath);
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                      XFile? pickedFile =
                                                          await _picker
                                                              .pickImage(
                                                        source:
                                                            ImageSource.gallery,
                                                        maxWidth: 1800,
                                                        maxHeight: 1800,
                                                      );
                                                      if (pickedFile != null) {
                                                        setState(() {
                                                          _setImageFileListFromFile(
                                                              pickedFile);
                                                          print(user_id);
                                                          print(access_token);

                                                          ApiService()
                                                              .file_upload(
                                                                  user_id,
                                                                  access_token,
                                                                  pickedFile
                                                                      .path
                                                                      .toString())
                                                              .then(
                                                            (value) {
                                                              if (value
                                                                      .statusCode ==
                                                                  200) {
                                                                value.stream
                                                                    .transform(utf8
                                                                        .decoder)
                                                                    .listen(
                                                                        (event) {
                                                                  var path =
                                                                      jsonDecode(
                                                                          event);
                                                                  setState(() {
                                                                    paths = path[
                                                                        'file_path'];
                                                                    profilePath =
                                                                        baseUrl +
                                                                            path['file_path'];
                                                                    print(
                                                                        profilePath);
                                                                  });
                                                                  print(paths);
                                                                });
                                                              }
                                                            },
                                                          );
                                                          print(
                                                              pickedFile.path);

                                                          print(
                                                              "---------------------------");
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(Icons.image),
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                Text('Gallery')
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.camera_alt_rounded),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      focusNode: nameFocusNode,
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          icon: Icon(Icons.person),
                          hintText: "Name")),
                ),
                widget.relation != "self"
                    ? SizedBox()
                    : const SizedBox(
                        height: 20,
                      ),
                widget.relation != "self"
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            focusNode: emailFocusNode,
                            controller: emailController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                icon: Icon(Icons.email),
                                hintText: "Email")),
                      ),
                widget.relation == "self"
                    ? SizedBox()
                    : const SizedBox(
                        height: 20,
                      ),
                widget.relation == "self"
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            focusNode: relationFocusNode,
                            controller: relationController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                icon: Icon(Icons.family_restroom),
                                hintText: "Relation")),
                      ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: TextFormField(
                    focusNode: dobFocusNode,
                    controller: dobController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        icon: Icon(Icons.calendar_today),
                        labelText: "Enter Date Of Birth"),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now());

                      if (pickedDate != null) {
                        print(pickedDate);
                        ApiformattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          dobController.text =
                              DateFormat('yyyy/MM/dd').format(pickedDate);
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  )),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                          child: Text(
                        'Blood Group:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: DropdownButton(
                          value: bloodGroup,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              //  bloodGroup = newValue.toString();
                              bloodGroup = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 190,
                          child: TextFormField(
                              focusNode: heightFocusNode,
                              keyboardType: TextInputType.number,
                              controller: heightController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  hintText: "Hight")),
                        ),
                        SizedBox(
                          width: 190,
                          child: TextFormField(
                              focusNode: weightFocusNode,
                              keyboardType: TextInputType.number,
                              controller: weightController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  hintText: "Weight ")),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Text('Choose your Gender'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                            value: "male",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              }); //selected value
                            }),
                        Text('Male'),
                        Radio(
                            value: "female",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              }); //selected value
                            }),
                        Text('Female'),
                        Radio(
                            value: "others",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              }); //selected value
                            }),
                        Text('Others'),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: (() {
                      print(dobController.text);
                      print(paths);
                      print(ApiformattedDate);
                      edit_patient_details(
                              user_id,
                              access_token,
                              widget.familyMemberId,
                              gender,
                              emailController.text,
                              nameController.text,
                              ApiformattedDate.toString(),
                              bloodGroup,
                              heightController.text,
                              weightController.text,
                              relationController.text,
                              paths)
                          .then((value) {
                        if (value.statusCode == 200) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPatient(
                                        family_member_id: widget.familyMemberId,
                                      )));
                          print(value.body);
                        }
                      });
                    }),
                    child: Text("Submit"))
              ],
            )),
      ),
    );
  }
}

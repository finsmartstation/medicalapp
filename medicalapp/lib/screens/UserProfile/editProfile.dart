import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/screens/UserProfile/profileApiServices.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service/api_services.dart';
import '../../providers/auth_provider.dart';
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

  bool nameStatus = false;
  bool emailStatus = false;
  bool heightStatus = false;
  bool weightStatus = false;
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

  static Future<CroppedFile?> cropImage(File? imageFile) async {
    print('FILE===========> ${imageFile!.path}');
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarTitle: 'Crop Image',
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings()
      ],
    );

    return croppedFile;
  }

  getdata() async {
    setState(() {
  
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
    getdata();

    print("____________________________________");
    print(ApiformattedDate);
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
          title: const Text(
            "Edit profile",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.blueAccent),
                              ),
                              child: ClipOval(
                                  child: CircleAvatar(
                                backgroundImage: NetworkImage(profilePath),
                              )
                                  //     Image.network(
                                  //   profilePath,
                                  //   fit: BoxFit.fill,
                                  // )
                                  )),
                        ],
                      ),
                      Positioned(
                        top: 100,
                        left: MediaQuery.of(context).size.width / 4,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
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
                                            Column(
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
                                                        cropImage(File(
                                                                pickedFile
                                                                    .path))
                                                            .then(
                                                          (value) {
                                                            setState(() {
                                                              _setImageFileListFromFile(
                                                                  XFile(value!
                                                                      .path));

                                                              ApiService()
                                                                  .file_upload(
                                                                      context.watch<AuthProvider>().u_id,
                                                                      context.watch<AuthProvider>().access_token,
                                                                      value
                                                                          .path)
                                                                  .then(
                                                                (value) {
                                                                  if (value
                                                                          .statusCode ==
                                                                      200) {
                                                                    value
                                                                        .stream
                                                                        .transform(utf8
                                                                            .decoder)
                                                                        .listen(
                                                                            (event) {
                                                                      var path =
                                                                          jsonDecode(event);
                                                                      setState(
                                                                          () {
                                                                        paths =
                                                                            path['file_path'];
                                                                        profilePath =
                                                                            baseUrl + path['file_path'];

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
                                                          },
                                                        );
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
                                                        cropImage(File(
                                                                pickedFile
                                                                    .path))
                                                            .then(
                                                          (value) {
                                                            setState(() {
                                                              _setImageFileListFromFile(
                                                                  XFile(value!
                                                                      .path));
                                                             

                                                              ApiService()
                                                                  .file_upload(
                                                                      context.watch<AuthProvider>().u_id,
                                                                      context.watch<AuthProvider>().access_token,
                                                                      value.path
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
                                                                      setState(
                                                                          () {
                                                                        paths =
                                                                            path['file_path'];
                                                                        profilePath =
                                                                            baseUrl +
                                                                                path['file_path'];
                                                                        print(
                                                                            profilePath);
                                                                      });
                                                                      print(
                                                                          paths);
                                                                    });
                                                                  }
                                                                },
                                                              );
                                                              print(value.path);

                                                              print(
                                                                  "---------------------------");
                                                            });
                                                          },
                                                        );
                                                      }
                                                    },
                                                    icon:
                                                        const Icon(Icons.image),
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const Text('Gallery')
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
                            icon: const Icon(Icons.camera_alt_rounded),
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
                nameStatus
                    ? Text(
                        'Required',
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                widget.relation != "self"
                    ? const SizedBox()
                    : const SizedBox(
                        height: 20,
                      ),
                widget.relation != "self"
                    ? const SizedBox()
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
                emailStatus
                    ? Text(
                        'Required',
                        style: TextStyle(color: Colors.red),
                      )
                    : SizedBox(),
                widget.relation == "self"
                    ? const SizedBox()
                    : const SizedBox(
                        height: 20,
                      ),
                widget.relation == "self"
                    ? const SizedBox()
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: TextFormField(
                    focusNode: dobFocusNode,
                    controller: dobController,
                    decoration: const InputDecoration(
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
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Blood Group:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 190,
                            child: TextFormField(
                                focusNode: heightFocusNode,
                                keyboardType: TextInputType.number,
                                controller: heightController,
                                 inputFormatters: [
                                        // LengthLimitingTextInputFormatter(2),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: "Height",
                                    labelText: "Height")),
                          ),
                          heightStatus
                              ? Text(
                                  'Required',
                                  style: TextStyle(color: Colors.red),
                                )
                              : SizedBox(),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 190,
                            child: TextFormField(
                              focusNode: weightFocusNode,
                              keyboardType: TextInputType.number,
                              controller: weightController,
                               inputFormatters: [
                                        // LengthLimitingTextInputFormatter(2),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  hintText: "Weight ",
                                  labelText: "Weight "),
                            ),
                          ),
                          weightStatus
                              ? Text(
                                  'Required',
                                  style: TextStyle(color: Colors.red),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    const Text('Choose your Gender'),
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
                        const Text('Male'),
                        Radio(
                            value: "female",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              }); //selected value
                            }),
                        const Text('Female'),
                        Radio(
                            value: "others",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              }); //selected value
                            }),
                        const Text('Others'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: (() {
                      print(dobController.text);
                      print(paths);
                      print(ApiformattedDate);
                      if (nameController.text.isEmpty) {
                        nameStatus = true;
                        setState(() {});
                      } else {
                        nameStatus = false;
                        setState(() {});
                      }
                      if (emailController.text.isEmpty) {
                        emailStatus = true;
                        setState(() {});
                      } else {
                        emailStatus = false;
                        setState(() {});
                      }
                      if (heightController.text.isEmpty) {
                        heightStatus = true;
                        setState(() {});
                      } else {
                        heightStatus = false;
                        setState(() {});
                      }
                      if (weightController.text.isEmpty) {
                        weightStatus = true;
                        setState(() {});
                      } else {
                        weightStatus = false;
                        setState(() {});
                      }
                      if (nameStatus == false &&
                          emailStatus == false &&
                          heightStatus == false &&
                          weightStatus == false) {
                        edit_patient_details(
                                context.watch<AuthProvider>().u_id,
                                context.watch<AuthProvider>().access_token,
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
                             ScaffoldMessenger.of(context)
                              .showSnackBar( SnackBar(
                                duration: Duration(seconds:3),
                            content:
                                Text("Profile updated"),
                          ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardPatient(
                                          family_member_id:
                                              widget.familyMemberId,
                                        )));
                            print(value.body);
                          }
                        });
                      }
                    }),
                    child: const Text("Submit"))
              ],
            )),
      ),
    );
  }
}

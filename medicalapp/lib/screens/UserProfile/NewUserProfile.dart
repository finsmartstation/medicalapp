import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medicalapp/screens/UserProfile/profileApiServices.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';
import '../../providers/verifiProfileEdit.dart';
import '../../service/api_services.dart';
import '../../utility/constants.dart';
import '../dashboard/dashboardScreen.dart';

class NewUserProfile extends StatefulWidget {
  const NewUserProfile({super.key});

  @override
  State<NewUserProfile> createState() => _NewUserProfileState();
}

class _NewUserProfileState extends State<NewUserProfile> {
  //String dropdownvalue = 'A-';

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode dobFocusNode = FocusNode();
  FocusNode heightFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
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
  String ApiformattedDate = "";
  String userId = '';
  String aToken = '';

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
    print(_imageFileList);
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final myProvider =
        Provider.of<PatientDetailsProvider>(context, listen: false)
            .getSharePref();
  }

  @override
  Widget build(BuildContext context) {
    userId = context.watch<AuthProvider>().u_id;
    aToken = context.watch<AuthProvider>().access_token;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, "a");
        return Future.value(false);
      },
      child: Consumer2<VerifyProfileEditData, PatientDetailsProvider>(
        builder: (context, verifyData, patientDetailProvider, child) {
          return GestureDetector(
            onTap: () {
              setState(() {
                nameFocusNode.unfocus();
                emailFocusNode.unfocus();
                dobFocusNode.unfocus();
                heightFocusNode.unfocus();
                weightFocusNode.unfocus();
              });
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: (() {
                      Navigator.pop(context, "a");
                    }),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                title: const Text(
                  "Profile",
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
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                    ),
                                    child: ClipOval(
                                      child: Image(
                                        height: 150,
                                        width: 150,
                                        image: CachedNetworkImageProvider(
                                            patientDetailProvider
                                                .full_profile_link
                                                .toString()),
                                        fit: BoxFit.fill,
                                      ),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30)),
                                                            color:
                                                                Colors.white),
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                            XFile? pickedFile =
                                                                await _picker
                                                                    .pickImage(
                                                              source:
                                                                  ImageSource
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
                                                                          userId,
                                                                          aToken,
                                                                          value
                                                                              .path)
                                                                      .then(
                                                                    (value) {
                                                                      if (value
                                                                              .statusCode ==
                                                                          200) {
                                                                        value
                                                                            .stream
                                                                            .transform(utf8.decoder)
                                                                            .listen((event) {
                                                                          var path =
                                                                              jsonDecode(event);
                                                                          patientDetailProvider.Profile_path =
                                                                              path['file_path'];
                                                                          patientDetailProvider.saveFilePath(baseUrl +
                                                                              patientDetailProvider.Profile_path.toString());
                                                                          print(
                                                                              "-----------fghjk----------------");
                                                                          print(
                                                                              patientDetailProvider.Profile_path);
                                                                        });
                                                                      }
                                                                    },
                                                                  );
                                                                  // print(pickedFile
                                                                  //     .path);

                                                                  print(
                                                                      "---------------------------");
                                                                });
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
                                                  Container(
                                                    width: 40,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30)),
                                                            color:
                                                                Colors.white),
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                            XFile? pickedFile =
                                                                await _picker
                                                                    .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery,
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
                                                                            userId,
                                                                            aToken,
                                                                            value.path)
                                                                        .then(
                                                                      (value) {
                                                                        if (value.statusCode ==
                                                                            200) {
                                                                          value
                                                                              .stream
                                                                              .transform(utf8.decoder)
                                                                              .listen((event) {
                                                                            var path =
                                                                                jsonDecode(event);
                                                                            patientDetailProvider.Profile_path =
                                                                                path['file_path'];
                                                                            patientDetailProvider.saveFilePath(baseUrl +
                                                                                patientDetailProvider.Profile_path.toString());
                                                                            print("---------------------------");
                                                                            print(patientDetailProvider);
                                                                          });
                                                                        }
                                                                      },
                                                                    );
                                                                    print(value
                                                                        .path);

                                                                    print(
                                                                        "---------------------------");
                                                                  });
                                                                },
                                                              );
                                                            }
                                                          },
                                                          icon: const Icon(
                                                              Icons.image),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                              focusNode: nameFocusNode,
                              controller: patientDetailProvider.nameController,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  icon: Icon(Icons.person),
                                  hintText: "Name")),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                              focusNode: emailFocusNode,
                              controller: patientDetailProvider.emailCondroller,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  icon: Icon(Icons.email),
                                  hintText: "Email")),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                            child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            focusNode: dobFocusNode,
                            controller:
                                patientDetailProvider.dateOfBirthCondroller,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                icon: Icon(Icons.calendar_today),
                                hintText: " Date Of Birth"),
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
                                String formattedDate =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);

                                print(formattedDate);
                                setState(() {
                                  patientDetailProvider.dateOfBirthCondroller
                                      .text = formattedDate;
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                        )),
                      ),
                      Center(
                          child: Text(
                        verifyData.verifyDob,
                        style: const TextStyle(color: Colors.red),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 180,
                                  child: TextField(
                                      focusNode: heightFocusNode,
                                      keyboardType: TextInputType.number,
                                      controller: patientDetailProvider
                                          .heightController,
                                      inputFormatters: [
                                        // LengthLimitingTextInputFormatter(2),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(5),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        hintText: "Height",
                                        labelText: "Height",
                                      )),
                                ),
                                Center(
                                    child: Text(
                                  verifyData.verifyHight,
                                  style: const TextStyle(color: Colors.red),
                                )),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 190,
                                  child: TextFormField(
                                      focusNode: weightFocusNode,
                                      keyboardType: TextInputType.number,
                                      controller: patientDetailProvider
                                          .weightController,
                                      inputFormatters: [
                                        // LengthLimitingTextInputFormatter(2),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          hintText: "Weight ",
                                          labelText: "Weight ")),
                                ),
                                Center(
                                    child: Text(
                                  verifyData.verifyWeight,
                                  style: const TextStyle(color: Colors.red),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Blood Group:',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: DropdownButton(
                                value: patientDetailProvider.bloodGroup,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    patientDetailProvider.bloodGroup =
                                        newValue.toString();
                                    patientDetailProvider.bloodGroup =
                                        newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                          child: Text(
                        verifyData.verifyBlood,
                        style: const TextStyle(color: Colors.red),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          const Text(
                            'Choose your Gender',
                            style: TextStyle(fontSize: 18),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                  value: "male",
                                  groupValue: patientDetailProvider.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      patientDetailProvider.gender = value;
                                    }); //selected value
                                  }),
                              const Text('Male'),
                              Radio(
                                  value: "female",
                                  groupValue: patientDetailProvider.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      patientDetailProvider.gender =
                                          value.toString();
                                    }); //selected value
                                  }),
                              const Text('Female'),
                              Radio(
                                  value: "others",
                                  groupValue: patientDetailProvider.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      patientDetailProvider.gender =
                                          value.toString();
                                    }); //selected value
                                  }),
                              const Text('Others'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: (() {
                            print(patientDetailProvider.Profile_path);
                            setState(() {
                              bool dobbool = false;
                              bool hightbool = false;
                              bool weightbool = false;
                              bool bloodbool = false;
                              if (patientDetailProvider.bloodGroup == "") {
                                verifyData.bloodRequird();
                              } else {
                                bloodbool = true;
                                verifyData.verifyBlood = "";
                              }
                              if (patientDetailProvider
                                  .dateOfBirthCondroller.text.isEmpty) {
                                verifyData.dobRequired();
                              } else {
                                verifyData.verifyDob = "";
                                dobbool = true;
                              }
                              if (patientDetailProvider
                                  .heightController.text.isEmpty) {
                                verifyData.hightRequired();
                              } else {
                                hightbool = true;
                                verifyData.verifyHight = "";
                              }
                              if (patientDetailProvider
                                  .weightController.text.isEmpty) {
                                verifyData.weightRequired();
                              } else {
                                weightbool = true;
                                verifyData.verifyWeight = "";
                              }

                              if (dobbool == true &&
                                  hightbool == true &&
                                  weightbool == true &&
                                  bloodbool == true) {
                                fill_patient_profile(
                                       userId,
                                       aToken,
                                        patientDetailProvider.gender,
                                        patientDetailProvider
                                            .emailCondroller.text,
                                        patientDetailProvider
                                            .nameController.text,
                                        ApiformattedDate.toString(),
                                        patientDetailProvider.bloodGroup,
                                        patientDetailProvider
                                            .heightController.text,
                                        patientDetailProvider
                                            .weightController.text,
                                        patientDetailProvider.Profile_path)
                                    .then((value) async {
                                  if (value.statusCode == 200) {
                                    print(value.body);
                                    patientDetailProvider.editProfile(
                                        patientDetailProvider.Profile_path,
                                        baseUrl +
                                            patientDetailProvider.Profile_path
                                                .toString(),
                                        patientDetailProvider
                                            .nameController.text,
                                        patientDetailProvider
                                            .emailCondroller.text,
                                        patientDetailProvider
                                            .dateOfBirthCondroller.text,
                                        patientDetailProvider.bloodGroup,
                                        patientDetailProvider
                                            .heightController.text,
                                        patientDetailProvider
                                            .weightController.text,
                                        patientDetailProvider.gender);
                                    patientDetailProvider.sharePrefSave();
                                    patientDetailProvider.gender = "";
                                    patientDetailProvider.emailCondroller.text =
                                        "";
                                    patientDetailProvider.nameController.text =
                                        "";
                                    ApiformattedDate = "";
                                    patientDetailProvider.bloodGroup = "";
                                    patientDetailProvider
                                        .heightController.text = "";
                                    patientDetailProvider
                                        .weightController.text = "";
                                    patientDetailProvider.Profile_path = "";
                                    patientDetailProvider
                                        .dateOfBirthCondroller.text = "";
                                    print("--------------");
                                    print(
                                      patientDetailProvider.Profile_path,
                                    );
                                    print(patientDetailProvider
                                        .full_profile_link);
                                    print(patientDetailProvider
                                        .nameController.text);
                                    print(patientDetailProvider
                                        .emailCondroller.text);
                                    print(patientDetailProvider
                                        .dateOfBirthCondroller.text);
                                    print(patientDetailProvider.bloodGroup);
                                    print(patientDetailProvider
                                        .heightController.text);
                                    print(patientDetailProvider
                                        .weightController.text);
                                    print(patientDetailProvider.gender);
                                    print("--------------");
                                    print(value.body);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashboardPatient(
                                                  family_member_id: "",
                                                )));
                                  }
                                });
                              }
                            });
                          }),
                          child: const Text("Submit"))
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}

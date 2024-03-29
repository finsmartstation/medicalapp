import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../providers/verifiyaddFamilyMembersData.dart';
import '../../service/api_services.dart';
import '../../service/patient_api.dart';
import '../../utility/constants.dart';
import 'familyMembersScreen.dart';

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({super.key});

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  TextEditingController nameController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController addresController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode relationFocusNode = FocusNode();
  FocusNode addresFocusNode = FocusNode();
  FocusNode dobFocusNode = FocusNode();
  FocusNode heightFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  String bloodGroup = "";
  String gender = "";
  String profilePath = "";
  String ApiformattedDate = "";
  String userId = '';
  String aToken = '';
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

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
    print(_imageFileList);
  }

  @override
  Widget build(BuildContext context) {
    userId = context.watch<AuthProvider>().u_id;
    aToken = context.watch<AuthProvider>().access_token;
    return Consumer<VerifyAddFamilyMembersData>(
      builder: (context, verifyAddFamilyMembersData, child) {
        return GestureDetector(
          onTap: () {
            setState(() {
              nameFocusNode.unfocus();
              relationFocusNode.unfocus();
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
                    Navigator.pop(context);
                  }),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              title: const Text(
                "Add Family Member profile",
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
                                  child: profilePath.isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                          baseUrl + profilePath,
                                          fit: BoxFit.fill,
                                        ))
                                      : ClipOval(
                                          child: Image.network(
                                          "https://cdn-icons-png.flaticon.com/512/147/147285.png",
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          color: Colors.white),
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          print(profilePath);
                                                          Navigator.pop(
                                                              context);
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
                                                                .then((value) {
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
                                                                          .transform(utf8
                                                                              .decoder)
                                                                          .listen(
                                                                              (event) {
                                                                        var path =
                                                                            jsonDecode(event);
                                                                        setState(
                                                                            () {
                                                                          profilePath =
                                                                              path['file_path'];
                                                                        });

                                                                        print(
                                                                            profilePath);
                                                                      });
                                                                    }
                                                                  },
                                                                );
                                                                // print(
                                                                //     pickedFile.path);

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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          color: Colors.white),
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          print(profilePath);
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                          XFile? pickedFile =
                                                              await _picker
                                                                  .pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                            maxWidth: 1800,
                                                            maxHeight: 1800,
                                                          );
                                                          if (pickedFile !=
                                                              null) {
                                                            cropImage(File(
                                                                    pickedFile
                                                                        .path))
                                                                .then((value) {
                                                              setState(() {
                                                                _setImageFileListFromFile(
                                                                    XFile(value!
                                                                        .path));

                                                                ApiService()
                                                                    .file_upload(
                                                                        userId,
                                                                        aToken,
                                                                        value
                                                                            .path
                                                                            .toString())
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
                                                                          profilePath =
                                                                              path['file_path'];
                                                                        });
                                                                        print(
                                                                            path);
                                                                      });
                                                                    }
                                                                  },
                                                                );
                                                                print(pickedFile
                                                                    .path);

                                                                print(
                                                                    "---------------------------");
                                                              });
                                                            });
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
                    Text(
                      verifyAddFamilyMembersData.verifyprofilePath,
                      style: const TextStyle(color: Colors.red),
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
                    Text(
                      verifyAddFamilyMembersData.verifyName,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
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
                    Text(
                      verifyAddFamilyMembersData.verifyRelation,
                      style: const TextStyle(color: Colors.red),
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
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            print(formattedDate);

                            setState(() {
                              dobController.text = formattedDate;
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      )),
                    ),
                    Text(
                      verifyAddFamilyMembersData.verifyDob,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          focusNode: addresFocusNode,
                          controller: addresController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              icon: Icon(Icons.home_outlined),
                              hintText: "address")),
                    ),
                    Text(
                      verifyAddFamilyMembersData.verifyaddres,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
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
                    Text(
                      verifyAddFamilyMembersData.verifyBlood,
                      style: const TextStyle(color: Colors.red),
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
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        hintText: "Height")),
                              ),
                              Text(
                                verifyAddFamilyMembersData.verifyHight,
                                style: const TextStyle(color: Colors.red),
                              ),
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
                                        hintText: "Weight ")),
                              ),
                              Text(
                                verifyAddFamilyMembersData.verifiyWeight,
                                style: const TextStyle(color: Colors.red),
                              ),
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
                    Text(
                      verifyAddFamilyMembersData.verifyGender,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: (() {
                          print(profilePath);
                          bool namebool = false;
                          bool addressbool = false;
                          bool relationbool = false;
                          bool dobbool = false;
                          bool genderbool = false;
                          bool profilePathbool = false;
                          bool bloodbool = false;
                          bool hightbool = false;
                          bool weightbool = false;
                          if (addresController.text.isEmpty) {
                            verifyAddFamilyMembersData.addresRequired();
                          } else {
                            verifyAddFamilyMembersData.verifyaddres = "";
                            addressbool = true;
                          }
                          if (weightController.text.isEmpty) {
                            verifyAddFamilyMembersData.weight();
                          } else {
                            verifyAddFamilyMembersData.verifiyWeight = "";
                            weightbool = true;
                          }
                          if (heightController.text.isEmpty) {
                            verifyAddFamilyMembersData.hight();
                          } else {
                            verifyAddFamilyMembersData.verifyHight = "";
                            hightbool = true;
                          }
                          if (bloodGroup == "") {
                            verifyAddFamilyMembersData.blood();
                          } else {
                            verifyAddFamilyMembersData.verifyBlood = "";
                            bloodbool = true;
                          }
                          if (profilePath.isEmpty) {
                            verifyAddFamilyMembersData.profilePath();
                          } else {
                            verifyAddFamilyMembersData.verifyprofilePath = "";
                            profilePathbool = true;
                          }
                          if (nameController.text.isEmpty) {
                            verifyAddFamilyMembersData.nameRequired();
                          } else {
                            verifyAddFamilyMembersData.verifyName = "";
                            namebool = true;
                          }

                          if (relationController.text.isEmpty) {
                            verifyAddFamilyMembersData.relationRequired();
                          } else {
                            verifyAddFamilyMembersData.verifyRelation = "";
                            relationbool = true;
                          }
                          if (dobController.text.isEmpty) {
                            verifyAddFamilyMembersData.dobRequired();
                          } else {
                            verifyAddFamilyMembersData.verifyDob = "";
                            dobbool = true;
                          }
                          if (gender.isEmpty) {
                            verifyAddFamilyMembersData.genderRequired();
                          } else {
                            verifyAddFamilyMembersData.verifyGender = "";
                            genderbool = true;
                          }
                          print(relationbool);
                          print(dobbool);
                          print(genderbool);
                          if (weightbool == true &&
                              hightbool == true &&
                              bloodbool == true &&
                              namebool == true &&
                              profilePathbool == true &&
                              relationbool == true &&
                              dobbool == true &&
                              genderbool == true &&
                              addressbool == true) {
                            print("object");
                            PatientApi()
                                .add_family_members(
                                    userId,
                                    aToken,
                                    gender.toString(),
                                    nameController.text,
                                    relationController.text,
                                    ApiformattedDate.toString(),
                                    bloodGroup.toString(),
                                    heightController.text,
                                    weightController.text,
                                    profilePath.toString(),
                                    addresController.text)
                                .then((value) {
                              if (value.statusCode == 200) {
                                var respons = jsonDecode(value.body);
                                String familyMemberId =
                                    respons['family_member_id'].toString();
                                print(respons);
                                print(familyMemberId);
                                showSuccessDialog(context, "Added Successfully",
                                    const FamilyMembersScreen(), "Success");
                              }
                            });
                          }
                        }),
                        child: const Text("Submit"))
                  ],
                )),
          ),
        );
      },
    );
  }
}

void showSuccessDialog(BuildContext context, String message,
    Widget navigationRoute, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        content: Text(message),
      );
    },
  );
  Future.delayed(const Duration(seconds: 1), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => navigationRoute),
    );
  });
}

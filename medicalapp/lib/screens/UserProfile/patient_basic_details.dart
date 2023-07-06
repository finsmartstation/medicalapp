import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/patientNewuserProdileVerifyData.dart';
import '../../providers/patient_provider.dart';
import '../../service/api_services.dart';
import '../../utility/constants.dart';
import '../dashboard/dashboardScreen.dart';
import 'profileApiServices.dart';

class PatientBasicDetails extends StatefulWidget {
  const PatientBasicDetails({super.key});

  @override
  State<PatientBasicDetails> createState() => _PatientBasicDetailsState();
}

class _PatientBasicDetailsState extends State<PatientBasicDetails> {
  List<XFile>? _imageFileList;
  File? imageFile;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = (value == null ? null : <XFile>[value])!;
    // print("File : ${value!.}");
  }

  var emailValidate = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  Location location = Location();
  final bool _serviceEnabled = false;
  bool nameEmpty = false;
  bool emailEmpty = false;
  String gender = "";
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  late Position position;

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String locality = '';
  String feature_name = '';
  String admin_area = '';
 

  var imgUrl;

  String? profilePic;
  String long = "", lat = "";

  SetProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (nameController.text.isNotEmpty) {
      prefs.setString('userName', nameController.text.toString());
    }
    if (emailController.text.isNotEmpty) {
      prefs.setString('email', emailController.text.toString());
    }
    if (profilePic!.isNotEmpty) {
      prefs.setString('profilePicture', profilePic!);
    }
    if (lat.isNotEmpty) {
      prefs.setString('latitude', lat.toString());
    }
    if (long.isNotEmpty) {
      prefs.setString('longitude', long.toString());
    }
    if (gender.isNotEmpty) {
      prefs.setString('gender', gender);
    }
    print("profile path =============");
    print(prefs.getString('profilePicture'));
  }

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition();
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });
  }

  @override
  Widget build(BuildContext context) {
    var patientProvider =
        Provider.of<PatientDetailsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        setState(() {
          nameFocusNode.unfocus();
          emailFocusNode.unfocus();
        });
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Consumer2<AuthProvider, VerifyNewUserProfileData>(
              builder: (context, aValue, verifyNewUserProfileData, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Image.asset(profile_top_gs_Croped, fit: BoxFit.fill),
                  ),
                  Stack(
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            imageFile == null
                                ? Container(
                                    width: 200,
                                    height: 200,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                    ),
                                    child: const Image(
                                      height: 100,
                                      width: 100,
                                      image: NetworkImage(
                                          "https://cdn-icons-png.flaticon.com/512/147/147285.png"),
                                      // fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : Container(
                                    width: 200,
                                    height: 200,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: FileImage(imageFile!),
                                    )),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: MediaQuery.of(context).size.width / 3.5,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              color: Colors.blue.shade900),
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
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          color: Colors.white),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _ImageButton(
                                                          ImageSource.camera);
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
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _ImageButton(
                                                          ImageSource.gallery);
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
                  Center(
                    child: Text(
                      verifyNewUserProfileData.verifyprofile,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: TextField(
                        focusNode: nameFocusNode,
                        controller: nameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          hintText: 'Name',
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(width: 3, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(width: 3, color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(width: 3, color: Colors.grey),
                          ),
                        ),
                        onChanged: (value) => nameController == null
                            ? setState(() {
                                nameEmpty = false;
                              })
                            : setState(
                                () {
                                  nameEmpty = true;
                                },
                              )),
                  ),
                  Text(
                    verifyNewUserProfileData.verifyname,
                    style: const TextStyle(color: Colors.red),
                  ),
                  //SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: TextField(
                        focusNode: emailFocusNode,
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(width: 3, color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(width: 3, color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide:
                                BorderSide(width: 3, color: Colors.grey),
                          ),
                        ),
                        onChanged: (value) => emailController == null
                            ? setState(() {
                                emailEmpty = false;
                              })
                            : setState(
                                () {
                                  emailEmpty = true;
                                },
                              )),
                  ),
                  Text(
                    verifyNewUserProfileData.verifyemail,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 10,
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
                                  gender = value!;
                                }); //selected value
                              }),
                          const Text('Male'),
                          Radio(
                              value: "female",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                }); //selected value
                              }),
                          const Text('Female'),
                          Radio(
                              value: "others",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                }); //selected value
                              }),
                          const Text('Others'),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    verifyNewUserProfileData.verifygender,
                    style: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 14),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                        onPressed: () {
                          bool profilbool = false;
                          bool namebool = false;
                          bool emailbool = false;
                          bool genderbool = false;
                          if (nameController.text.isEmpty) {
                            verifyNewUserProfileData.nameRequired();
                          } else {
                            namebool = true;
                            verifyNewUserProfileData.verifyname = "";
                          }
                          if (emailController.text.isEmpty) {
                            verifyNewUserProfileData.emailRequired();
                          } else {
                            emailbool = true;
                            verifyNewUserProfileData.verifyemail = "";
                          }
                          if (gender.isEmpty) {
                            verifyNewUserProfileData.genderRequird();
                          } else {
                            genderbool = true;
                            verifyNewUserProfileData.verifygender = "";
                          }
                          if (imageFile == null) {
                            verifyNewUserProfileData.profileRequired();
                          } else {
                            profilbool = true;
                            verifyNewUserProfileData.verifyprofile = "";
                          }
                          if (profilbool == true &&
                              namebool == true &&
                              emailbool == true &&
                              genderbool == true) {
                            if (emailValidate.hasMatch(emailController.text)) {
                              ApiService()
                                  .file_upload(aValue.u_id, aValue.access_token,
                                      imageFile!.path)
                                  .then(
                                (value) {
                                  if (value.statusCode == 200) {
                                    value.stream
                                        .transform(utf8.decoder)
                                        .listen((event) {
                                      var path = jsonDecode(event);
                                      profilePic = path['file_path'];
                                      patient_profile_details(
                                              aValue.u_id,
                                              aValue.access_token,
                                              gender,
                                              emailController.text,
                                              nameController.text,
                                              profilePic)
                                          .then(
                                        (value) {
                                          if (value.statusCode == 200) {
                                            print(value.body);
                                            SetProfileData();
                                            patientProvider.newUserProfileFile(
                                                profilePic.toString(),
                                                baseUrl + profilePic!
                                                  ..toString(),
                                                nameController.text.toString(),
                                                emailController.text.toString(),
                                                gender.toString(),
                                                lat.toString(),
                                                long.toString());

                                            patientProvider.sharePrefSave();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        DashboardPatient(
                                                          family_member_id: "",
                                                        ))));
                                          }
                                        },
                                      );
                                      print("path==");
                                      print(path);

                                      print(profilePic);

                                      print("------------------");
                                      print(
                                          patientProvider.emailCondroller.text);
                                      print(patientProvider.full_profile_link);
                                      print(patientProvider.Profile_path);
                                      print(
                                          patientProvider.nameController.text);
                                      print(patientProvider.gender);
                                      print(patientProvider.lat);
                                      print(patientProvider.long);
                                      print("------------------");

                                      //SetProfileData();
                                    });
                                    // profilePic=imgUrl;
                                    // print("profile path ====");
                                    // print(profilePic);
                                  }
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                duration: Duration(milliseconds: 1000),
                                content:
                                    Text('Please enter a valid email address'),
                              ));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            )),
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                              color: nameController.text.isNotEmpty &&
                                      emailController.text.isNotEmpty
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 18),
                        )),
                  )
                ],
              ),
            );
          })),
    );
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

  _ImageButton(ImageSource source) async {
    XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _setImageFileListFromFile(pickedFile);
        File img = File(pickedFile.path);
        cropImage(img).then((value) {
          print(value!.path);
          setState(() {
            imageFile = File(value.path);
            print(imageFile.toString());
          });
        });

        setState(() {
          imageFile = img;
          print(imageFile.toString());
        });
      });
    }
  }
}

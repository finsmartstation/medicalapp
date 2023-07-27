import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:marquee/marquee.dart';
import 'package:medicalapp/helper/helper.dart';
import 'package:medicalapp/screens/nearbyHospitals/nearbyHospital.dart';
import 'package:medicalapp/screens/mapScreen/mapView.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../helper/notification/handileNotification.dart';
import '../../providers/auth_provider.dart';
import '../../utility/constants.dart';
import '../Family Members Screen/familyMembersScreen.dart';
import '../UserProfile/NewUserProfile.dart';
import '../UserProfile/profile.dart';
import '../appointment/appointmentReportScreen.dart';
import '../appointment/my_appointment.dart';
import '../doctorList/doctor_list.dart';
import '../favouriteDoctor/my_doctor.dart';
import '../myCaseHistory/myCaseHistoryScreen.dart';
import '../myReports/myReportDoctorFolder.dart';
import '../startScreen/get_started.dart';
import 'dashboardApiService.dart';
import 'dashboardSearch.dart';

class DashboardPatient extends StatefulWidget {
  String family_member_id = "";

  DashboardPatient({
    Key? key,
    required this.family_member_id,
  }) : super(key: key);

  @override
  State<DashboardPatient> createState() => _DashboardPatientState();
}

class _DashboardPatientState extends State<DashboardPatient>
    with Notifications {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  bool dropDownButton = false;
  String loginStatus = "0";
  String family_member_id = "";
  final PageController _StickerController = PageController(initialPage: 0);

  Future<void> _showDialog() async {
    await Future.delayed(Duration.zero, () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              DateTime preBackpress = DateTime.now();
              final timegap = DateTime.now().difference(preBackpress);
              final cantExit = timegap >= const Duration(seconds: 2);
              preBackpress = DateTime.now();
              if (cantExit) {
                Helpers.showAnimatedScaffoldMessenger(
                    context, 'Press Back button again to Exit');

                return false;
              } else {
                return exit(0);
              }
            },
            child: AlertDialog(
              title: const Text('Your profile is incomplete'),
              content: const Text('please complete your profile for continue.'),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    String a = await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewUserProfile()));
                    if (a == "a") {
                      initState();
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  getProfileData() async {
    setState(() {
      dashboardData(context.read<AuthProvider>().u_id,
              context.read<AuthProvider>().access_token, family_member_id)
          .then((value) {
        if (value.statuscode == 200) {
          if (value.patientDetails.loginStatus == "0") {
            _showDialog();
          } else if (value.slotArray.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) {
                return ListView.builder(
                  itemCount: value.slotArray.length,
                  itemBuilder: (context, index) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: CachedNetworkImage(
                          imageUrl: value.slotArray[index].gif),
                      content: Text(
                          'Doctor ${value.slotArray[index].doctorName} Waiting For Consulting'),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            String a = await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppointmentReport(
                                          familyMemberId: value
                                              .patientDetails.familyMemberId,
                                          slot_id:
                                              value.slotArray[index].slotId,
                                          userName:
                                              value.patientDetails.username,
                                        )));
                            if (a == "a") {
                              initState();
                            }
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
            _showCansaltaionAlerrt();
          }
        }
      });
    });
  }

  _showCansaltaionAlerrt() {}

  //Location location = Location();
  final bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  late Position position;
  String long = "", lat = "";
  bool servicestatus = false;
  bool hasPermission = false;
  String? locationName;
  String localityName = '';
  late LocationPermission permission;
  checkGps() async {
    bool serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (serviceStatus) {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          log('Location permissions are permanently denied');
        } else {
          hasPermission = true;
        }
      } else {
        hasPermission = true;
      }

      if (hasPermission) {
        setState(() {
          // Refresh the UI
        });

        // getLocation();
      }
    } else {
      log('GPS Service is not enabled, turn on GPS location');
    }

    setState(() {
      // Refresh the UI
    });
  }

// getLocation() async {
//   Position position = await Geolocator.getCurrentPosition();
//   log('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
//   lat =position.latitude.toString();
//   long= position.longitude.toString();

//   final coordinates =  Coordinates(position.latitude, position.longitude);
//   List<Address> addresses =
//       await Geocoder.local.findAddressesFromCoordinates(coordinates);

//   if (addresses != null && addresses.isNotEmpty) {
//     Address first = addresses.first;
//     locationName = first.addressLine;
//     localityName = first.locality!;
//    // String? locality = first.featureName;
//     log('Location Name: $locationName');
//     // log('1Location Name: ${first.addressLine}');
//     // log('2Location Name: ${first.adminArea}');
//     // log('3Location Name: ${first.countryName}');
//     // log('4Location Name: ${first.featureName}');
//     // log('5Location Name: ${first.locality}');
//     // log('6Location Name: ${first.subAdminArea}');
//     // log('7Location Name: ${first.subLocality}');
//     // log('8Location Name: ${first.postalCode}');
//     // log('9Location Name: ${first.countryCode}');

//     setState(() {
//       // Update your UI or save the location name
//     });
//   }
// }
  //   checkGps() async {
  //   servicestatus = await Geolocator.isLocationServiceEnabled();
  //   if (servicestatus) {
  //     permission = await Geolocator.checkPermission();

  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         log('Location permissions are denied');
  //       } else if (permission == LocationPermission.deniedForever) {
  //         log("'Location permissions are permanently denied");
  //       } else {
  //         haspermission = true;
  //       }
  //     } else {
  //       haspermission = true;
  //     }

  //     if (haspermission) {
  //       setState(() {
  //         //refresh the UI
  //       });

  //       getLocation();
  //     }
  //   } else {
  //     log("GPS Service is not enabled, turn on GPS location");
  //   }

  //   setState(() {
  //     //refresh the UI
  //   });
  // }

  // getLocation() async {
  //   position = await Geolocator.getCurrentPosition();
  //   log(position.longitude); //Output: 80.24599079
  //   log(position.latitude); //Output: 29.6593457

  //   long = position.longitude.toString();
  //   lat = position.latitude.toString();

  //   setState(() {
  //     //refresh UI
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    family_member_id = widget.family_member_id.toString();
    checkGps();
    getProfileData();
    interactedNotificationMessage();
  }

  @override
  Widget build(BuildContext context) {
    DateTime preBackpress = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(preBackpress);
        final cantExit = timegap >= const Duration(seconds: 2);
        preBackpress = DateTime.now();
        if (cantExit) {
          Helpers.showAnimatedScaffoldMessenger(
              context, 'Press Back button again to Exit');
          return false;
        } else {
          SystemNavigator.pop();
          return false;
        }
      },
      child: FutureBuilder(
        future: dashboardData(context.watch<AuthProvider>().u_id,
            context.watch<AuthProvider>().access_token, family_member_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            family_member_id = snapshot.data!.patientDetails.familyMemberId;
            log(family_member_id);
            return GestureDetector(
              onTap: () {
                if (dropDownButton) {
                  setState(() {
                    dropDownButton = false;
                  });
                }
              },
              child: Scaffold(
                backgroundColor: Colors.grey.shade300,
                appBar: AppBar(
                  backgroundColor: Colors.grey.shade300,
                  leading: Center(
                    child: IconButton(
                        onPressed: () {
                          _scaffoldkey.currentState?.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu_sharp,
                          color: Colors.black,
                        )),
                  ),
                  title: Container(
                    color: Colors.grey.shade300,
                    child: Stack(
                      children: [
                        Positioned(
                            child: SizedBox(
                                height: 50,
                                width: 100,
                                child: Image.asset(
                                  elems,
                                  color: Colors.white,
                                ))),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardSearch(
                                          family_member_id:
                                              widget.family_member_id,
                                        )));
                          },
                          child: Center(
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  ),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Search Doctors, Hospitals Etc...",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              ),
                              // child: TextFormField(
                              //   textInputAction: TextInputAction.search,
                              //   decoration: InputDecoration(
                              //     enabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(30),
                              //         borderSide: const BorderSide(
                              //           color: Colors.grey,
                              //         )),
                              //     focusedBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(25),
                              //         borderSide: BorderSide(color: Colors.blue)),
                              //     suffixIcon: InkWell(
                              //       child: Icon(Icons.search),
                              //     ),
                              //     contentPadding: const EdgeInsets.all(15.0),
                              //     hintText: 'Search Doctors, Hospitals Etc...',
                              //   ),
                              //   onTap: () {},
                              // ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        InkWell(
                            onTap: (() {
                              // checkGps();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapView()));
                              // log(object)
                              // showDialog(
                              // context: context,
                              // builder: (context) {
                              //   return  AlertDialog(
                              //       title: Text("Location"),
                              //       shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.all(Radius.circular(20))),
                              //       content: Text(locationName!),
                              //       actions: [
                              //         ElevatedButton(onPressed:(){
                              //           Navigator.pop(context);
                              //         }, child: Text('Ok'))
                              //       ],
                              //   );
                              //  },
                              // );
                            }),
                            child: Column(
                              children: [
                                ImageIcon(
                                  AssetImage(locs),
                                  color: Colors.blueAccent,
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )
                  ],
                  elevation: 0,
                ),
                key: _scaffoldkey,
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        accountName:
                            Text(snapshot.data!.patientDetails.username),
                        accountEmail:
                            Text(snapshot.data!.patientDetails.emailId),
                        currentAccountPicture: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePatient(
                                          blood: snapshot
                                              .data!.patientDetails.bloodGroup,
                                          dob:
                                              snapshot.data!.patientDetails.dob,
                                          email: snapshot
                                              .data!.patientDetails.emailId,
                                          gender: snapshot
                                              .data!.patientDetails.gender,
                                          height: snapshot
                                              .data!.patientDetails.height,
                                          mobile: snapshot
                                              .data!.patientDetails.mobile,
                                          name: snapshot
                                              .data!.patientDetails.username,
                                          profile: snapshot
                                              .data!.patientDetails.profilePic,
                                          relation: snapshot
                                              .data!.patientDetails.relation,
                                          weight: snapshot
                                              .data!.patientDetails.weight,
                                          familyMemberId: snapshot.data!
                                              .patientDetails.familyMemberId,
                                          half_path: snapshot
                                              .data!.patientDetails.halfPath,
                                        )));
                          },
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                snapshot.data!.patientDetails.profilePic,
                                width: 90,
                                height: 90,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(color: Colors.blue[900]),
                      ),
                      ListTile(
                        leading: const Icon(Icons.family_restroom_rounded),
                        title: const Text("Family Members"),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FamilyMembersScreen())),
                      ),
                      if (snapshot.data!.patientDetails.relation == "self")
                        ListTile(
                          leading: const Icon(Icons.medical_services_outlined),
                          title: const Text("My Doctors"),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyDoctor(
                                        family_member_id: snapshot.data!
                                            .patientDetails.familyMemberId,
                                      ))),
                        ),
                      if (snapshot.data!.patientDetails.gender == "female" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.medical_services_outlined),
                          title: const Text("Her Doctors"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyDoctor(
                                          family_member_id: snapshot.data!
                                              .patientDetails.familyMemberId,
                                        )));
                          },
                        ),
                      if (snapshot.data!.patientDetails.gender == "others" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.medical_services_outlined),
                          title: const Text("Doctors"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyDoctor(
                                          family_member_id: snapshot.data!
                                              .patientDetails.familyMemberId,
                                        )));
                          },
                        ),
                      if (snapshot.data!.patientDetails.gender == "male" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.medical_services_outlined),
                          title: const Text("His Doctors"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyDoctor(
                                          family_member_id: snapshot.data!
                                              .patientDetails.familyMemberId,
                                        )));
                          },
                        ),
                      if (snapshot.data!.patientDetails.relation == "self")
                        ListTile(
                          leading: const Icon(Icons.file_open),
                          title: const Text("My Case History"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MyReports(
                                      family_member_id: snapshot
                                          .data!.patientDetails.familyMemberId),
                                ));
                          },
                        ),
                      if (snapshot.data!.patientDetails.gender == "female" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.file_open),
                          title: const Text("Her Case History"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MyReports(
                                      family_member_id: snapshot
                                          .data!.patientDetails.familyMemberId),
                                ));
                          },
                        ),
                      if (snapshot.data!.patientDetails.gender == "others" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.file_open),
                          title: const Text("Case History"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MyReports(
                                      family_member_id: snapshot
                                          .data!.patientDetails.familyMemberId),
                                ));
                          },
                        ),
                      if (snapshot.data!.patientDetails.gender == "male" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.file_open),
                          title: const Text("His Case History"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MyReports(
                                      family_member_id: snapshot
                                          .data!.patientDetails.familyMemberId),
                                ));
                          },
                        ),
                      if (snapshot.data!.patientDetails.relation == "self")
                        ListTile(
                          leading: const Icon(Icons.book),
                          title: const Text("My Appointment"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAppointment(
                                          family_member_id: snapshot.data!
                                              .patientDetails.familyMemberId,
                                          userName: snapshot
                                              .data!.patientDetails.username,
                                        )));
                          },
                        ),
                      if (snapshot.data!.patientDetails.gender == "female" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.book),
                          title: const Text("Her Appointment"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAppointment(
                                          family_member_id: snapshot.data!
                                              .patientDetails.familyMemberId,
                                          userName: snapshot
                                              .data!.patientDetails.username,
                                        )));
                          },
                        ),
                      if (snapshot.data!.patientDetails.gender == "others" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.book),
                          title: const Text("Appointment"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAppointment(
                                          family_member_id: snapshot.data!
                                              .patientDetails.familyMemberId,
                                          userName: snapshot
                                              .data!.patientDetails.username,
                                        )));
                          },
                        ),
                      if (snapshot.data!.patientDetails.gender == "male" &&
                          snapshot.data!.patientDetails.relation != "self")
                        ListTile(
                          leading: const Icon(Icons.book),
                          title: const Text("His Appointment"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyAppointment(
                                          family_member_id: snapshot.data!
                                              .patientDetails.familyMemberId,
                                          userName: snapshot
                                              .data!.patientDetails.username,
                                        )));
                          },
                        ),
                      ListTile(
                        leading: const Icon(Icons.local_hospital_rounded),
                        title: const Text("Nearby Hospital"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NearbyHospitalList(
                                        lat: lat,
                                        long: lat,
                                      )));
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Log out'),
                        onTap: () async {
                          context.read<AuthProvider>().clearData();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const GetStarted()),
                              (route) => false);
                        },
                      )
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                      Colors.blueAccent,
                                      Colors.blue
                                    ])),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text.rich(
                                            TextSpan(
                                              text: snapshot.data!
                                                  .patientDetails.username,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: const TextStyle(
                                                color: Colors.white),
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: VerticalDivider(
                                          color: Colors.grey.shade300,
                                          width: 10,
                                          thickness: 3,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                            "Blood Group: ${snapshot.data!.patientDetails.bloodGroup}",
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: VerticalDivider(
                                          color: Colors.white,
                                          width: 10,
                                          thickness: 3,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                            "Height: ${snapshot.data!.patientDetails.height}",
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: VerticalDivider(
                                          color: Colors.white,
                                          width: 10,
                                          thickness: 3,
                                          indent: 10,
                                          endIndent: 10,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Text(
                                            "Weight: ${snapshot.data!.patientDetails.weight}",
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 5,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 180,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.blue
                                          ]),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  snapshot.data!.patientDetails
                                                              .loginStatus ==
                                                          "1"
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfilePatient(
                                                                    blood: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .bloodGroup,
                                                                    dob: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .dob,
                                                                    email: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .emailId,
                                                                    gender: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .gender,
                                                                    height: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .height,
                                                                    mobile: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .mobile,
                                                                    name: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .username,
                                                                    profile: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .profilePic,
                                                                    relation: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .relation,
                                                                    weight: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .weight,
                                                                    familyMemberId: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .familyMemberId,
                                                                    half_path: snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .halfPath,
                                                                  )))
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const NewUserProfile()));
                                                },
                                                child: ClipOval(
                                                    child: CachedNetworkImage(
                                                  imageUrl: snapshot
                                                      .data!
                                                      .patientDetails
                                                      .profilePic,
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                )),
                                              ),
                                              snapshot
                                                      .data!
                                                      .patientDetails
                                                      .familyMemberIds[0]
                                                      .familyMemberId
                                                      .isEmpty
                                                  ? const SizedBox()
                                                  : snapshot
                                                              .data!
                                                              .patientDetails
                                                              .familyMemberIds
                                                              .length <
                                                          2
                                                      ? const SizedBox()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 18),
                                                          child: IconButton(
                                                              onPressed: (() {
                                                                if (dropDownButton ==
                                                                    false) {
                                                                  setState(() {
                                                                    dropDownButton =
                                                                        true;
                                                                  });
                                                                }
                                                              }),
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                size: 50,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        )
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                  color: Colors.white,
                                  width: 10,
                                  thickness: 3,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                Flexible(
                                  child: Container(
                                    width: double.infinity,
                                    height: 180,
                                    decoration: const BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20))),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              if (snapshot.data!.patientDetails
                                                      .relation ==
                                                  "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyDoctor(
                                                                          family_member_id: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .familyMemberId,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        "My Doctors",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "female" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyDoctor(
                                                                          family_member_id: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .familyMemberId,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        "Her Doctors",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "others" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyDoctor(
                                                                          family_member_id: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .familyMemberId,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        " Doctors",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "male" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyDoctor(
                                                                          family_member_id: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .familyMemberId,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        "His Doctors",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              const Divider(
                                                color: Colors.white,
                                                height: 5,
                                                thickness: 5,
                                                indent: 0,
                                                endIndent: 0,
                                              ),
                                              if (snapshot.data!.patientDetails
                                                      .relation ==
                                                  "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  MyReportDoctorsFolder(
                                                                family_member_id:
                                                                    snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .familyMemberId,
                                                              ),
                                                            ));
                                                      },
                                                      child: const Text(
                                                        "My Reports",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "female" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  MyReportDoctorsFolder(
                                                                family_member_id:
                                                                    snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .familyMemberId,
                                                              ),
                                                            ));
                                                      },
                                                      child: const Text(
                                                        "Her Reports",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "others" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  MyReportDoctorsFolder(
                                                                family_member_id:
                                                                    snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .familyMemberId,
                                                              ),
                                                            ));
                                                      },
                                                      child: const Text(
                                                        "Reports",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "male" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  MyReportDoctorsFolder(
                                                                family_member_id:
                                                                    snapshot
                                                                        .data!
                                                                        .patientDetails
                                                                        .familyMemberId,
                                                              ),
                                                            ));
                                                      },
                                                      child: const Text(
                                                        "His Reports",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              const Divider(
                                                color: Colors.white,
                                                height: 5,
                                                thickness: 5,
                                                indent: 0,
                                                endIndent: 0,
                                              ),
                                              if (snapshot.data!.patientDetails
                                                      .relation ==
                                                  "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyAppointment(
                                                                          family_member_id: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .familyMemberId,
                                                                          userName: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .username,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        "My Appointment",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "female" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyAppointment(
                                                                          family_member_id: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .familyMemberId,
                                                                          userName: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .username,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        "Her Appointment",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "others" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyAppointment(
                                                                          family_member_id: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .familyMemberId,
                                                                          userName: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .username,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        "Appointment",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              if (snapshot.data!.patientDetails
                                                          .gender ==
                                                      "male" &&
                                                  snapshot.data!.patientDetails
                                                          .relation !=
                                                      "self")
                                                SizedBox(
                                                  height: 56,
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyAppointment(
                                                                          family_member_id: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .familyMemberId,
                                                                          userName: snapshot
                                                                              .data!
                                                                              .patientDetails
                                                                              .username,
                                                                        )));
                                                      },
                                                      child: const Text(
                                                        "His Appointment",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 5,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            snapshot.data!.slotStickers.isEmpty
                                ? const SizedBox()
                                : SizedBox(
                                    height: 100,
                                    width: double.infinity,
                                    child: ListView.builder(
                                      itemCount:
                                          snapshot.data!.slotStickers.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AppointmentReport(
                                                          familyMemberId: snapshot
                                                              .data!
                                                              .patientDetails
                                                              .familyMemberId,
                                                          slot_id: snapshot
                                                              .data!
                                                              .slotStickers[
                                                                  index]
                                                              .slotId,
                                                          userName: snapshot
                                                              .data!
                                                              .patientDetails
                                                              .username,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 100,
                                              width: 380,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Image(
                                                  image: NetworkImage(snapshot
                                                      .data!
                                                      .slotStickers[index]
                                                      .stickers)),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             NearbyHospital()));
                                  },
                                  child: Container(
                                    height: 180,
                                    width: 150,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Colors.blueAccent,
                                              Colors.blue
                                            ]),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: IconButton(
                                              onPressed: (() {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NearbyHospitalList(
                                                              lat: lat,
                                                              long: lat,
                                                            )));
                                              }),
                                              icon: ImageIcon(
                                                AssetImage(
                                                  hospital_icon,
                                                ),
                                                size: 80,
                                                color: Colors.white,
                                              )),
                                        ),
                                        const Text(
                                          " Nearby\n Hospital",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  color: Colors.white,
                                  width: 10,
                                  thickness: 3,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                Flexible(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 125,
                                              height: 85,
                                              decoration: const BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20))),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        snapshot
                                                                    .data!
                                                                    .nearByHospital[
                                                                        0]
                                                                    .hospitalName
                                                                    .length <
                                                                13
                                                            ? Center(
                                                                child: Text(
                                                                  snapshot
                                                                      .data!
                                                                      .nearByHospital[
                                                                          0]
                                                                      .hospitalName,
                                                                ),
                                                              )
                                                            : Center(
                                                                child: SizedBox(
                                                                    height: 40,
                                                                    width: 110,
                                                                    child:
                                                                        Marquee(
                                                                      text: snapshot
                                                                          .data!
                                                                          .nearByHospital[
                                                                              0]
                                                                          .hospitalName,
                                                                      blankSpace:
                                                                          20.0,
                                                                      startPadding:
                                                                          10.0,
                                                                      pauseAfterRound:
                                                                          const Duration(
                                                                              seconds: 1),
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.white,
                                              height: 2,
                                              thickness: 3,
                                              indent: 25,
                                              endIndent: 25,
                                            ),
                                            Container(
                                              width: 125,
                                              height: 85,
                                              decoration: const BoxDecoration(
                                                  color: Colors.blueAccent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  snapshot
                                                              .data!
                                                              .nearByHospital[1]
                                                              .hospitalName
                                                              .length <
                                                          13
                                                      ? Center(
                                                          child: Text(
                                                            snapshot
                                                                .data!
                                                                .nearByHospital[
                                                                    1]
                                                                .hospitalName,
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          height: 40,
                                                          width: 110,
                                                          child: Marquee(
                                                            text: snapshot
                                                                .data!
                                                                .nearByHospital[
                                                                    1]
                                                                .hospitalName,
                                                            // accelerationDuration:
                                                            //     Duration(seconds: 5),
                                                            blankSpace: 20.0,
                                                            startPadding: 10.0,
                                                            pauseAfterRound:
                                                                const Duration(
                                                                    seconds: 1),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(
                                        color: Colors.white,
                                        width: 2,
                                        thickness: 3,
                                        indent: 10,
                                        endIndent: 10,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: 122.41,
                                            height: 85,
                                            decoration: const BoxDecoration(
                                              color: Colors.blueAccent,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                snapshot
                                                            .data!
                                                            .nearByHospital[2]
                                                            .hospitalName
                                                            .length <
                                                        13
                                                    ? Center(
                                                        child: Text(
                                                          snapshot
                                                              .data!
                                                              .nearByHospital[2]
                                                              .hospitalName,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height: 40,
                                                        width: 110,
                                                        child: Marquee(
                                                          text: snapshot
                                                              .data!
                                                              .nearByHospital[2]
                                                              .hospitalName,
                                                          blankSpace: 20.0,
                                                          startPadding: 10.0,
                                                          pauseAfterRound:
                                                              const Duration(
                                                                  seconds: 1),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ))
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.white,
                                            height: 2,
                                            thickness: 3,
                                            indent: 25,
                                            endIndent: 25,
                                          ),
                                          Container(
                                            width: 122.41,
                                            height: 85,
                                            decoration: const BoxDecoration(
                                              color: Colors.blueAccent,
                                            ),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      snapshot
                                                                  .data!
                                                                  .nearByHospital[
                                                                      3]
                                                                  .hospitalName
                                                                  .length <
                                                              13
                                                          ? Center(
                                                              child: Text(
                                                                snapshot
                                                                    .data!
                                                                    .nearByHospital[
                                                                        3]
                                                                    .hospitalName,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )
                                                          : Flexible(
                                                              child: SizedBox(
                                                                  height: 40,
                                                                  width: 110,
                                                                  child:
                                                                      Marquee(
                                                                    text: snapshot
                                                                        .data!
                                                                        .nearByHospital[
                                                                            3]
                                                                        .hospitalName,
                                                                    blankSpace:
                                                                        20.0,
                                                                    startPadding:
                                                                        10.0,
                                                                    pauseAfterRound:
                                                                        const Duration(
                                                                            seconds:
                                                                                1),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  )),
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        color: Colors.white,
                                        width: 2,
                                        thickness: 3,
                                        indent: 10,
                                        endIndent: 10,
                                      ),
                                      // Column(
                                      //   children: [
                                      //     Container(
                                      //       width: 80,
                                      //       height: 85,
                                      //       decoration: BoxDecoration(
                                      //         color: Colors.blueAccent,
                                      //       ),
                                      //       child: Column(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         children: [
                                      //           SizedBox(
                                      //             height: 15,
                                      //           ),
                                      //           Text(
                                      //             snapshot.data!.nearByHospital[4]
                                      //                 .hospitalName,
                                      //             style: TextStyle(
                                      //                 color: Colors.white),
                                      //           )
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     const Divider(
                                      //       color: Colors.white,
                                      //       height: 2,
                                      //       thickness: 0,
                                      //       indent: 25,
                                      //       endIndent: 25,
                                      //     ),
                                      //     Container(
                                      //       width: 80,
                                      //       height: 85,
                                      //       decoration: BoxDecoration(
                                      //         color: Colors.blueAccent,
                                      //       ),
                                      //       child: Column(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         children: [
                                      //           SizedBox(
                                      //             height: 15,
                                      //           ),
                                      //           Text(
                                      //             snapshot.data!.nearByHospital[5]
                                      //                 .hospitalName,
                                      //             style: TextStyle(
                                      //                 color: Colors.white),
                                      //           )
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 5,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            // Row(
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //         // Navigator.push(
                            //         //     context,
                            //         //     MaterialPageRoute(
                            //         //         builder: (context) => NearbyHospital()));
                            //       },
                            //       child: Container(
                            //         height: 180,
                            //         width: 150,
                            //         decoration: const BoxDecoration(
                            //             gradient: LinearGradient(
                            //                 begin: Alignment.topLeft,
                            //                 end: Alignment.bottomLeft,
                            //                 colors: [
                            //                   Colors.blueAccent,
                            //                   Colors.blue
                            //                 ]),
                            //             borderRadius: BorderRadius.only(
                            //                 bottomRight: Radius.circular(20),
                            //                 topRight: Radius.circular(20))),
                            //         child: Column(
                            //           children: [
                            //             SizedBox(
                            //               height: 20,
                            //             ),
                            //             SizedBox(
                            //               height: 80,
                            //               width: 80,
                            //               child: IconButton(
                            //                   onPressed: (() {}),
                            //                   icon: ImageIcon(
                            //                     AssetImage(
                            //                       hospital_icon,
                            //                     ),
                            //                     size: 80,
                            //                     color: Colors.white,
                            //                   )),
                            //             ),
                            //             Text(
                            //               " Nearby\n Pharmacy",
                            //               style: TextStyle(color: Colors.white),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     const VerticalDivider(
                            //       color: Colors.white,
                            //       width: 10,
                            //       thickness: 3,
                            //       indent: 10,
                            //       endIndent: 10,
                            //     ),
                            //     Row(
                            //       children: [
                            //         Column(
                            //           children: [
                            //             Container(
                            //               width: 80,
                            //               height: 85,
                            //               decoration: BoxDecoration(
                            //                   color: Colors.blueAccent,
                            //                   borderRadius: BorderRadius.only(
                            //                       topLeft: Radius.circular(20))),
                            //               child: Column(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 15,
                            //                   ),
                            //                   Text(
                            //                     snapshot.data!.nearByPharmacy[0]
                            //                         .pharmacyName,
                            //                     style: TextStyle(
                            //                         color: Colors.white),
                            //                   )
                            //                 ],
                            //               ),
                            //             ),
                            //             const Divider(
                            //               color: Colors.white,
                            //               height: 2,
                            //               thickness: 3,
                            //               indent: 25,
                            //               endIndent: 25,
                            //             ),
                            //             Container(
                            //               width: 80,
                            //               height: 85,
                            //               decoration: BoxDecoration(
                            //                   color: Colors.blueAccent,
                            //                   borderRadius: BorderRadius.only(
                            //                       bottomLeft:
                            //                           Radius.circular(20))),
                            //               child: Column(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 15,
                            //                   ),
                            //                   Text(
                            //                     snapshot.data!.nearByPharmacy[1]
                            //                         .pharmacyName,
                            //                     style: TextStyle(
                            //                         color: Colors.white),
                            //                   )
                            //                 ],
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         VerticalDivider(
                            //           color: Colors.white,
                            //           width: 2,
                            //           thickness: 3,
                            //           indent: 10,
                            //           endIndent: 10,
                            //         ),
                            //         Column(
                            //           children: [
                            //             Container(
                            //               width: 80,
                            //               height: 85,
                            //               decoration: BoxDecoration(
                            //                 color: Colors.blueAccent,
                            //               ),
                            //               child: Column(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 15,
                            //                   ),
                            //                   Text(
                            //                     snapshot.data!.nearByPharmacy[2]
                            //                         .pharmacyName,
                            //                     style: TextStyle(
                            //                         color: Colors.white),
                            //                   )
                            //                 ],
                            //               ),
                            //             ),
                            //             const Divider(
                            //               color: Colors.white,
                            //               height: 2,
                            //               thickness: 3,
                            //               indent: 25,
                            //               endIndent: 25,
                            //             ),
                            //             Container(
                            //               width: 80,
                            //               height: 85,
                            //               decoration: BoxDecoration(
                            //                 color: Colors.blueAccent,
                            //               ),
                            //               child: Column(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 15,
                            //                   ),
                            //                   Text(
                            //                     snapshot.data!.nearByPharmacy[3]
                            //                         .pharmacyName,
                            //                     style: TextStyle(
                            //                         color: Colors.white),
                            //                   )
                            //                 ],
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         VerticalDivider(
                            //           color: Colors.white,
                            //           width: 2,
                            //           thickness: 3,
                            //           indent: 10,
                            //           endIndent: 10,
                            //         ),
                            //         Column(
                            //           children: [
                            //             Container(
                            //               width: 80,
                            //               height: 85,
                            //               decoration: BoxDecoration(
                            //                 color: Colors.blueAccent,
                            //               ),
                            //               child: Column(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 15,
                            //                   ),
                            //                   Text(
                            //                     snapshot.data!.nearByPharmacy[4]
                            //                         .pharmacyName,
                            //                     style: TextStyle(
                            //                         color: Colors.white),
                            //                   )
                            //                 ],
                            //               ),
                            //             ),
                            //             const Divider(
                            //               color: Colors.white,
                            //               height: 2,
                            //               thickness: 0,
                            //               indent: 25,
                            //               endIndent: 25,
                            //             ),
                            //             Container(
                            //               width: 80,
                            //               height: 85,
                            //               decoration: BoxDecoration(
                            //                 color: Colors.blueAccent,
                            //               ),
                            //               child: Column(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.center,
                            //                 children: [
                            //                   SizedBox(
                            //                     height: 15,
                            //                   ),
                            //                   Text(
                            //                     snapshot.data!.nearByPharmacy[5]
                            //                         .pharmacyName,
                            //                     style: TextStyle(
                            //                         color: Colors.white),
                            //                   )
                            //                 ],
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),

                            // SizedBox(
                            //   height: 10,
                            // ),
                            SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      snapshot.data!.specializationList.length,
                                  itemBuilder: ((context, index) {
                                    return SizedBox(
                                      width: 150,
                                      child: Card(
                                        color: Colors.white,
                                        semanticContainer: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 5,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        margin: const EdgeInsets.all(10),
                                        child: Stack(children: [
                                          InkWell(
                                            onTap: () {
                                              if (index == index) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DoctorList(
                                                              family_member_id: snapshot
                                                                  .data!
                                                                  .patientDetails
                                                                  .familyMemberId,
                                                              splInputSearch: snapshot
                                                                  .data!
                                                                  .specializationList[
                                                                      index]
                                                                  .specialization,
                                                            )));
                                              }
                                            },
                                            child: SizedBox(
                                              height: 150,
                                              child: Image.network(
                                                snapshot
                                                    .data!
                                                    .specializationList[index]
                                                    .imagePath,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              top: 100,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                color: Colors.white,
                                                child: Text(
                                                  snapshot
                                                      .data!
                                                      .specializationList[index]
                                                      .specialization,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ))
                                        ]),
                                      ),
                                    );
                                  })),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 2,
                              thickness: 0,
                              indent: 25,
                              endIndent: 25,
                            ),
                            SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.bannerList.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      height: 200,
                                      width: 250,
                                      child: Card(
                                        color: Colors.white,
                                        semanticContainer: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 5,
                                        shadowColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Image.network(
                                          snapshot
                                              .data!.bannerList[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                              height: 2,
                              thickness: 0,
                              indent: 25,
                              endIndent: 25,
                            ),
                          ]),
                    ),
                    dropDownButton == true
                        ? Positioned(
                            top: 240,
                            child: GestureDetector(
                              onTap: () {
                                if (dropDownButton) {
                                  setState(() {
                                    dropDownButton = false;
                                  });
                                }
                              },
                              child: SizedBox(
                                height: 500,
                                width: 250,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: snapshot.data!.patientDetails
                                        .familyMemberIds.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (index == index) {
                                            setState(() {
                                              family_member_id = snapshot
                                                  .data!
                                                  .patientDetails
                                                  .familyMemberIds[index]
                                                  .familyMemberId;
                                              dropDownButton = false;
                                            });

                                            log(family_member_id);
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 80,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    )),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ClipOval(
                                                          child:
                                                              CachedNetworkImage(
                                                        imageUrl: snapshot
                                                            .data!
                                                            .patientDetails
                                                            .familyMemberIds[
                                                                index]
                                                            .profilePic,
                                                        height: 50,
                                                        width: 50,
                                                        fit: BoxFit.cover,
                                                      )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text.rich(
                                                            TextSpan(
                                                              text: snapshot
                                                                          .data!
                                                                          .patientDetails
                                                                          .familyMemberIds[
                                                                              index]
                                                                          .familyMemberName
                                                                          .length >
                                                                      13
                                                                  ? "${snapshot.data!.patientDetails.familyMemberIds[index].familyMemberName.substring(0, 13)}..."
                                                                  : snapshot
                                                                      .data!
                                                                      .patientDetails
                                                                      .familyMemberIds[
                                                                          index]
                                                                      .familyMemberName,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            softWrap: false,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          // Text(snapshot
                                                          //     .data!
                                                          //     .patientDetails
                                                          //     .familyMemberIds[
                                                          //         index]
                                                          //     .familyMemberName),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(snapshot
                                                              .data!
                                                              .patientDetails
                                                              .familyMemberIds[
                                                                  index]
                                                              .relation)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                color: Colors.transparent,
                                                height: 2,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                // floatingActionButton: FloatingActionButton(
                //   onPressed: (() {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => EmergencyServicesDashboard()));
                //   }),
                //   backgroundColor: Colors.red,
                //   child: Icon(
                //     Icons.sos_outlined,
                //     color: Colors.white,
                //   ),
                // ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Center(
                    child: Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        baseColor: Colors.grey.shade400,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          height: 50,
                          width: 300,
                        )),
                  )),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        baseColor: Colors.grey.shade400,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 50,
                          color: Colors.white,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          direction: ShimmerDirection.ltr,
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 180,
                            width: 150,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 10,
                          thickness: 3,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Shimmer.fromColors(
                          direction: ShimmerDirection.ltr,
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 251,
                            height: 180,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20))),
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 3,
                      indent: 25,
                      endIndent: 25,
                    ),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          direction: ShimmerDirection.ltr,
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                              height: 180,
                              width: 150,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)))),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 10,
                          thickness: 3,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Column(
                          children: [
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 80,
                                height: 85,
                                decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20))),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 2,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 80,
                                height: 85,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20))),
                              ),
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 2,
                          thickness: 3,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Column(
                          children: [
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 80,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 2,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 80,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 2,
                          thickness: 3,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Column(
                          children: [
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 87,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 2,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 87,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      width: 2,
                      thickness: 2,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          direction: ShimmerDirection.ltr,
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                              height: 180,
                              width: 150,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)))),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 10,
                          thickness: 3,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Column(
                          children: [
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 80,
                                height: 85,
                                decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20))),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 2,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 80,
                                height: 85,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20))),
                              ),
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 2,
                          thickness: 3,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Column(
                          children: [
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 80,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 2,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 80,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          width: 2,
                          thickness: 3,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Column(
                          children: [
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 87,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 2,
                              thickness: 3,
                              indent: 25,
                              endIndent: 25,
                            ),
                            Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 87,
                                height: 85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Shimmer.fromColors(
                      direction: ShimmerDirection.ltr,
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade100,
                      child: SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 5,
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: const EdgeInsets.all(10),
                              child: Shimmer.fromColors(
                                direction: ShimmerDirection.ltr,
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade100,
                                child: const SizedBox(
                                  height: 160,
                                  width: 150,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

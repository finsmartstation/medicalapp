import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/patient_api.dart';

class NearbyHospital extends StatefulWidget {
  const NearbyHospital({super.key});

  @override
  State<NearbyHospital> createState() => _NearbyHospitalState();
}

class _NearbyHospitalState extends State<NearbyHospital> {
  String? uName;
  String? email;
  String? profilePic;
  String? PhoneNum;
  String? uid;
  String? aToken;
  String? lat;
  String? long;
  Future ProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uName = prefs.getString("userName").toString();
      email = prefs.getString("email").toString();
      profilePic = prefs.getString("profilePicture").toString();
      PhoneNum = prefs.getString("phoneNum").toString();
      aToken = prefs.getString('accessToken');
      uid = prefs.getString('userId');
    });
    print(prefs.getString("userName").toString());
    print(prefs.getString("email").toString());
    print("------------------");
    print(uid);
    print(aToken);
  }

  var data;
  @override
  void initState() {
    ProfileData();
    // PatientApi().listHospital('33', '0090c0bb33830b11ece5bb6b1b723add').then((value) {
    //   //print(value.body);
    //   if (value.statusCode == 200) {
    //   data = jsonDecode(value.body)['data'];
    //   print("data===$data");
    //   }
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          'Hospital List',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: PatientApi().listHospital(uid, aToken),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                dynamic data = snapshot.data as Map;

                final dynamic hospitalList = data["data"]['data'];
                print('length');
                print(hospitalList.length);
                print('details');
                print(hospitalList);
                print(hospitalList[1]);
                return Expanded(
                  child: ListView.builder(
                      itemCount: hospitalList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        print(index);
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                              radius: 30,
                                              child: ClipOval(
                                                child: Image(
                                                  height: 80,
                                                  width: 80,
                                                  image: hospitalList[index]
                                                              ['profile_pic'] ==
                                                          ''
                                                      ? const CachedNetworkImageProvider(
                                                          "https://cdn-icons-png.flaticon.com/512/147/147285.png")
                                                      : CachedNetworkImageProvider(
                                                          hospitalList[index]
                                                              ['profile_pic']),
                                                  fit: BoxFit.fill,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 5,
                                      height: 100,
                                      decoration:
                                          const BoxDecoration(color: Colors.blue),
                                      child: Column(),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    // SizedBox(width: 20,),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(hospitalList[index]['username']),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(hospitalList[index]['email']),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(hospitalList[index]['mobile']),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              //Image.asset(locs),
                                              //SizedBox(width: 5,),
                                              Text(hospitalList[index]
                                                  ['latitude']),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(hospitalList[index]
                                                  ['longitude'])
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
//           FutureBuilder(
//       future: PatientApi().listHospital('33', '0090c0bb33830b11ece5bb6b1b723add'),
//       builder: (context, snapshot) {
//         print("1234");
//          print(snapshot.data);
//         if (snapshot.hasData) {
//           //var listUsers = snapshot;
//          // print(snapshot);
//           dynamic data = snapshot.data as Map;
//           print(data.length);
//           return  Expanded(
//              child: ListView.builder(
//                       physics: BouncingScrollPhysics(),
//                       itemCount: data.length,
//                       itemBuilder: (context, index) {
//                         return  Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Container(
//               decoration: BoxDecoration(
//                     border: Border.all(color: Colors.blue),
//                     borderRadius: BorderRadius.all(Radius.circular(20))
//                   ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                   Column(
//                     children: [
//                        CircleAvatar(
//                           radius: 30,
//                           child:ClipOval(
//                           child: Image(
//                           height: 80,
//                           width: 80,
//                           image: CachedNetworkImageProvider("https://cdn-icons-png.flaticon.com/512/147/147285.png"
//                            ),
//                             fit: BoxFit.fill,
//                           ),
//                           )
//                       ),
//                     ],
//                   ),
//                  // SizedBox(width: 20,),
//                   Column(
//                     children: [
//                       Text("Hospital Name"),
//                       SizedBox(height: 10,),
//                       Text("Email"),
//                        SizedBox(height: 10,),
//                       Text("Phone No."),
//                       SizedBox(height: 10,),
//                       Row(children: [
//                         //Image.asset(locs),
//                         //SizedBox(width: 5,),
//                         Text("lat"),
//                         SizedBox(width: 5,),
//                         Text("long")
//                       ],)
//                     ],
//                   )
//                 ]),
//                 ),
//               ),
//               );
//             }));
//             }
//             else if(snapshot.hasError){
//               return Container(
//                 child: Text("data1"),
//               );
//             }
//             else {
//     return Center(child: CircularProgressIndicator());
// }

//             }
//           )
        ],
      ),
    );
  }
}

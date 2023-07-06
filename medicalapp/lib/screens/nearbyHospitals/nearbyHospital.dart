import 'package:flutter/material.dart';
import 'package:medicalapp/service/api_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';

class NearbyHospitalList extends StatefulWidget {
  String lat;
  String long;
  NearbyHospitalList({super.key, required this.lat, required this.long});

  @override
  State<NearbyHospitalList> createState() => _NearbyHospitalListState();
}

class _NearbyHospitalListState extends State<NearbyHospitalList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Nearby Hospitals",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
                future: ApiService().getNearbyHospital(
                    context.watch<AuthProvider>().u_id,
                    context.watch<AuthProvider>().access_token,
                    widget.lat,
                    widget.long),
                builder: (context, snapshot) {
                  print(snapshot.hasData);
                  if (snapshot.hasData) {
                    if (snapshot.data!.data.length == 0) {
                      return Center(
                        child: Text('No nearby hospital found'),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    snapshot.data!.data[index].hospitalName),
                              ),
                            );
                          });
                    }
                  }
                  //return Container();
                  // else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  // }
                })),
      ),
    );
  }
}

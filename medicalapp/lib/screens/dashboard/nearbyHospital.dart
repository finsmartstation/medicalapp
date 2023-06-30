import 'package:flutter/material.dart';
import 'package:medicalapp/service/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
class NearbyHospitalList extends StatefulWidget {
  String lat;
  String long;
   NearbyHospitalList({super.key,required this.lat,required this.long});

  @override
  State<NearbyHospitalList> createState() => _NearbyHospitalListState();
}

class _NearbyHospitalListState extends State<NearbyHospitalList> {
   String? access_token;
  String? user_id;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      access_token = prefs.getString('access_token');
      user_id = prefs.getString('user_id');
      print(access_token);
      print(user_id);
      //print(widget.family_member_id);
    });
  }

  @override
  void initState() {
    setState(() {
      getUserData();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return 
         Scaffold(
      appBar:AppBar(
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
          user_id, access_token, widget.lat,widget.long),
      builder: (context, snapshot) {
        print(snapshot.hasData);
        if (snapshot.hasData) {
          if(snapshot.data!.data.length ==0){
            return Center(
              child: Text('No nearby hospital found'),
            );
          }
          else {
            return ListView.builder(
                     shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      snapshot.data!.data.length,
                                  itemBuilder: (context, index){
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(snapshot.data!.data[index].hospitalName),
                                      ),
                                    );
                                  }
                    );
                    }
                    }
                    //return Container();
                    // else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    // }
                    })
                ),
              ),
    );
  }
  }
 
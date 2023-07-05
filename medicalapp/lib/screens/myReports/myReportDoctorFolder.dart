import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';
import '../../providers/auth_provider.dart';
import 'myReportsApiServices.dart';
import 'myReportsDateListing.dart';

class MyReportDoctorsFolder extends StatefulWidget {
 
  String? family_member_id;

  MyReportDoctorsFolder(
      {Key? key,
     
      required this.family_member_id})
      : super(key: key);

  @override
  State<MyReportDoctorsFolder> createState() => _MyReportDoctorsFolderState();
}

class _MyReportDoctorsFolderState extends State<MyReportDoctorsFolder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: consulted_doctors_list(
         context.watch<AuthProvider>().u_id,context.watch<AuthProvider>().access_token, widget.family_member_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data!.data.length==0){
            return Scaffold(
              backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              elevation: 0,
              title: const Text(
                "My Reports",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
            body:Center(
              child: Text('No report found'),
            ) ,
            );
          }
          else {
            return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              elevation: 0,
              title: const Text(
                "My Reports",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 1.1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: snapshot.data!.data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyReportDateFolders(
                                    
                                    doctorId:
                                        snapshot.data!.data[index].doctorId,
                                    family_member_id: widget.family_member_id,
                                   
                                  )));
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image(image: AssetImage(folder)),
                            ),
                            Positioned(
                                top: 15,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.data[index].profilePic),
                                  ),
                                ))
                          ],
                        ),
                        Text(snapshot.data!.data[index].doctorName),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

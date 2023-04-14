import 'package:flutter/material.dart';
import '../../../utility/constants.dart';
import 'myReportsApiServices.dart';
import 'myReportsDateListing.dart';

class MyReportDoctorsFolder extends StatefulWidget {
  String? userId;
  String? access_token;
  String? family_member_id;

  MyReportDoctorsFolder(
      {Key? key,
      required this.userId,
      required this.access_token,
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
          widget.userId, widget.access_token, widget.family_member_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                                    access_token: widget.access_token,
                                    doctorId:
                                        snapshot.data!.data[index].doctorId,
                                    family_member_id: widget.family_member_id,
                                    userId: widget.userId,
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
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

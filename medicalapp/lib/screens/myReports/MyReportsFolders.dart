import 'package:flutter/material.dart';

import '../../utility/constants.dart';

class MyReportFolders extends StatefulWidget {
  String? userId;
  String? access_token;
  String? family_member_id;
  String? doctorId;
  String? dateTime;
  MyReportFolders({
    Key? key,
    required this.userId,
    required this.access_token,
    required this.family_member_id,
    required this.doctorId,
    required this.dateTime,
  }) : super(key: key);

  @override
  State<MyReportFolders> createState() => _MyReportFoldersState();
}

class _MyReportFoldersState extends State<MyReportFolders> {
  List<String> folderName = [
    "Medical Report",
    "Prescription",
    "Diagnosis Report"
  ];
  @override
  Widget build(BuildContext context) {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1.1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                print("object");
              },
              child: Column(
                children: [
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15)),
                    child: Image(image: AssetImage(folder)),
                  ),
                  Text(folderName[index]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

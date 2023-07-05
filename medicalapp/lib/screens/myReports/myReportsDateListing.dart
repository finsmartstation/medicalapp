import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utility/constants.dart';
import 'MyReportsFolders.dart';
import 'myReportsApiServices.dart';

class MyReportDateFolders extends StatefulWidget {
 
  String? family_member_id;
  String? doctorId;
  MyReportDateFolders(
      {Key? key,
     
      required this.family_member_id,
      required this.doctorId})
      : super(key: key);

  @override
  State<MyReportDateFolders> createState() => _MyReportDateFoldersState();
}

class _MyReportDateFoldersState extends State<MyReportDateFolders> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //initialData: 'Loading data...',
      future: consulted_doctors_date_list(context.watch<AuthProvider>().u_id,context.watch<AuthProvider>().access_token,
          widget.family_member_id, widget.doctorId),
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
                              builder: (context) => MyReportFolders(
                                   
                                    dateTime: snapshot
                                        .data!.data[index].addedDatetime
                                        .toString(),
                                    doctorId: widget.doctorId,
                                    family_member_id: widget.family_member_id,
                                    
                                  )));
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
                        Text(DateFormat("dd/MM/yyyy")
                            .format(snapshot.data!.data[index].addedDatetime)),
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

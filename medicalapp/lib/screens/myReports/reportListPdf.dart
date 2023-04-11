import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportListPdf extends StatefulWidget {
  String? userId;
  String? access_token;
  String? family_member_id;
  String? doctorId;
  String? dateTime;
  String? type;
  ReportListPdf({
    Key? key,
    required this.userId,
    required this.access_token,
    required this.family_member_id,
    required this.doctorId,
    required this.dateTime,
    required this.type,
  }) : super(key: key);

  @override
  State<ReportListPdf> createState() => _ReportListPdfState();
}

class _ReportListPdfState extends State<ReportListPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          title: const Text(
            "Report History",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10,
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ListTile(
                      onTap: () {
                        if (index == index) {}
                      },
                      leading: Icon(Icons.picture_as_pdf),
                      trailing: Text(
                        "fghj",
                        // DateFormat("dd/MM/yyyy")
                        //     .format(snapshot.data!.data[index].dateTime),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      title: Text("fghjkdsyhj"),
                    ),
                  ),
                ),
              );
            }));
  }
}

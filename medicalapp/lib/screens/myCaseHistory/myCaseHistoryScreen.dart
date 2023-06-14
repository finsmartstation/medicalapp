import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../providers/reportdataVerify.dart';
import '../../service/api_services.dart';
import 'myCaseHistoryApiService.dart';
import 'myCaseHistoryFileScreen.dart';

class MyReports extends StatefulWidget {
  String? family_member_id;
  MyReports({Key? key, this.family_member_id}) : super(key: key);

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  void timepicker() {}
  TextEditingController reportCondroller = TextEditingController();
  String? access_token;
  String? user_id;

  getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      access_token = prefs.getString('access_token');
      user_id = prefs.getString('user_id');
    });
  }

  @override
  void initState() {
    getProfileData();

    // TODO: implement initState
    super.initState();
  }

  bool showDialogbool = false;

  String _dateee = "Not set";
  String apiDateTimeFormat = "";
  String _time = "Not set";
  String reportPDF = "";
  String file_type = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportDataVerify>(
      builder: (context, vrifydata, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  )),
              title: const Text(
                "   My Medical Case History",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                    onPressed: (() {
                      setState(() {
                        showDialogbool = true;
                      });
                      reportCondroller.text = "";
                      reportPDF = "";
                      vrifydata.documentVerify = "";
                      vrifydata.fileVerify = "";
                      // showDialog(
                      //     context: context,
                      //     builder: ((context) {
                      //       return Consumer<ReportDataVerify>(
                      //         builder: (context, vrifydata, child) {
                      //           return Dialog(
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(10)),
                      //             elevation: 16,
                      //             child:

                      //           );
                      //         },
                      //       );
                      //     }));
                    }),
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ))
              ],
            ),
            body: Stack(
              children: [
                FutureBuilder(
                    future: list_case_history(
                        user_id, access_token, widget.family_member_id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data);
                        return snapshot.data!.data.isEmpty
                            ? const Center(
                                child: Text(
                                "No Case reports",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 10,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            height: 60,
                                            child: ListTile(
                                              onTap: () {
                                                if (index == index) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReportFileScreen(
                                                                filePath: snapshot
                                                                    .data!
                                                                    .data[index]
                                                                    .filePath,
                                                                fileType: snapshot
                                                                    .data!
                                                                    .data[index]
                                                                    .fileType,
                                                              )));
                                                }
                                              },
                                              leading: Icon(snapshot
                                                          .data!
                                                          .data[index]
                                                          .fileType ==
                                                      "pdf"
                                                  ? Icons.picture_as_pdf
                                                  : Icons.image),
                                              trailing: Text(
                                                DateFormat("dd/MM/yyyy").format(
                                                    snapshot.data!.data[index]
                                                        .dateTime),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                              title: Text(
                                                snapshot.data!.data[index]
                                                    .documentName
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: (() {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Delete This Case?"),
                                                      content: const Text(
                                                          "This will delete the File from your Medical Case History?"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text("Cancel"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text("OK"),
                                                          onPressed: () {
                                                            delete_medical_history(
                                                                    user_id,
                                                                    access_token,
                                                                    snapshot
                                                                        .data!
                                                                        .data[
                                                                            index]
                                                                        .id)
                                                                .then((value) {
                                                              if (value
                                                                      .statusCode ==
                                                                  200) {
                                                                setState(() {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text("Deleted Successfully ")));
                                                                });
                                                                print(
                                                                    value.body);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }),
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                });
                      } else {
                        return const Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                        ));
                      }
                    }),
                showDialogbool == true
                    ? Positioned(
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            width: 320,
                            height: 450,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 300,
                                  child: TextField(
                                    controller: reportCondroller,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        hintText: "Document Name"),
                                  ),
                                ),
                                Text(
                                  vrifydata.documentVerify.toString(),
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 300,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      elevation: 4.0,
                                    ),
                                    onPressed: (() {
                                      DatePicker.showDatePicker(context,
                                          theme: const DatePickerTheme(
                                            containerHeight: 210.0,
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 1, 1),
                                          maxTime: DateTime(2022, 12, 31),
                                          onConfirm: (date) {
                                        print('confirm $date');
                                        _dateee =
                                            '${date.year}-${date.month}-${date.day}';
                                        setState(() {});
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    }),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.date_range,
                                                size: 15.0,
                                                color: Colors.blue.shade700,
                                              ),
                                              Text(
                                                " $_dateee",
                                                style: TextStyle(
                                                    color: Colors.blue.shade700,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "  Change",
                                            style: TextStyle(
                                                color: Colors.blue.shade700,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  vrifydata.dates.toString(),
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 300,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      elevation: 4.0,
                                    ),
                                    onPressed: (() {
                                      setState(() {
                                        DatePicker.showTimePicker(context,
                                            theme: const DatePickerTheme(
                                              containerHeight: 210.0,
                                            ),
                                            showSecondsColumn: false,
                                            showTitleActions: true,
                                            onConfirm: (time) {
                                          print('confirm $time');
                                          _time = '${time.hour}:${time.minute}';
                                          setState(() {});
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      });
                                    }),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 15.0,
                                                color: Colors.blue.shade700,
                                              ),
                                              Text(
                                                " $_time",
                                                style: TextStyle(
                                                    color: Colors.blue.shade700,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "  Change",
                                            style: TextStyle(
                                                color: Colors.blue.shade700,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 300,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      setState(() {});
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          'jpg',
                                          'pdf',
                                        ],
                                      );

                                      if (result != null) {
                                        for (var i = 0;
                                            i < result.files.length;
                                            i++) {
                                          var file = result.files[i];
                                          var fileExtension =
                                              file.path!.split('.').last;
                                          if (fileExtension == "jpg") {
                                            file_type = "jpg";
                                          } else if (fileExtension == "pdf") {
                                            file_type = "pdf";
                                          }
                                        }

                                        ApiService()
                                            .file_upload(user_id, access_token,
                                                result.files.single.path)
                                            .then(
                                          (value) {
                                            if (value.statusCode == 200) {
                                              value.stream
                                                  .transform(utf8.decoder)
                                                  .listen((event) {
                                                var path = jsonDecode(event);
                                                reportPDF = path['file_path'];
                                                print(reportPDF);
                                              });
                                            }
                                          },
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    icon: const Text('Upload File '),
                                    label: const Icon(Icons.upload),
                                  ),
                                ),
                                Text(
                                  vrifydata.fileVerify.toString(),
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 100,
                                      child: ElevatedButton(
                                          onPressed: (() {
                                            setState(() {
                                              showDialogbool = false;
                                            });
                                          }),
                                          child: const Text("Close")),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      height: 50,
                                      width: 100,
                                      child: ElevatedButton(
                                          onPressed: (() {
                                            setState(() {
                                              _time == "Not set"
                                                  ? apiDateTimeFormat =
                                                      "$_dateee 00:00:00"
                                                  : apiDateTimeFormat =
                                                      "$_dateee $_time:00";
                                            });
                                            print(apiDateTimeFormat);
                                            bool documentbool = false;
                                            bool filebool = false;
                                            bool datebool = false;
                                            if (_dateee == "Not set") {
                                              vrifydata.date();
                                            } else {
                                              vrifydata.dates = "";
                                              datebool = true;
                                            }
                                            if (reportCondroller.text.isEmpty) {
                                              vrifydata.documentName();
                                            } else {
                                              vrifydata.documentVerify = "";
                                              documentbool = true;
                                            }
                                            if (reportPDF.isEmpty) {
                                              vrifydata.filePdf();
                                            } else {
                                              vrifydata.fileVerify = "";
                                              filebool = true;
                                            }
                                            if (datebool == true &&
                                                documentbool == true &&
                                                filebool == true) {
                                              add_case_history(
                                                      user_id,
                                                      access_token,
                                                      reportCondroller.text,
                                                      reportPDF,
                                                      widget.family_member_id,
                                                      file_type,
                                                      apiDateTimeFormat)
                                                  .then((value) {
                                                if (value.statusCode == 200) {
                                                  reportCondroller.text = "";
                                                  reportPDF = "";
                                                  _dateee = "Not set";
                                                  _time = "Not set";
                                                  print(value.body);

                                                  setState(() {
                                                    showDialogbool = false;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(const SnackBar(
                                                            content: Text(
                                                                "Added Successfully ")));
                                                  });
                                                }
                                              });
                                            }
                                          }),
                                          child: const Text("Submit")),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ));
      },
    );
  }
}

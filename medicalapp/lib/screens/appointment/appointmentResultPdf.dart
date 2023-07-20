import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class AppointmentPdf extends StatefulWidget {
  final String filePath;
  const AppointmentPdf({Key? key, required this.filePath}) : super(key: key);

  @override
  State<AppointmentPdf> createState() => _AppointmentPdfState();
}

class _AppointmentPdfState extends State<AppointmentPdf> {
  String notifiationName = '';

  Future<void> checkPermissionAndDownloadFile(
      String url, String filename, context) async {
    filename = Uri.parse(widget.filePath).pathSegments.last;
    notifiationName = filename;
    print(notifiationName);
    var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   status = await Permission.storage.request();
    //   if (!status.isGranted) {
    //     await downloadFile(url, filename, context);
    //     // Handle permission denied case
    //     return;
    //   }
    // }
    if (!status.isGranted) {
      status = await Permission.storage.request();
      print(status.isGranted);
      // if (status.isGranted) {
      //   await downloadFile(url, filename, context);
      //   showNotification(notifiationName, 'Download complete');
      //   // Handle permission denied case
      //   return;
      // }
    }
    if (status.isGranted) {
      print("granted");
      await downloadFile(url, filename, context);
      showNotification(notifiationName, 'Download complete');
      // Handle permission denied case
      return;
    }
  }

  Future<File> downloadFile(String url, String filename, context) async {
    final response = await http.get(Uri.parse(widget.filePath));
    final bytes = response.bodyBytes;
    final file = File('/storage/emulated/0/Download/$filename');
    await file.writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloaded file to ${file.path}'),
      ),
    );
    return file;
  }

  Future<void> showNotification(String title, String body) async {
    // await AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: 66,
    //     channelKey: 'downloaded_pdf',
    //     title: title,
    //     body: body,
    //   ),
    // );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (() async {
                checkPermissionAndDownloadFile(
                        widget.filePath, widget.filePath, context)
                    .then((value) {
                  //showNotification(notifiationName, 'Download complete');
                });
                // downloadFile(widget.filePath);
              }),
              icon: const Icon(
                Icons.download,
                color: Colors.black,
              ))
        ],
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text(
          "File",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SfPdfViewer.network(widget.filePath.toString()),
    );
  }

  // Future<void> downloadFile(String url) async {
  //   final dir = await getExternalStorageDirectory();
  //   const downloadDir = '/storage/emulated/0/Download/';
  //   await Directory(downloadDir).create(recursive: true);
  //   final fileName = url.split('/').last;
  //   final savePath = '$downloadDir/$fileName';

  //   final dio = Dio();
  //   final response = await dio.download(url, savePath);
  //   if (response.statusCode == 200) {
  //     print(savePath);
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return const AlertDialog(
  //           title: Text("Success"),
  //           titleTextStyle: TextStyle(
  //               fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
  //           backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(20))),
  //           content: Text("File downloaded successfully"),
  //         );
  //       },
  //     );
  //     print('File downloaded successfully');
  //   } else {
  //     print('Failed to download file');
  //   }
  // }
}

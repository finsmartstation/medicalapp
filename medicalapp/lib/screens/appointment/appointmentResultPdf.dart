import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AppointmentPdf extends StatefulWidget {
  final String filePath;
  const AppointmentPdf({Key? key, required this.filePath}) : super(key: key);

  @override
  State<AppointmentPdf> createState() => _AppointmentPdfState();
}

class _AppointmentPdfState extends State<AppointmentPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (() async {
                downloadFile(widget.filePath);
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

  Future<void> downloadFile(String url) async {
    final dir = await getExternalStorageDirectory();
    const downloadDir = '/storage/emulated/0/Download/';
    await Directory(downloadDir).create(recursive: true);
    final fileName = url.split('/').last;
    final savePath = '$downloadDir/$fileName';

    final dio = Dio();
    final response = await dio.download(url, savePath);
    if (response.statusCode == 200) {
      print(savePath);
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Success"),
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Text("File downloaded successfully"),
          );
        },
      );
      print('File downloaded successfully');
    } else {
      print('Failed to download file');
    }
  }
}

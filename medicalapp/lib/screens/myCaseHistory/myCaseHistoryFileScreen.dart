import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReportFileScreen extends StatefulWidget {
  String? fileType;
  String? filePath;
  ReportFileScreen({Key? key, this.fileType, this.filePath}) : super(key: key);
  @override
  _ReportFileScreenState createState() => _ReportFileScreenState();
}

class _ReportFileScreenState extends State<ReportFileScreen> {
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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text(
          "File",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: widget.fileType == "jpg"
          ? Center(child: Image.network(widget.filePath.toString()))
          : SfPdfViewer.network(widget.filePath.toString()),
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../providers/auth_provider.dart';
import 'package:path/path.dart' as path;

import '../../../utility/constants.dart';

class Chat extends StatefulWidget {
  final String roomID;
  final String profilePic;
  final String doctorName;
  Chat(
      {Key? key,
      required this.doctorName,
      required this.roomID,
      required this.profilePic})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  CollectionReference roomData =
      FirebaseFirestore.instance.collection('chatList');
  final _messageController = TextEditingController();
  final scrollController = ScrollController();
  List<int> selectedIndex = [];
  List<String> selectMessage = [];
  File? selectedImage;
  File? selectedFile;
  bool isUploading = false;
  int messageId = 0;
  AuthProvider auth({required bool renderUI}) =>
      Provider.of<AuthProvider>(context, listen: renderUI);
  @override
  void dispose() {
    _messageController.dispose();
    scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatList')
                .doc(widget.roomID)
                .collection("messages")
                .orderBy(
                  'time',
                )
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text('No Chats',
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        messageId = snapshot.data!.docs.length + 1;
                        if (!snapshot.data!.docs[index]['status']) {
                          return SizedBox();
                        } else {
                          if (snapshot.data!.docs[index]['type'] == "text") {
                            return chatMessages(snapshot, index);
                          } else if (snapshot.data!.docs[index]['type'] ==
                              'image') {
                            return imageSection(snapshot, index, context);
                          } else if (snapshot.data!.docs[index]['type'] ==
                              'pdf') {
                            return pdfSection(snapshot, index, context);
                          } else {
                            return SizedBox();
                          }
                        }
                      },
                    ),
                  );
                }
              } else {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
            },
          ),
          messagingFiled(),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          if (selectedIndex.isEmpty) {
            Navigator.pop(context);
          } else {
            setState(() {
              selectedIndex = [];
              selectMessage = [];
            });
          }
        },
      ),
      backgroundColor: Colors.blue,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.profilePic),
          ),
          SizedBox(width: 8),
          Text(
            widget.doctorName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.white,
              fontFamily: "Roboto",
            ),
          ),
        ],
      ),
      actions: [
        selectedIndex.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _copyToClipboard(context);
                  print(selectedIndex.toString());
                },
                icon: Icon(Icons.copy))
            : SizedBox(),
        // IconButton(
        //   icon: Icon(Icons.videocam),
        //   onPressed: () {
        //   },
        // ),
        // IconButton(
        //   icon: Icon(Icons.phone),
        //   onPressed: () {
        //   },
        // ),
      ],
    );
  }

  Padding messagingFiled() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: _selectImage,
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                    )),
                GestureDetector(
                  onTap: _selectFile,
                  child: Icon(Icons.attach_file, color: Colors.white),
                ),
                isUploading
                    ? CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      )
                    : IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: sendButton),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListTile pdfSection(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index,
      BuildContext context) {
    return ListTile(
      title: Align(
        alignment: !snapshot.data!.docs[index]['doctor']
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selectedIndex.contains(index)
                ? Colors.grey.shade900
                : !snapshot.data!.docs[index]['doctor']
                    ? Colors.transparent
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () {
              _showPDFInBig(
                  context, snapshot.data!.docs[index]['message'].toString());
            },
            child: SvgPicture.asset(
              pdfIcon,
              height: 250,
            ),
          ),
        ),
      ),
    );
  }

  ListTile imageSection(AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      int index, BuildContext context) {
    return ListTile(
      title: Align(
        alignment: !snapshot.data!.docs[index]['doctor']
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selectedIndex.contains(index)
                ? Colors.grey.shade900
                : !snapshot.data!.docs[index]['doctor']
                    ? Colors.blue
                    : Colors.grey[600],
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () {
              _showImageInBig(
                  context, snapshot.data!.docs[index]['message'].toString());
            },
            child: Image.network(
              snapshot.data!.docs[index]['message'].toString(),
              cacheHeight: 260,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showImageInBig(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }

  void _showPDFInBig(BuildContext context, String PDFUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SfPdfViewer.network(PDFUrl),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadFile(File file) async {
    try {
      setState(() {
        isUploading = true;
      });
      Uint8List filePath = await file.readAsBytes();
      if (file == null) return null;
      String fileName = path.basename(file.path);
      await FirebaseStorage.instance.ref().child(fileName).putData(filePath);
      String downloadURL =
          await FirebaseStorage.instance.ref().child(fileName).getDownloadURL();
      return downloadURL;
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      log("Error uploading file: $e");
      return null;
    }
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: selectMessage.join('    ')));
    setState(() {
      selectedIndex = [];
      selectMessage = [];
    });
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      selectedFile = File(
        result.files.single.path!,
      );
      String fileName = path.basename(
        result.files.single.path!,
      );
      String fileType = path.extension(fileName).toLowerCase();
      String? uploadedFilePath =
          await uploadFile(File(result.files.single.path!));
      roomData.doc(widget.roomID).collection('messages').add({
        'message': uploadedFilePath,
        'time': DateTime.now(),
        'doctor': false,
        'type': fileType == '.pdf' ? 'pdf' : 'image',
        'id': messageId,
        'userId': auth(renderUI: false).u_id,
        'status': true,
      }).then((value) {
        setState(() {
          isUploading = false;
          uploadedFilePath = '';
        });
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      String? uploadedFilePath = await uploadFile(File(pickedImage.path));
      roomData.doc(widget.roomID).collection('messages').add({
        'message': uploadedFilePath,
        'time': DateTime.now(),
        'doctor': false,
        'type': 'image',
        'id': messageId,
        'userId': auth(renderUI: false).u_id,
        'status': true,
      }).then((value) {
        setState(() {
          isUploading = false;
          uploadedFilePath = '';
        });
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  sendButton() {
    if (_messageController.text.isNotEmpty) {
      roomData.doc(widget.roomID).collection('messages').add({
        'message': _messageController.text,
        'time': DateTime.now(),
        'doctor': false,
        'type': 'text',
        'id': messageId,
        'userId': auth(renderUI: false).u_id,
        'status': true,
      }).then((value) {
        _messageController.clear();
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  InkWell chatMessages(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) {
    return InkWell(
      enableFeedback: false,
      onLongPress: () {
        setState(() {
          if (selectedIndex.contains(index)) {
            selectedIndex.remove(index);
            selectMessage.remove(
              snapshot.data!.docs[index]['message'].toString(),
            );
          } else {
            selectedIndex.add(index);
            selectMessage.add(
              snapshot.data!.docs[index]['message'].toString(),
            );
          }
        });
      },
      child: ListTile(
        title: Align(
          alignment: !snapshot.data!.docs[index]['doctor']
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedIndex.contains(index)
                  ? Colors.grey.shade900
                  : !snapshot.data!.docs[index]['doctor']
                      ? Colors.blue
                      : Colors.grey[600],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              snapshot.data!.docs[index]['message'].toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

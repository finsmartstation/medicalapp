import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class Chat extends StatefulWidget {
  String roomID;
  final String doctorName;
  Chat({Key? key, required this.doctorName, required this.roomID})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  CollectionReference roomData =
      FirebaseFirestore.instance.collection('chatList');

  final _textController = TextEditingController();
  final scrollController = ScrollController();
  int messageId = 0;
  AuthProvider auth({required bool renderUI}) =>
      Provider.of<AuthProvider>(context, listen: renderUI);
  @override
  void dispose() {
    _textController.dispose();
    scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        elevation: 0,
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatList')
                .doc(widget.roomID)
                .collection("messages")
                .orderBy('time')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.docs.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Text('No Chats',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            messageId = snapshot.data!.docs.length + 1;
                            return !snapshot.data!.docs[index]['status']
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment:
                                        !snapshot.data!.docs[index]['doctor']
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 300),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(20.0),
                                            topRight:
                                                const Radius.circular(20.0),
                                            bottomLeft: !snapshot
                                                    .data!.docs[index]['doctor']
                                                ? const Radius.circular(20.0)
                                                : Radius.zero,
                                            bottomRight: !snapshot
                                                    .data!.docs[index]['doctor']
                                                ? Radius.zero
                                                : const Radius.circular(20.0),
                                          ),
                                          color: !snapshot.data!.docs[index]
                                                  ['doctor']
                                              ? Colors.lightBlueAccent
                                              : Colors.grey[300],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                !snapshot.data!.docs[index]
                                                        ['doctor']
                                                    ? 'You'
                                                    : widget.doctorName,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                snapshot.data!
                                                    .docs[index]['message']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      roomData.doc(widget.roomID).collection('messages').add({
                        'message': _textController.text,
                        'time': DateTime.now(),
                        'doctor': false,
                        'type': 'text',
                        'id': messageId,
                        'userId': auth(renderUI: false).u_id,
                        'status': true,
                      }).then((value) {
                        _textController.clear();
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

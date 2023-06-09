import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _textController = TextEditingController();
  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: 'How was the concert?',
      isCurrentUser: false,
    ),
    const ChatMessage(
      text: 'Awesome! Next time you gotta come as well!',
      isCurrentUser: true,
    ),
    const ChatMessage(
      text: 'Ok, when is the next date?',
      isCurrentUser: false,
    ),
    const ChatMessage(
      text: 'They\'re playing on the 20th of November',
      isCurrentUser: true,
    ),
    const ChatMessage(
      text: 'Let\'s do it!',
      isCurrentUser: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<bool> isMe = [true, false, true, false, true];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: isMe.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: isMe[index]
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      margin:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0),
                          bottomLeft:
                              isMe[index] ? const Radius.circular(30.0) : Radius.zero,
                          bottomRight:
                              isMe[index] ? Radius.zero : const Radius.circular(30.0),
                        ),
                        color: isMe[index]
                            ? Colors.lightBlueAccent
                            : Colors.grey[300],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Hello hyy hdjjjjj fghhhhhhhhhh dfxgbzn",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                            //SizedBox(height: 5.0),
                            // Align(
                            //   alignment: isMe[index] == false
                            //       ? Alignment.bottomRight
                            //       : Alignment.bottomLeft,
                            //   child: Text(
                            //     "12PM",
                            //     style: TextStyle(
                            //       fontSize: 12.0,
                            //       color: Colors.black54,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
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
                    final message = ChatMessage(
                      text: _textController.text,
                      isCurrentUser: true,
                    );

                    setState(() {
                      _messages.add(message);
                    });

                    _textController.clear();
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

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isCurrentUser,
  });

  final String text;
  final bool isCurrentUser;
}

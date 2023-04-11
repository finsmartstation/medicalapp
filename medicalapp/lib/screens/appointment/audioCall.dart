import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioCall extends StatefulWidget {
  final String roomID;
  final String userName;

  AudioCall({Key? key, required this.roomID, required this.userName})
      : super(key: key);

  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: 1064206861,
        appSign:
            "c9b303bce2e3718d907de20b60344d39131e72dadecb16bee876220b3135e573",
        userID: 'user_id',
        userName: widget.userName,
        callID: widget.roomID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
          ..onHangUpConfirmation = (BuildContext context) async {
            return await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.blue[900]!.withOpacity(0.9),
                  title: const Text("Leave the conference",
                      style: TextStyle(color: Colors.white70)),
                  content: const Text("Are you sure to leave the conference?",
                      style: TextStyle(color: Colors.white70)),
                  actions: [
                    ElevatedButton(
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.white70)),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    ElevatedButton(
                      child: const Text("Exit"),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                );
              },
            );
          }
        );
  }
}

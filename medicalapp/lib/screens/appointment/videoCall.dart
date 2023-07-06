import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;
  final String user_name;
  final String userId;

  const VideoConferencePage(
      {Key? key,
      required this.userId,
      required this.conferenceID,
      required this.user_name})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<ZegoMenuBarButtonName> buttons = const [
      ZegoMenuBarButtonName.showMemberListButton,
      ZegoMenuBarButtonName.switchCameraButton,
    ];
    final String localUserID = math.Random().nextInt(10000).toString();
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 218650000,
        appSign:
            "b53dcf0e0dca8156843a8485b0d20a12d1d8531f77867c149980906bbed40e4f",
        userID: localUserID,
        userName: user_name,
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
            audioVideoViewConfig: ZegoPrebuiltAudioVideoViewConfig(
              showAvatarInAudioMode: true,
              useVideoViewAspectFill: true,
              showCameraStateOnView: true,
              showMicrophoneStateOnView: true,
              showSoundWavesInAudioMode: true,
              showUserNameOnView: true,
              isVideoMirror: false,
            ),
            topMenuBarConfig: ZegoTopMenuBarConfig(buttons: buttons),
            bottomMenuBarConfig: ZegoBottomMenuBarConfig(
              hideAutomatically: false,
              hideByClick: true,
            ),
            onLeaveConfirmation: (BuildContext context) async {
              return await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.blue.shade700,
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
            }),
      ),
    );
  }
}

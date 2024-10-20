// import 'package:flutter/material.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
// import 'package:gdd_service/upload_compressed_video.dart';
// import 'common_functions.dart';
//
// class MainView extends StatefulWidget {
//   const MainView({super.key});
//
//   @override
//   _MainViewState createState() => _MainViewState();
// }
//
// class _MainViewState extends State<MainView> {
//   bool recording = false;
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//       !recording ? Center(child: ElevatedButton(child: const Text("Record Screen"), onPressed: () => startScreenRecord(false))) : Container(),
//       !recording
//           ? Center(child: ElevatedButton(child: const Text("Record Screen & audio"), onPressed: () => startScreenRecord(true)))
//           : Center(child: ElevatedButton(child: const Text("Stop Record"), onPressed: () => stopScreenRecord()))
//     ]));
//   }
//
//   startScreenRecord(bool audio) async {
//     String uniqueTitle = await getUniqueTitle("Vid");
//     bool start = false;
//     if (audio) {
//       start = await FlutterScreenRecording.startRecordScreenAndAudio(uniqueTitle);
//     } else {
//       start = await FlutterScreenRecording.startRecordScreen(uniqueTitle);
//     }
//     if (start) {
//       setState(() => recording = !recording);
//     }
//     return start;
//   }
//
//   stopScreenRecord() async {
//     String path = await FlutterScreenRecording.stopRecordScreen;
//     setState(() {
//       recording = !recording;
//     });
//     uploadCompressedVideo(path);
//   }
// }


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:gdd_service/upload_compressed_video.dart';
import 'common_functions.dart';
import 'noti/noti_service.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool recording = false;
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    requestPermissions();

    // Initialize Firebase Messaging
    _firebaseMessaging = FirebaseMessaging.instance;

    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleNotification(message);
    });

    // Listen for background or terminated state messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotification(message);
    });

    // Get the initial message when the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        handleNotification(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !recording
              ? Center(child: ElevatedButton(child: const Text("SEND NOTI"), onPressed: () {


            sendNotification(
              title: 'Screen Recording',
              body: 'Screen recording has started!',
              audio: 'true', // or 'false' depending on your requirement
            );

          }))
              : Container(),
          !recording
              ? Center(child: ElevatedButton(child: const Text("Record Screen"), onPressed: () => startScreenRecord(false)))
              : Container(),
          !recording
              ? Center(child: ElevatedButton(child: const Text("Record Screen & audio"), onPressed: () => startScreenRecord(true)))
              : Center(child: ElevatedButton(child: const Text("Stop Record"), onPressed: () => stopScreenRecord()))
        ],
      ),
    );
  }

  void handleNotification(RemoteMessage message) {
    // Extract data from the message
    Map<String, dynamic> data = message.data;

    if (data.containsKey('record') && data['record'] == 'start') {
      // Trigger screen recording
      bool audio = data['audio'] == 'true' ? true : false;
      startScreenRecord(audio);
    } else if (data.containsKey('record') && data['record'] == 'stop') {
      // Stop screen recording
      stopScreenRecord();
    }
  }

  startScreenRecord(bool audio) async {
    String uniqueTitle = await getUniqueTitle("Vid");
    bool start = false;
    if (audio) {
      start = await FlutterScreenRecording.startRecordScreenAndAudio(uniqueTitle);
    } else {
      start = await FlutterScreenRecording.startRecordScreen(uniqueTitle);
    }
    if (start) {
      setState(() => recording = !recording);
    }
    return start;
  }

  Future<void> stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      recording = !recording;
    });
    uploadCompressedVideo(path);
  }
}

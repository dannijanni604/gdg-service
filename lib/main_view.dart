import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:gdd_service/noti/notification_service.dart';
import 'package:gdd_service/upload_compressed_video.dart';
import 'package:gdd_service/users_view.dart';
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
  NotiService notiService = NotiService();

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !recording
              ? Center(
                  child: ElevatedButton(
                      child: const Text("SEND NOTI to spec"),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UsersView()));
                      }))
              : Container(),
          !recording ? Center(child: ElevatedButton(child: const Text("Record Screen"), onPressed: () => startScreenRecord(false))) : Container(),
          !recording
              ? Center(child: ElevatedButton(child: const Text("Record Screen & audio"), onPressed: () => startScreenRecord(true)))
              : Center(child: ElevatedButton(child: const Text("Stop Record"), onPressed: () => stopScreenRecord()))
        ],
      ),
    );
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

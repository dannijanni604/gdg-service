import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:gdd_service/upload_compressed_video.dart';
import 'package:quiver/async.dart';
import 'package:permission_handler/permission_handler.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool recording = false;
  int _time = 0;

  requestPermissions() async {
    if (await Permission.storage.request().isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.photos.request().isDenied) {
      await Permission.photos.request();
    }
    if (await Permission.microphone.request().isDenied) {
      await Permission.microphone.request();
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    startTimer();
  }

  void startTimer() {
    CountdownTimer countDownTimer = CountdownTimer(
      const Duration(seconds: 1000),
      const Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() => _time++);
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Screen Recording'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Time: $_time\n'),
            !recording
                ? Center(
              child: ElevatedButton(
                child: const Text("Record Screen"),
                onPressed: () => startScreenRecord(false),
              ),
            )
                : Container(),
            !recording
                ? Center(
              child: ElevatedButton(
                child: const Text("Record Screen & audio"),
                onPressed: () => startScreenRecord(true),
              ),
            )
                : Center(
              child: ElevatedButton(
                child: const Text("Stop Record"),
                onPressed: () => stopScreenRecord(),
              ),
            )
          ],
        ),
      ),
    );
  }

  startScreenRecord(bool audio) async {
    bool start = false;

    if (audio) {
      start = await FlutterScreenRecording.startRecordScreenAndAudio("Title");
    } else {
      start = await FlutterScreenRecording.startRecordScreen("Title");
    }
    if (start) {
      setState(() => recording = !recording);
    }
    return start;
  }
  stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      recording = !recording;
    });
    uploadCompressedVideo(path);
  }
}


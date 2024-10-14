import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:gdd_service/upload_compressed_video.dart';
import 'package:path_provider/path_provider.dart';

import 'common_functions.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool recording = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Screen Recording'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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

  stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      recording = !recording;
    });
    uploadCompressedVideo(path);
  }
}

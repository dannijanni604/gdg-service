import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:gdd_service/utils/upload_compressed_video.dart';
import 'common_functions.dart';

startScreenRecord(bool audio) async {
  String uniqueTitle = await getUniqueTitle("Vid");
  if (audio) {
    await FlutterScreenRecording.startRecordScreenAndAudio(uniqueTitle);
  } else {
    await FlutterScreenRecording.startRecordScreen(uniqueTitle);
  }
}

Future<void> stopScreenRecord() async {
  String path = await FlutterScreenRecording.stopRecordScreen;
  uploadCompressedVideo(path);
}

import 'dart:async';
import 'package:android_id/android_id.dart';
import 'package:gdd_service/auth/auth_functions.dart';
import 'package:gdd_service/utils/common_functions.dart';
import 'package:gdd_service/utils/video_compressor.dart';
import 'package:http/http.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';
import '../google/google_services.dart';

List<String> uploadQueue = [];

Future<void> uploadCompressedVideo(String path) async {
  String? compressedPath;
  MediaInfo? compressedVideo = await compressVideo(path);

  if (compressedVideo != null && compressedVideo.path != null) {
    compressedPath = compressedVideo.path!;

    if (await checkInternet()) {
      await processUpload(compressedPath);
    } else {
      print("No internet, adding video to the queue");
      uploadQueue.add(compressedPath);
    }
  } else {
    print("Compression failed, not uploading.");
  }
}

void checkAndUploadPendingVideos() async {
  String? deviceId = await const AndroidId().getId();
  String userRole='';
  if (deviceId != null) {
     userRole = await getUserRole(deviceId);
  }
  if(userRole=='user'){
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (await checkInternet() && uploadQueue.isNotEmpty) {
        print("Internet available, uploading queued videos...");
        while (uploadQueue.isNotEmpty) {
          String videoPath = uploadQueue.removeAt(0);
          await processUpload(videoPath);
        }
      } else {
        print("No internet or queue is empty.");
      }
    });
  }else{
    print("User is Admin");
  }


}

Future<void> processUpload(String compressedPath) async {
  GoogleDriveService driveService = GoogleDriveService();
  await driveService.uploadFileToDrive(compressedPath);
  await deleteVideo(compressedPath);
}

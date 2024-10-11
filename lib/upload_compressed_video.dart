import 'package:gdd_service/video_compressor.dart';
import 'package:video_compress/video_compress.dart';

import 'google_services.dart';

Future uploadCompressedVideo(path)async{
  String? compressedPath;
  MediaInfo? compressedVideo = await compressVideo(path);
  if (compressedVideo != null && compressedVideo.path != null) {
    compressedPath = compressedVideo.path!;
    GoogleDriveService driveService = GoogleDriveService();
    await driveService.uploadFileToDrive(compressedPath);
  } else {
    print("Compression failed, not uploading.");
  }
}
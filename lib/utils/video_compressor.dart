import 'package:video_compress/video_compress.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

Future<MediaInfo?> compressVideo(String filePath) async {
  String dir = path.dirname(filePath);
  String fileName = path.basename(filePath);

  final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
    filePath,
    quality: VideoQuality.MediumQuality,
    deleteOrigin: true,
    includeAudio: true,
  );

  if (compressedVideo != null && compressedVideo.path != null) {
    String newFilePath = path.join(dir, fileName);
    File compressedFile = File(compressedVideo.path!);
    compressedFile = await compressedFile.rename(newFilePath);
    return MediaInfo(path: newFilePath, duration: compressedVideo.duration, filesize: compressedVideo.filesize);
  }
  return null;
}

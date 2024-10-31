import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

requestPermissions() async {
  if (await Permission.storage.request().isDenied) {
    await Permission.storage.request();
  }
  if (  await Permission.phone.status.isDenied) {
    await Permission.phone.request();
  }

  if (await Permission.photos.request().isDenied) {
    await Permission.photos.request();
  }
  if (await Permission.microphone.request().isDenied) {
    await Permission.microphone.request();
  }
}


Future<bool> checkInternet()  async{
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    }
  } on SocketException catch (_) {
    print('not connected');
    return false;
  }
  return false;
}


Future<String> getUniqueTitle(String baseTitle) async {
  final directory = await getTemporaryDirectory();
  String directoryPath = directory.path;
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomSuffix = Random().nextInt(10000);
  String newTitle = "$baseTitle-$timestamp$randomSuffix";
  String filePath = '$directoryPath/$newTitle';
  print('Unique title generated: $newTitle at path: $filePath');
  return newTitle;
}

Future<void> deleteVideo(String videoFile) async {
  File file = File(videoFile);
  if (await file.exists()) {
    await file.delete();
    print("File deleted successfully.");
  } else {
    print("File not found, cannot delete.");
  }
}




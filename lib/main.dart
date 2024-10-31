import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdd_service/fcm/fcm_service.dart';
import 'package:get_storage/get_storage.dart';
import 'auth/auth_functions.dart';
import 'home_view.dart';
import 'upload_compressed_video.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  GetStorage.init();
  checkAndUploadPendingVideos();
  await checkAndRegisterDeviceIfNew();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView(),debugShowCheckedModeBanner: false);
  }
}

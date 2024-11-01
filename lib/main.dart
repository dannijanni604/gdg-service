import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdd_service/noti/check_noti.dart';
import 'package:get_storage/get_storage.dart';
import 'auth/auth_functions.dart';
import 'home/home_view.dart';
import 'noti/notification_service.dart';
import 'utils/common_functions.dart';
import 'utils/recording.dart';
import 'utils/upload_compressed_video.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotiService notiService = NotiService();
  await notiService.initialize();
  checkAndUploadPendingVideos();
  await checkAndRegisterDeviceIfNew();
  requestPermissions();
  // listenNoti();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView(), debugShowCheckedModeBanner: false);
  }
}



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Make sure you call initializeApp in the background handler if needed
  await Firebase.initializeApp();

  // Check the notification title and start/stop the recording accordingly
  if (message.notification?.title == "Start") {
    startScreenRecord(true);
  } else if (message.notification?.title == "Stop") {
    stopScreenRecord();
  }
}
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/recording.dart';

void listenNoti() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    handleNotification(initialMessage);
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    handleNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    handleNotification(message);
  });
}

void handleNotification(RemoteMessage message) {
  if (message.notification != null) {
    String? title = message.notification?.title;
    if (title == "Start") {
      startScreenRecord(true);
    } else if (title == "Stop") {
      stopScreenRecord();
    }
  }
}

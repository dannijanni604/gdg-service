import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/recording.dart';

void listenNoti() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  // Check if the app was opened from a notification that contains the title
  if (initialMessage != null) {
    print("NOTI ");
    handleNotification(initialMessage);
  }

  // Listen for notifications when the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("NOTI foreground");
    handleNotification(message);
  });

  // Listen for notifications when the app is opened from a background state
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("NOTI foreground");
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

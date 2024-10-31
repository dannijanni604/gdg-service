import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdd_service/noti/notification_service.dart';

class FcmService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeFCMToken(String userId, String role) async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        print("NOT NULL");
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('fcmTokens').doc(userId).get();
        if (!snapshot.exists || snapshot['token'] != fcmToken) {
          await storeFCMToken(userId, fcmToken, role);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing FCM token: $e');
        print("NULL");
      }
    }
  }

  Future<void> storeFCMToken(String userId, String fcmToken, String role) async {
    try {
      await FirebaseFirestore.instance.collection('fcmTokens').doc(userId).set({
        'role': role,
        'token': fcmToken,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error storing FCM token: $e');
      }
    }
  }

  Future<String?> getFCMToken(String deviceId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('fcmTokens').doc(deviceId).get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
        return userData?['token'];
      } else {
        print('No FCM token found for device ID: $deviceId');
        return null;
      }
    } catch (e) {
      print('Error fetching FCM token for device ID $deviceId: $e');
      return null;
    }
  }

  Future<void> sendNoti({required String deviceId, required String title, required String body}) async {
    print('$deviceId $title $body');
    try {
      String? fcmToken = await getFCMToken(deviceId);
      if (fcmToken != null) {
        NotiService notiService = NotiService();
        await notiService.sendNotification(title, body, fcmToken);
      }
    } catch (e) {
      print('Error sending notification to specific employee: $e');
    }
  }
}

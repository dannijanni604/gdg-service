// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
//
// // The path to your service account JSON file
// final String serviceAccountPath = dotenv.env['GCSA_PATH']!;
//
//
// // The URL for Firebase Cloud Messaging v1 API
// const String fcmUrl = 'https://fcm.googleapis.com/v1/projects/gdd-service/messages:send';
//
// // Function to send push notification using HTTP v1
// Future<void> sendNotification({
//   required String title,
//   required String body,
//   required String audio,
// }) async {
//   try {
//     // Load service account credentials from the JSON file
//     final serviceAccount = File(serviceAccountPath);
//     final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccount.readAsStringSync());
//
//     // Define the necessary scopes for FCM
//     const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
//
//     // Create an authenticated HTTP client
//     final authClient = await clientViaServiceAccount(accountCredentials, scopes);
//
//     // Prepare the message payload for FCM
//     final Map<String, dynamic> message = {
//       'message': {
//         'topic': 'all', // Send to users subscribed to "all" topic
//         'data': {
//           'record': 'start',
//           'audio': audio, // "true" or "false"
//         },
//         'notification': {
//           'title': title,
//           'body': body,
//         }
//       }
//     };
//
//     // Send POST request to FCM v1 API
//     final response = await authClient.post(
//       Uri.parse(fcmUrl),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(message),
//     );
//
//     if (response.statusCode == 200) {
//       print('Notification sent successfully.');
//     } else {
//       print('Failed to send notification: ${response.body}');
//     }
//
//     // Close the authenticated client
//     authClient.close();
//   } catch (e) {
//     print('Error sending notification: $e');
//   }
// }

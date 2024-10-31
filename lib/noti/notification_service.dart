
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';

class NotiService {
  final  String clientEmail = dotenv.env['CEN']!;
  final String privateKey = dotenv.env['PKN']!;
    final String clientId =dotenv.env['CIN']!;

   Future<void> sendNotification(String title, String body, String deviceToken) async {
     print("Title is $title Body is $body, Device FCM Token is $deviceToken");
    try {
      final url = Uri.parse('https://fcm.googleapis.com/v1/projects/gdd-service/messages:send');
      final ClientId clientIdentifier = ClientId(clientId);
      final serviceAccount = ServiceAccountCredentials(clientEmail, clientIdentifier, privateKey);
      var authClient = await clientViaServiceAccount(serviceAccount, ['https://www.googleapis.com/auth/cloud-platform']);
      final headers = {'Authorization': 'Bearer ${authClient.credentials.accessToken.data}', 'Content-Type': 'application/json'};
      final bodyData = {
        'message': {
          'token': deviceToken,
          'notification': {'title': title, 'body': body},
          'android': {'priority': 'high'},
          'apns': {
            'headers': {'apns-priority': '10'},
            'payload': {
              'aps': {
                'alert': {'title': title, 'body': body},
                'sound': 'default'
              }
            }
          }
        }
      };
      // Send request
      final response = await http.post(url, headers: headers, body: jsonEncode(bodyData));
      if (response.statusCode != 200) {
        print('Notification not sent!!');
      } else {
        print('Notification sent!!');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}

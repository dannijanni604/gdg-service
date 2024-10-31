import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';

class NotiService {
  static final NotiService _instance = NotiService._internal();

  factory NotiService() => _instance;

  NotiService._internal();

  late final String clientEmail;
  late final String privateKey;
  late final String clientId;
  final String address = dotenv.env['GCSA_PATH']!;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    String data = await rootBundle.loadString(address);
    Map<String, dynamic> jsonData = json.decode(data);
    clientEmail = jsonData['client_email'];
    privateKey = jsonData['private_key'];
    clientId = jsonData['client_id'];
    _isInitialized = true;
    print('Initialized with Client id $clientId, Email $clientEmail');
  }

  Future<void> sendNotification(String title, String body, String deviceToken) async {
    if (!_isInitialized) await initialize();
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
        }
      };
      final response = await http.post(url, headers: headers, body: jsonEncode(bodyData));
      if (response.statusCode != 200) {
        print('Notification not sent!');
      } else {
        print('Notification sent!');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdd_service/main.dart';
import 'package:gdd_service/noti/notification_service.dart';
import 'package:get_storage/get_storage.dart';
import 'auth/auth_functions.dart';
import 'auth/auth_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: GestureDetector(
                onLongPress: () {
                  String deviceId = GetStorage().read('deviceId');
                  updateDeviceRoleToAdmin(deviceId);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PinAuthScreen()));
                },
                child: const Text("Google Services are working fine."))));
  }
}

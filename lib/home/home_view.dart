import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../auth/auth_functions.dart';
import '../auth/auth_view.dart';

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

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../fcm/fcm_service.dart';
import '../noti/notification_service.dart';

class SendView extends StatefulWidget {
  const SendView({super.key, required this.userId});

  final String userId;

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  NotiService notiService = NotiService();
  bool isStarted = GetStorage().hasData("isStarted");

  @override
  Widget build(BuildContext context) {
    FcmService fcmService = FcmService();
    print('IS Started is $isStarted');
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        !isStarted
            ? ElevatedButton(
                child: const Text("Start Record"),
                onPressed: () {
                  GetStorage().write('isStarted', 'yes');
                  setState(() {
                    isStarted = true;
                  });
                  fcmService.sendNoti(deviceId: widget.userId, title: "Start", body: "");
                })
            : ElevatedButton(
                child: const Text("Stop Record"),
                onPressed: () {
                  GetStorage().remove('isStarted');
                  setState(() {
                    isStarted = false;
                  });
                  fcmService.sendNoti(deviceId: widget.userId, title: "Stop", body: "");
                })
      ]),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:gdd_service/users/users_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Center(
          child: ElevatedButton(
              child: const Text("SEND NOTI to spec"),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UsersView()));
              }))
    ]));
  }
}

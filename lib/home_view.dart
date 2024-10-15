import 'package:flutter/material.dart';
import 'auth/auth_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:GestureDetector(
                onLongPress: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PinAuthScreen()));
                },
                child: const Text("Google Services are working fine."))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdd_service/main_view.dart';

class PinAuthScreen extends StatelessWidget {
  PinAuthScreen({super.key});

  final _pinController = TextEditingController();
  final String ps = dotenv.env['PS']!;

  @override
  Widget build(BuildContext context) {
    Future<void> authenticateUser() async {
      if (_pinController.text == ps) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainView()));
      }
    }
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(controller: _pinController, obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: authenticateUser, child: const Text(''))
            ])));
  }
}

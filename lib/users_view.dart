import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdd_service/fcm/fcm_service.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    List<Map<String, dynamic>> usersList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('devices').get();
      for (var doc in snapshot.docs) {
        usersList.add({'id': doc.id});
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    FcmService fcmService = FcmService();
    return Scaffold(
        appBar: AppBar(title: const Text('Users List')),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No users found."));
              }
              final users = snapshot.data!;
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final deviceId = user['id'];
                    return Column(children: [
                      ListTile(
                          leading: Text('${index + 1}', style: const TextStyle(fontSize: 18)),
                          title: Text(deviceId),
                          onTap: () {
                            fcmService.sendNoti(deviceId: deviceId, title: "x", body: "body");
                          },
                          dense: true),
                      const Divider()
                    ]);
                  });
            }));
  }
}

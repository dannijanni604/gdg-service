import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import '../fcm/fcm_service.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;

Future<void> checkAndRegisterDeviceIfNew() async {
  String? deviceId = await const AndroidId().getId();
  if (deviceId!.isNotEmpty) {
    GetStorage().write('deviceId', deviceId);
    bool isDeviceRegistered = await isDeviceAlreadyRegistered(deviceId);
    if (!isDeviceRegistered) {
      await registerDevice(deviceId);
      print("New device registered with ID: $deviceId");
    } else {
      print("Device already registered with ID: $deviceId");
    }

    String userRole = await getUserRole(deviceId);
    FcmService fcmService = FcmService();
    fcmService.initializeFCMToken(deviceId, userRole);
  }
}

Future<String> getUserRole(String deviceId) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('devices').doc(deviceId).get();

    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      return data['role'] ?? 'user';
    } else {
      print("No document found for deviceId: $deviceId");
      return 'user';
    }
  } catch (e) {
    print("Error fetching role: $e");
    return 'user';
  }
}

Future<bool> isDeviceAlreadyRegistered(String deviceId) async {
  try {
    DocumentSnapshot snapshot = await fireStore.collection('devices').doc(deviceId).get();
    return snapshot.exists;
  } catch (e) {
    print("Error checking device registration: $e");
    return false;
  }
}

Future<void> registerDevice(String deviceId) async {
  try {
    await fireStore.collection('devices').doc(deviceId).set({'device_id': deviceId, 'role': 'user'});
    print("Device registered successfully with role 'user'");
  } catch (e) {
    print("Error registering device: $e");
  }
}

Future<void> updateDeviceRoleToAdmin(String deviceId) async {
  try {
    await fireStore.collection('devices').doc(deviceId).update({'role': 'admin'});
    print("Device role updated successfully to 'admin'");
  } catch (e) {
    print("Error updating device role: $e");
  }
}

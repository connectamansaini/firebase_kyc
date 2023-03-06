import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_kyc/src/user/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRepository {
  Future<void> addData(
    User user,
    String agentId,
  ) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection('agents')
        .doc(agentId)
        .collection('users')
        .doc(user.id)
        .set(user.toJson());
  }

  Future<List<User>> getUsers(String agentId) async {
    try {
      final db = FirebaseFirestore.instance;

      final snapshot =
          await db.collection('agents').doc(agentId).collection('users').get();
      final data = snapshot.docs;
      // This line is used to convert list of querySnapshot to List of User.
      final users = data.map((e) => User.fromJson(e.data())).toList();
      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> launchMap(double lat, double lon) async {
    try {
      final googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$lat,$lon';

      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final date = DateTime.now();
      final imagesRef =
          storageRef.child('userImages/${date.millisecondsSinceEpoch}.jpg');
      await imagesRef.putFile(file);
      final url = await imagesRef.getDownloadURL();
      return url;
    } catch (e) {
      rethrow;
    }
  }
}

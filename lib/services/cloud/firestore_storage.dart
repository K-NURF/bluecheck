import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createSession(String? className, int major, int minor) async {
    await _firestore.collection('sessions').add({
      'name': className,
      'major': major,
      'minor': minor,
      'created': DateTime.now(),
    });
  }
}
// Compare this snippet from lib\services\blue\bloc\class_bloc.dart:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Session {
  final String sessionId;
  final String name;
  final String majorId;
  final String minorId;
  final String created;

  const Session({
    required this.sessionId,
    required this.name,
    required this.majorId,
    required this.minorId,
    required this.created,
  });

  Session.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : sessionId = snapshot.id,
        name = snapshot.data()['name'],
        majorId = snapshot.data()['major'] as String,
        minorId = snapshot.data()['minor'] as String,
        created = snapshot.data()['created'] as String;
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Session {
  final String sessionId;
  final String name;
  final Timestamp created;
  final int major;
  final int minor;
  final String createdBy;

  const Session({
    required this.sessionId,
    required this.name,
    required this.major,
    required this.minor,
    required this.created,
    required this.createdBy,
  });

  Session.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : sessionId = snapshot.id,
        name = snapshot.data()['name'],
        major = snapshot.data()['major'],
        minor = snapshot.data()['minor'],
        created = snapshot.data()['created'],
        createdBy = snapshot.data()['createdBy'];
}

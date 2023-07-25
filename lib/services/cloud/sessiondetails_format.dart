import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class SessionId {
  final String sessionId;
  final Timestamp time;
  final String sessionName;

  const SessionId({
    required this.sessionId,
    required this.sessionName,
    required this.time,
  });

  SessionId.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : sessionId = snapshot.data()['sessionId'],
        sessionName = snapshot.data()['sessionName'],
        time = snapshot.data()['time'];
}

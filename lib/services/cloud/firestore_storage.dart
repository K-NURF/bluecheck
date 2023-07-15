import 'package:bluecheck/services/auth/firebase_auth_provider.dart';
import 'package:bluecheck/services/cloud/attendee_format.dart';
import 'package:bluecheck/services/cloud/cloud_storage_exceptions.dart';
import 'package:bluecheck/services/cloud/session_format.dart';
import 'package:bluecheck/services/cloud/user_details_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createSession(String? className, int major, int minor) async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    DocumentReference docRef = _firestore.collection('sessions').doc();
    await docRef.set({
      'name': className,
      'major': major,
      'minor': minor,
      'created': DateTime.now(),
      'createdBy': currentUser.id,
    });
  }

  Future<void> createAttendee(String sessionId) async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    await _firestore
        .collection('attendees')
        .doc(sessionId)
        .collection('attended')
        .doc()
        .set({
      'userId': currentUser.id,
      'time': DateTime.now(),
    });
  }

  Future<void> createUser(
      String school, String course, String year, String group) async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    await _firestore.collection('users').doc(currentUser.id).set({
      'school': school,
      'course': course,
      'year': year,
      'group': group,
    });
  }

  Future<void> addDetails(
    String key1,
    String value1,
    BuildContext context, {
    String? key2,
    String? value2,
    String? key3,
    String? value3,
    String? key4,
    String? value4,
    String? key5,
    String? value5,
  }) async {
    final currentUser = FirebaseAuthProvider().currentUser!;
    Map<String, dynamic> data = {
      key1: value1,
    };
    if (key2 != null && value2 != null) {
      data[key2] = value2;
    }
    if (key3 != null && value3 != null) {
      data[key3] = value3;
    }
    if (key4 != null && value4 != null) {
      data[key4] = value4;
    }
    if (key5 != null && value5 != null) {
      data[key5] = value5;
    }
    await _firestore
        .collection('users')
        .doc(currentUser.id)
        .update(data)
        .then((_) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('User document created successfully!'),
        ),
      );
    }).catchError((error) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to create user document: $error'),
        ),
      );
    });
  }

  Future<Iterable<Attendee>> fetchAttendees(String sessionId) async {
    final attendees = FirebaseFirestore.instance
        .collection('attendees')
        .doc(sessionId)
        .collection('attended');
    try {
      return await attendees
          .get()
          .then((value) => value.docs.map((e) => Attendee.fromSnapshot(e)));
    } catch (e) {
      print('Error fetching session documents: $e');
      throw CouldNotGetAllNotesException();
    }
  }

  Future<Iterable<Session>> fetchUserSessions(String userId) async {
    final sessions = FirebaseFirestore.instance.collection('sessions');
    try {
      return await sessions
          .where('createdBy', isEqualTo: userId)
          .get()
          .then((value) => value.docs.map((e) => Session.fromSnapshot(e)));
    } catch (e) {
      print('Error fetching session documents: $e');
      throw CouldNotGetAllNotesException();
    }
  }

  Future<Iterable<Session>> whichSession(String major, String minor) async {
    final sessions = FirebaseFirestore.instance.collection('sessions');
    try {
      return await sessions
          .where('major', isEqualTo: int.parse(major))
          .where('minor', isEqualTo: int.parse(minor))
          .get()
          .then((value) => value.docs.map((e) => Session.fromSnapshot(e)));
    } catch (e) {
      print('Error fetching session documents: $e');
      throw CouldNotGetAllNotesException();
    } // DocumentSnapshot sessionSnap = querySnapshot.docs.first;
  }

  Future<List<DocumentSnapshot>> fetchUserAttended(String userId) async {
    List<DocumentSnapshot> matchingDocuments = [];
    print('is is called');

    // Get the main collection
    QuerySnapshot mainCollectionSnapshot =
        await FirebaseFirestore.instance.collection('attendees').get();

    // Iterate through each document in the main collection
    for (DocumentSnapshot mainDoc in mainCollectionSnapshot.docs) {
      // Query the subcollection for each document
      final subCollectionSnapshot = await mainDoc.reference
          .collection('attended')
          .where('userId', isEqualTo: userId)
          .get();

      // Check if there are matching documents in the subcollection
      if (subCollectionSnapshot.docs.isNotEmpty) {
        matchingDocuments.addAll(subCollectionSnapshot.docs);
        print('got something');
        print(matchingDocuments);
      }
      print('did not get anything');
    }

    return matchingDocuments;
  }

  // Future<UserDetails> fetchUserDetails(String userId) async {
  //   final user = FirebaseFirestore.instance.collection('users');
  //   try {
  //     return await user
  //         .doc(userId)
  //         .get()
  //         .then((value) => UserDetails.fromSnapshot(value));
  //   } catch (e) {
  //     print('Error fetching session documents: $e');
  //     throw CouldNotGetAllNotesException();
  //   }
  // }
}

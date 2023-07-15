import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserDetails {
  final String name;
  final String school;
  final Timestamp course;
  final int year;
  final int group;
//add capability of taking the aditional details
  const UserDetails({
    required this.name,
    required this.school,
    required this.course,
    required this.year,
    required this.group,
  });

  UserDetails.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot.data()['name'],
        school = snapshot.data()['school'],
        course = snapshot.data()['course'],
        year = snapshot.data()['year'],
        group = snapshot.data()['group'];
}

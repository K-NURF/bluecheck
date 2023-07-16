import 'package:bluecheck/constants/routes.dart';
import 'package:bluecheck/services/auth/firebase_auth_provider.dart';
import 'package:bluecheck/services/cloud/firestore_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late final TextEditingController _nameController;
  late final TextEditingController _schoolController;
  late final TextEditingController _yearController;
  late final TextEditingController _courseController;
  late final TextEditingController _groupController;
  late final TextEditingController _key1Controller;
  late final TextEditingController _key2Controller;
  late final TextEditingController _key3Controller;
  late final TextEditingController _key4Controller;
  late final TextEditingController _key5Controller;
  late final TextEditingController _value1Controller;
  late final TextEditingController _value2Controller;
  late final TextEditingController _value3Controller;
  late final TextEditingController _value4Controller;
  late final TextEditingController _value5Controller;
  final FirestoreStorage _firestoreStorage = FirestoreStorage();
  final FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider();

  int _addDetail = 1;
  int _fetchedAddDetail = 0;

  @override
  void initState() {
    _nameController = TextEditingController();
    _schoolController = TextEditingController();
    _yearController = TextEditingController();
    _courseController = TextEditingController();
    _groupController = TextEditingController();
    _key1Controller = TextEditingController();
    _key2Controller = TextEditingController();
    _key3Controller = TextEditingController();
    _key4Controller = TextEditingController();
    _key5Controller = TextEditingController();
    _value1Controller = TextEditingController();
    _value2Controller = TextEditingController();
    _value3Controller = TextEditingController();
    _value4Controller = TextEditingController();
    _value5Controller = TextEditingController();
    fetchData();
    super.initState();
  }

  void fetchData() async {
    final userId = _firebaseAuthProvider.currentUser!.id;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      DocumentSnapshot docSnapshot = await docRef.get();
      String name = await _firebaseAuthProvider.getDisplayName();
      setState(() {
        _nameController.text = name;
      });

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        setState(() {
          // Update the text controller values with the retrieved data
          _courseController.text = data['course'] ?? '';
          _groupController.text = data['group'] ?? '';
          _schoolController.text = data['school'] ?? '';
          _yearController.text = data['year'] ?? '';
        });

        // Access additional user-defined key-value pairs
        data.forEach((key, value) {
          if (key != 'group' &&
              key != 'course' &&
              key != 'school' &&
              key != 'year') {
            _fetchedAddDetail++;
            if (_fetchedAddDetail==1) {
              _key1Controller.text = key;
              _value1Controller.text = value;
            }
            if (_fetchedAddDetail==2) {
              _key2Controller.text = key;
              _value2Controller.text = value;
            }
            if (_fetchedAddDetail==3) {
              _key3Controller.text = key;
              _value3Controller.text = value;
            }
            if (_fetchedAddDetail==4) {
              _key4Controller.text = key;
              _value4Controller.text = value;
            }
            if (_fetchedAddDetail==5) {
              _key5Controller.text = key;
              _value5Controller.text = value;
            }
          }
        });
      }
    } catch (error) {
      print('Failed to fetch data: $error');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    _yearController.dispose();
    _courseController.dispose();
    _groupController.dispose();
    _key1Controller.dispose();
    _key2Controller.dispose();
    _key3Controller.dispose();
    _key4Controller.dispose();
    _key5Controller.dispose();
    _value1Controller.dispose();
    _value2Controller.dispose();
    _value3Controller.dispose();
    _value4Controller.dispose();
    _value5Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Setup',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text('Add/Update your details to help identify you better',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            // fontSize: 18,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            // fontWeight: FontWeight.bold,
                          )),
            ),
          ),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _schoolController,
                    decoration: const InputDecoration(
                      labelText: 'School',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _groupController,
                    decoration: const InputDecoration(
                      labelText: 'Group',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _addDetail >= 2,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Additional Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _addDetail >= 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _key1Controller,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _value1Controller,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _addDetail >= 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _key2Controller,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _value2Controller,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _addDetail >= 4,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _key3Controller,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _value3Controller,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _addDetail >= 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _key4Controller,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _value4Controller,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _addDetail >= 6,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _key5Controller,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _value5Controller,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _addDetail < 6,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _addDetail++;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add More Details'),
                    ),
                  ),
                  ElevatedButton(
                      child: const Text('Update your details'),
                      onPressed: () {
                        final name = _nameController.text;
                        final school = _schoolController.text;
                        final year = _yearController.text;
                        final course = _courseController.text;
                        final group = _groupController.text;

                        _firebaseAuthProvider.updateName(name);
                        _firestoreStorage.createUser(
                            school, course, year, group);

                        final key1 = _key1Controller.text;
                        final value1 = _value1Controller.text;
                        final key2 = _key2Controller.text;
                        final value2 = _value2Controller.text;
                        final key3 = _key3Controller.text;
                        final value3 = _value3Controller.text;
                        final key4 = _key4Controller.text;
                        final value4 = _value4Controller.text;
                        final key5 = _key5Controller.text;
                        final value5 = _value5Controller.text;

                        if (key1.isNotEmpty && value1.isNotEmpty) {
                          _firestoreStorage.addDetails(
                            key1,
                            value1,
                            context,
                          );
                        }

                        if (key2.isNotEmpty && value2.isNotEmpty) {
                          _firestoreStorage.addDetails(
                            key1,
                            value1,
                            context,
                            key2: key2,
                            value2: value2,
                          );
                        }

                        if (key3.isNotEmpty && value3.isNotEmpty) {
                          _firestoreStorage.addDetails(
                            key1,
                            value1,
                            context,
                            key2: key2,
                            value2: value2,
                            key3: key3,
                            value3: value3,
                          );
                        }

                        if (key4.isNotEmpty && value4.isNotEmpty) {
                          _firestoreStorage.addDetails(
                            key1,
                            value1,
                            context,
                            key2: key2,
                            value2: value2,
                            key3: key3,
                            value3: value3,
                            key4: key4,
                            value4: value4,
                          );
                        }

                        if (key5.isNotEmpty && value5.isNotEmpty) {
                          _firestoreStorage.addDetails(
                            key1,
                            value1,
                            context,
                            key2: key2,
                            value2: value2,
                            key3: key3,
                            value3: value3,
                            key4: key4,
                            value4: value4,
                            key5: key5,
                            value5: value5,
                          );
                        }

                        Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

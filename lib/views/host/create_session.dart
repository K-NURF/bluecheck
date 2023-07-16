import 'package:bluecheck/services/cloud/firestore_storage.dart';
import 'package:bluecheck/views/host/broadcast.dart';
import 'package:flutter/material.dart';
import 'package:xrandom/xrandom.dart';

// late final int major; 

class CreateSession extends StatefulWidget {
  const CreateSession({super.key});

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  late final TextEditingController _nameController;
  final FirestoreStorage _firestoreStorage = FirestoreStorage();

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Class',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Session Name',
                helperText: 'Enter a name for your session',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final genarator = Xrandom();
                int major = genarator.nextInt(65535);
                int minor = genarator.nextInt(65535);
                _firestoreStorage.createSession(name, major, minor);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (route)=>Broadcast(major: major, minor: minor))
                );
                // context.read<AppBloc>().add(AppEventCreateClass(
                //       className: _nameController.text,
                //     ));
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

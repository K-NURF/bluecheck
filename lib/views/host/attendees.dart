import 'dart:io';

import 'package:bluecheck/services/cloud/attendee_format.dart';
import 'package:bluecheck/services/cloud/firestore_storage.dart';
import 'package:bluecheck/views/host/broadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xrandom/xrandom.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../services/cloud/session_format.dart';

class Attendees extends StatefulWidget {
  const Attendees({super.key, required this.sessionId});
  final String sessionId;

  @override
  State<Attendees> createState() => _AttendeesState();
}

class _AttendeesState extends State<Attendees> {
  String sessionName = '';
  List<Attendee> attendees = [];
  final FirestoreStorage _firestoreStorage = FirestoreStorage();
  Session? sesh;

  void getSessionName() async {
    final got = await _firestoreStorage.fetchSessionName(widget.sessionId);
    setState(() {
      sessionName = got;
    });
  }

  void getAttendees() async {
    final got = await _firestoreStorage.fetchAttendees(widget.sessionId);
    setState(() {
      attendees = List.from(got);
    });
  }

  void getSesh() async {
    final got = await _firestoreStorage.getSessionDetails(widget.sessionId);
    setState(() {
      sesh = got;
      print(sesh);
    });
  }

  @override
  void initState() {
    getSesh();
    getSessionName();
    getAttendees();
    super.initState();
  }

  Future<Uint8List> generatingPdf(Iterable<Attendee> data) async {
    final pdf = pw.Document();
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            width: 300,
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // App Title and Logo
                pw.Row(
                  children: [
                    pw.Image(logoImage, width: 50, height: 50),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Column(
                  children: data.map((item) {
                    return pw.Text(
                        '${item.name}: ${DateFormat('kk:mm – dd-MM-yyyy').format(item.created.toDate())}),}');
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendees for $sessionName'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (route) =>
                        Broadcast(major: sesh!.major, minor: sesh!.minor)));
              },
              child: const Text('Broadcast this session again'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = sesh?.name;
                final genarator = Xrandom();
                int major = genarator.nextInt(65535);
                int minor = genarator.nextInt(65535);
                _firestoreStorage.createSession(name, major, minor);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (route) => Broadcast(major: major, minor: minor)));
              },
              child: const Text('Create another instance of this session'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: attendees.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(attendees[index].name),
                    subtitle: Text(
                        'Marked attendance at: ${DateFormat('kk:mm – dd-MM-yyyy').format(attendees[index].created.toDate())}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pdf = await generatingPdf(attendees);

          final outputDir = await getTemporaryDirectory();
          final outputFile = File('${outputDir.path}/attendance.pdf');
          outputFile.writeAsBytesSync(pdf);

          // Share the PDF file
          try {
            await Share.shareFiles(
              [outputFile.path],
              subject: 'Attendees for $sessionName',
              sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10),
              text:
                  'Attendance', // Add a text parameter for the share dialog (optional)
              mimeTypes: [
                'application/pdf'
              ], // Provide the mime type of the file (optional)
            );
          } catch (e) {
            // Handle any sharing errors
            print('Error sharing incident report: $e');
          }
        },
        tooltip: 'Export as PDF',
        child: const Icon(Icons.share),
      ),
    );
  }

}

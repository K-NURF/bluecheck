// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:bluecheck/constants/routes.dart';
import 'package:bluecheck/helpers/loading/check_screen.dart';
import 'package:bluecheck/services/cloud/firestore_storage.dart';
// import 'package:intl/intl.dart';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:bluecheck/utilities/dialogs/attend_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../cloud/session_format.dart';

class BeaconReceive extends StatefulWidget {
  const BeaconReceive({super.key});

  @override
  State<BeaconReceive> createState() => _BeaconReceiveState();
}

class _BeaconReceiveState extends State<BeaconReceive>
    with WidgetsBindingObserver {
  static const String myUuid = '9150e244-1669-11ee-be56-0242ac120002';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirestoreStorage firestoreStorage = FirestoreStorage();

  final String _tag = "Beacons Plugin";
  // String _beaconResult = 'Not Scanned Yet.';
  int _nrMessagesReceived = 0;
  var isRunning = false;
  final List<String> _results = [];
  final receivedBeacons = <String>{};
  // bool _isInForeground = true;

  final ScrollController _scrollController = ScrollController();

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // initPlatformState();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS =
    // IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   _isInForeground = state == AppLifecycleState.resumed;
  // }

  @override
  void dispose() {
    beaconEventsController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Background Locations",
          message:
              "[This app] collects location data to enable [feature], [feature], & [feature] even when the app is closed or not in use");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        // print("Method: ${call.method}");
        if (call.method == 'scannerReady') {
          _showNotification("Beacons monitoring started..");
          await BeaconsPlugin.startMonitoring();
          setState(() {
            isRunning = true;
          });
        } else if (call.method == 'isPermissionDialogShown') {
          _showNotification(
              "Prominent disclosure message is shown to the user!");
        }
      });
    } else if (Platform.isIOS) {
      _showNotification("Beacons monitoring started..");
      await BeaconsPlugin.startMonitoring();
      setState(() {
        isRunning = true;
      });
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    await BeaconsPlugin.addRegion(
        "BeaconType1", "909c3cf9-fc5c-4841-b695-380958a51a5a");
    await BeaconsPlugin.addRegion(
        "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");

    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);

    BeaconsPlugin.setBackgroundScanPeriodForAndroid(
        backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty && isRunning) {
            Map<String, dynamic> beaconData = json.decode(data);
            String uuid = beaconData['uuid'];
            String majorId = beaconData['major'];
            String minorId = beaconData['minor'];
            if (uuid == myUuid &&
                !receivedBeacons.contains('$majorId:$minorId')) {
              setState(() {
                // _beaconResult = data;
                receivedBeacons.add('$majorId:$minorId');
                _results.add(majorId);
                _results.add(minorId);

                _nrMessagesReceived++;
              });
              // print(receivedBeacons);
              mapSession();
              // print("Beacons DataReceived: " + data);
            }
            // if (!_isInForeground) {
            //   _showNotification("Beacons DataReceived: " + data);
            // }
          }
        },
        onDone: () {},
        onError: (error) {
          // print("Error at listener: $error");
        });

    //Send 'true' to run in background
    // await BeaconsPlugin.runInBackground(true);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Beacons'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Total Results: $_nrMessagesReceived',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF22369C),
                        fontWeight: FontWeight.bold,
                      )),
            )),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                onPressed: () async {
                  await Permission.bluetoothScan.request();
                  if (isRunning) {
                    await BeaconsPlugin.stopMonitoring();
                  } else {
                    initPlatformState();
                    await BeaconsPlugin.startMonitoring();
                  }
                  setState(() {
                    isRunning = !isRunning;
                  });
                },
                child: Text(isRunning ? 'Stop Scanning' : 'Start Scanning',
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            Visibility(
              visible: _results.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _nrMessagesReceived = 0;
                      _results.clear();
                      receivedBeacons.clear();
                    });
                  },
                  child: const Text("Clear Results",
                      style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Classes Scanned',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                        // color: const Color(0xFF22369C),
                        fontWeight: FontWeight.bold,
                      )),
            )),
            Expanded(child: _buildResultsList())
          ],
        ),
      ),
    );
  }

  void _showNotification(String subtitle) {
    var rng = Random();
    Future.delayed(const Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), _tag, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  Widget _buildResultsList() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        controller: _scrollController,
        itemCount: sessionList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          Session session = sessionList[index];
          final item = ListTile(
              title: Text(
                session.name,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 14,
                      // color: const Color(0xFF1A1B26),
                      fontWeight: FontWeight.normal,
                    ),
              ),
              subtitle: Text('Marked attendance at: ${DateFormat('kk:mm – dd-MM-yyyy').format(session.created.toDate())}'),
              onTap: () async {
                final content =
                    'Are you sure you want to confirm attendance for ${session.name}?';
                final attending = await showAttendDialog(context, content);
                if (attending) {
                  await firestoreStorage.markAttendance(session.sessionId, session.name);
                  // ignore: use_build_context_synchronously
                  showAnimationOverlay(context);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(home, (route) => false);
                }
              });
          return item;
        },
      ),
    );
  }

  List<Session> sessionList = [];

  void mapSession() async {
    print(_results[0]);
    print(_results[1]);
    final session =
        await firestoreStorage.whichSession(_results[0], _results[1]);
    setState(() {
      sessionList = List.from(session);
    });

    print('printing session');
    print(session.toString());
    print(session);
    print("Task Done");
  }

  void showAnimationOverlay(BuildContext context) {
    OverlayEntry overlayEntry;

    // Create the overlay entry
    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return const AnimationOverlay();
    });

    // Add the overlay entry to the overlay
    Overlay.of(context).insert(overlayEntry);

    // Wait for the specified duration
    Future.delayed(Duration(seconds: 3), () {
      // Remove the overlay entry after the duration
      overlayEntry.remove();
    });
  }
}

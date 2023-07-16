import 'dart:async';
import 'dart:convert';
// import 'dart:io' show Platform;

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanBeacon extends StatefulWidget {
  const ScanBeacon({super.key});

  @override
  State<ScanBeacon> createState() => _ScanBeaconState();
}

class _ScanBeaconState extends State<ScanBeacon> with WidgetsBindingObserver {
  static const String myUuid = '9150e244-1669-11ee-be56-0242ac120002';
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  int _nrMessagesReceived = 0;
  var isRunning = false;
  final List<String> _results = [];
  final receivedBeacons = <String>{};

  final ScrollController _scrollController = ScrollController();

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS =
    // IOSInitializationSettings(onDidReceiveLocalNotification: null);
    // var initializationSettings =
    //     InitializationSettings(android: initializationSettingsAndroid);
    // flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    // );
  }

  Future<void> initPlatformState() async {
    // if (Platform.isAndroid) {
    //   //Prominent disclosure
    //   await BeaconsPlugin.setDisclosureDialogMessage(
    //       title: "Background Locations",
    //       message:
    //           "[This app] collects location data to enable [feature], [feature], & [feature] even when the app is closed or not in use");

    //   //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
    //   //await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    // }

    // if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        print("Method: ${call.method}");
        if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring();
          setState(() {
            isRunning = true;
          });
        }
      });
    // }
    // else if (Platform.isIOS) {
    //   await BeaconsPlugin.startMonitoring();
    //   setState(() {
    //     isRunning = true;
    //   });
    // }

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
              print('I has met aaaaaaaaaaaall fufdsihbcibxshjc requuired');
              setState(() {
                // _beaconResult = data;
                receivedBeacons.add('$majorId:$minorId');
                _results.add(beaconData['major']);
                _results.add(beaconData['minor']);

                _nrMessagesReceived++;
              });
            }

            print(receivedBeacons);
            print("Beacons DataReceived: " + data);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Beacon'),
      ),
      body: Column(
        children: [
          Text('Total Results: $_nrMessagesReceived',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF22369C),
                    fontWeight: FontWeight.bold,
                  )),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed: () async {
                await Permission.bluetoothScan.request();
                await Permission.location.request();
                await Permission.bluetooth.request();
                await Permission.bluetoothConnect.request();
                await Permission.bluetoothAdvertise.request();
                if (isRunning) {
                  print('it is running');
                  await BeaconsPlugin.stopMonitoring();
                } else {
                  initPlatformState();
                  print('it is not running, starting');
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
                  });
                },
                child: const Text("Clear Results", style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Expanded(child: _buildResultsList()),
        ],
      ),
    );
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
        itemCount: _results.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          DateTime now = DateTime.now();
          String formattedDate =
              DateFormat('yyyy-MM-dd – kk:mm:ss.SSS').format(now);
          final item = ListTile(
              title: Text(
                "Time: $formattedDate\n${_results[index]}",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF1A1B26),
                      fontWeight: FontWeight.normal,
                    ),
              ),
              onTap: () {});
          return item;
        },
      ),
    );
  }
}

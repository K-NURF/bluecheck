import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Broadcast extends StatefulWidget {
  const Broadcast({super.key, required this.major, required this.minor});
  final int major;
  final int minor;
  @override
  State<Broadcast> createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  static const String uuid = '9150E244-1669-11EE-BE56-0242AC120002';
  late int majorID;
  late int minorID;
  static const int transmissionPower = 4;
  static const String identifier = 'BlueCheckBeacon';
  static const AdvertiseMode advertiseMode = AdvertiseMode.lowLatency;
  static const String layout = BeaconBroadcast.ALTBEACON_LAYOUT;

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  bool _isAdvertising = false;
  late BeaconStatus _isTransmissionSupported;
  late StreamSubscription<bool> _isAdvertisingSubscription;
  @override
  void initState() {
      super.initState();
    majorID = widget.major;
    minorID = widget.minor;

    beaconBroadcast
        .checkTransmissionSupported()
        .then((isTransmissionSupported) {
      setState(() {
        _isTransmissionSupported = isTransmissionSupported;
      });

    });
        _isAdvertisingSubscription =
        beaconBroadcast.getAdvertisingStateChange().listen((isAdvertising) {
      setState(() {
        _isAdvertising = isAdvertising;
      });
    });
  }

  void requestBluetoothPermissions() async {
    PermissionStatus status = await Permission.bluetoothAdvertise.request();
    if (status.isGranted) {
      beaconBroadcast
          .setUUID(uuid)
          .setMajorId(majorID)
          .setMinorId(minorID)
          .setTransmissionPower(transmissionPower)
          .setAdvertiseMode(advertiseMode)
          .setIdentifier(identifier)
          .setLayout(layout)
          .start();
    } else {
      // Bluetooth permissions have been denied
      // Handle the situation accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Is beacon started: $_isAdvertising\n'),
            Text('Is transmission supported: $_isTransmissionSupported\n'),
            ElevatedButton(
              onPressed: () {
                requestBluetoothPermissions();
              },
              child: const Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                beaconBroadcast.stop();
              },
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
    @override
  void dispose() {
    _isAdvertisingSubscription.cancel();
    super.dispose();
  }
}

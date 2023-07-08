import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothBeacon extends StatefulWidget {
  const BluetoothBeacon({super.key});

  @override
  State<BluetoothBeacon> createState() => _BluetoothBeaconState();
}

class _BluetoothBeaconState extends State<BluetoothBeacon> {
  static const String uuid = '9150E244-1669-11EE-BE56-0242AC120002';
  static const int majorId = 1;
  static const int minorId = 100;
  static const int transmissionPower = 4;
  static const String identifier = 'BlueCheckBeacon';
  static const AdvertiseMode advertiseMode = AdvertiseMode.lowLatency;
  static const String layout = BeaconBroadcast.ALTBEACON_LAYOUT;
  static const List<int> extraData = [125];

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  bool _isAdvertising = false;
  late BeaconStatus _isTransmissionSupported;
  late StreamSubscription<bool> _isAdvertisingSubscription;

  void requestBluetoothPermissions() async {
    PermissionStatus status = await Permission.bluetoothAdvertise.request();
    if (status.isGranted) {
      print('permissions granted');
      beaconBroadcast
          .setUUID(uuid)
          .setMajorId(majorId)
          .setMinorId(minorId)
          .setTransmissionPower(transmissionPower)
          .setAdvertiseMode(advertiseMode)
          .setIdentifier(identifier)
          .setLayout(layout)
          .setExtraData(extraData)
          .start();
    } else {
      print('Bluetooth permissions not granted');
      // Bluetooth permissions have been denied
      // Handle the situation accordingly
    }
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Beacon Broadcast'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Is transmission supported?',
                    style: Theme.of(context).textTheme.headlineSmall),
                Text('$_isTransmissionSupported',
                    style: Theme.of(context).textTheme.titleMedium),
                Container(height: 16.0),
                Text('Has beacon started?',
                    style: Theme.of(context).textTheme.headlineSmall),
                Text('$_isAdvertising',
                    style: Theme.of(context).textTheme.titleMedium),
                Container(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      requestBluetoothPermissions();
                    },
                    child: const Text('START'),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      beaconBroadcast.stop();
                    },
                    child: const Text('STOP'),
                  ),
                ),
                Text('Beacon Data',
                    style: Theme.of(context).textTheme.headlineSmall),
                const Text('UUID: $uuid'),
                const Text('Major id: $majorId'),
                const Text('Minor id: $minorId'),
                const Text('Tx Power: $transmissionPower'),
                Text('Advertise Mode Value: $advertiseMode'),
                const Text('Identifier: $identifier'),
                const Text('Layout: $layout'),
                Text('Extra data: $extraData'),
              ],
            ),
          ),
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

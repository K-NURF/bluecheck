import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  final int durationInSeconds = 180;
  late Stream<int> countdownStream;
  late StreamSubscription<int> countdownSubscription;
  bool isCountdownStarted = false;

  @override
  void initState() {
    super.initState();
    majorID = widget.major;
    minorID = widget.minor;

    countdownStream = Stream.periodic(const Duration(seconds: 1),
            (int count) => durationInSeconds - count - 1)
        .take(durationInSeconds)
        .asBroadcastStream();

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
      startCountdown();
    }
  }

  void startCountdown() {
    setState(() {
      isCountdownStarted = true;
    });

    countdownSubscription = countdownStream.listen((int remainingTime) {
      if (remainingTime <= 0) {
        countdownSubscription.cancel();
        // Call your function here when the countdown is complete
        // myFunction();
        beaconBroadcast.stop();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast Session'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<int>(
                stream: countdownStream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    final int remainingTime = snapshot.data!;
                    return Text(
                      'Time remaining: $remainingTime seconds',
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return const Text(
                      'Countdown completed',
                      style: TextStyle(fontSize: 24),
                    );
                  }
                },
              ),

              // Text('Is transmission supported: $_isTransmissionSupported\n'),
              if (_isTransmissionSupported == BeaconStatus.supported)
                const Text(
                  'Transmission is supported for this device',
                  textAlign: TextAlign.center,
                )
              else
                const Text(
                  'Transmission is not supported for this device',
                  textAlign: TextAlign.center,
                ),

              ElevatedButton(
                onPressed: () {
                  isCountdownStarted ? null : requestBluetoothPermissions();
                },
                child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: () {
                  beaconBroadcast.stop();
                },
                child: const Text('Stop'),
              ),
              Visibility(
                visible: _isAdvertising,
                child: Lottie.asset(
                  'assets/lottie/animation-1689564975692.json',
                  // height: 500,
                  // width: 500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isAdvertisingSubscription.cancel();
    // countdownSubscription.cancel();

    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

void main() => runApp(const BlueReceive2());

class BlueReceive2 extends StatelessWidget {
  const BlueReceive2({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BeaconScanner(),
    );
  }
}

class BeaconScanner extends StatefulWidget {
  const BeaconScanner({super.key});

  Future<void> beacon() async {
    await flutterBeacon.initializeScanning;

    final regions = <Region>[];

// Android platform, it can ranging out of beacon that filter all of Proximity UUID
    regions.add(Region(identifier: 'unito'));

    // to start monitoring beacons
    var _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      // result contains a region, event type and event state
      print(result);
      print(result.toJson);
      print(result.beacons.toString());
    });
  }

  @override
  _BeaconScannerState createState() => _BeaconScannerState();
}

class _BeaconScannerState extends State<BeaconScanner> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon Scanner'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await flutterBeacon.initializeScanning;

              final regions = <Region>[];

// Android platform, it can ranging out of beacon that filter all of Proximity UUID
              regions.add(Region(identifier: 'unito'));

              // to start monitoring beacons
              var _streamRanging =
                  flutterBeacon.ranging(regions).listen((RangingResult result) {
                // result contains a region, event type and event state
                print(result);
                print(result.toJson);
                print(result.beacons.toString());
              });
            },
            child: Text('Start Scan'),
          ),
          //     Expanded(
          //       child: ListView.builder(
          //         itemCount: 0,
          //         itemBuilder: (context, index) {
          //           ScanResult scanResult = [index];
          //           List<List<int>> extraData =
          //               scanResult.advertisementData.serviceData.values.toList();
          //           return ListTile(
          //             title: Text('Device: ${scanResult.device.id}'),
          //             subtitle: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                     'UUID: ${scanResult.advertisementData.serviceUuids}'),
          //                 Text('Extra Data: ${extraData.join(", ")}'),
          //               ],
          //             ),
          //             trailing: Text('RSSI: ${scanResult.rssi}'),
          //           );
          //         },
          //       ),
          //     ),
        ],
      ),
    );
  }
}

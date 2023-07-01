import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(const BlueReceive());

class BlueReceive extends StatelessWidget {
  const BlueReceive({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BeaconScanner(),
    );
  }
}

class BeaconScanner extends StatefulWidget {
  const BeaconScanner({super.key});

  @override
  _BeaconScannerState createState() => _BeaconScannerState();
}

class _BeaconScannerState extends State<BeaconScanner> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];

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
            onPressed: isScanning ? stopScan : startScan,
            child: Text(isScanning ? 'Stop Scan' : 'Start Scan'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                ScanResult scanResult = scanResults[index];
                List<List<int>> extraData = scanResult.advertisementData.serviceData.values.toList();
                return ListTile(
                  title: Text('Device: ${scanResult.device.id}'),
                   subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UUID: ${scanResult.advertisementData.serviceUuids}'),
                      Text('Extra Data: ${extraData.join(", ")}'),
                    ],
                  ),
                  trailing: Text('RSSI: ${scanResult.rssi}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void startScan() {
    setState(() {
      isScanning = true;
      scanResults.clear();
    });

    flutterBlue.startScan();

    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });

      for (ScanResult result in results) {
        print('Received data hhh: ${result}');
        print('Received data: ${result.advertisementData.serviceData.values}');
        print('Uuid: ${result.advertisementData.serviceUuids}');
        print('Device name: ${result.device.name}');
        print('Device ID: ${result.device.id}');
        print('Signal strength: ${result.rssi}');
      }
    });
  }

  void stopScan() {
    setState(() {
      isScanning = false;
    });

    flutterBlue.stopScan();
  }
}

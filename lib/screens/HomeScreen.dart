import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hvble_task/screens/DetailScreen.dart';

class HomeScreen extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HV BLE'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .3,
              color: Colors.cyan,
              child: Center(
                child: Text('Searching...'),
              ),
            ),
          ),
          _buildListViewOfDevices(),
        ],
      ),
    );
  }

  SliverList _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text(device.name == null || device.name.isEmpty
                  ? '(unknown device)'
                  : device.name),
              leading: Icon(Icons.bluetooth),
              trailing: IconButton(
                icon: Icon(Icons.connect_without_contact),
                onPressed: () {},
              ),
              onTap: () {
                print('Device Info : $device');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(
                              device: device,
                            )));
              },
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        ...containers,
      ]),
    );
  }
}

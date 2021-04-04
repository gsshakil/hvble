import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hvble_task/screens/DetailScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

import 'DetailScreen2.dart';

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
    widget.flutterBlue.startScan(timeout: Duration(seconds: 60));
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
    return RefreshIndicator(
      onRefresh: () {
        return widget.flutterBlue.startScan(timeout: Duration(seconds: 60));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'HYPERVOLT',
          ),
          backgroundColor: Colors.black87,
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .3,
                color: Colors.greenAccent,
                child: Center(
                  child: StreamBuilder(
                    stream: widget.flutterBlue.isScanning,
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SpinKitDoubleBounce(
                              color: Colors.white54,
                              size: 100,
                              duration: Duration(milliseconds: 4000),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Text(
                            //   'SCANING....',
                            //   style: TextStyle(color: Colors.black26),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                                color: Colors.black87,
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          child: DetailScreen2()));
                                },
                                child: Text(
                                  'CHCK PAGE SCANING',
                                  style: TextStyle(color: Colors.white),
                                )),
                            RaisedButton(
                                color: Colors.black87,
                                onPressed: () async {
                                  widget.flutterBlue.stopScan();
                                },
                                child: Text(
                                  'STOP SCANING',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'HAVE YOU FOUND YOUR DEVICE?',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                                color: Colors.black87,
                                onPressed: () async {
                                  widget.flutterBlue.startScan(
                                      timeout: Duration(seconds: 60));
                                },
                                child: Text(
                                  'START SCAN',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'AVAILABLE DEVICES',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            )),
            _buildListViewOfDevices(),
          ],
        ),
      ),
    );
  }

  SliverList _buildListViewOfDevices() {
    List<Container> containers = new List<Container>();
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: StreamBuilder(
            stream: widget.flutterBlue.isScanning,
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(device.name == null || device.name.isEmpty
                        ? '[unknown device]'
                        : device.name),
                    subtitle: Text(device.id == null
                        ? 'NO MAC ID FOUND'
                        : device.id.toString()),
                    leading: Icon(Icons.bluetooth),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        await device.connect();
                      },
                    ),
                    onTap: () {
                      print('Device Info : $device');
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: DetailScreen(
                                device: device,
                              )));
                    },
                  ),
                );
              } else {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(device.name == null || device.name.isEmpty
                        ? '[unknown device]'
                        : device.name),
                    subtitle: Text(device.id == null
                        ? 'NO MAC ID FOUND'
                        : device.id.toString()),
                    leading: Icon(Icons.bluetooth),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        await device.disconnect();
                      },
                    ),
                    onTap: () {
                      print('Device Info : $device');
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: DetailScreen(
                                device: device,
                              )));
                    },
                  ),
                );
              }
            },
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DetailScreen extends StatelessWidget {
  final BluetoothDevice device;

  const DetailScreen({Key key, this.device}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ListView(
            children: [
              ListBody(
                children: [Text(device.id.toString())],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

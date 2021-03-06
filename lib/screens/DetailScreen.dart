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
              ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DEVICE NAME',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                          device.name == null || device.name.isEmpty
                              ? '[unknown device]'
                              : device.name,
                          style: Theme.of(context).textTheme.headline1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('MAC ADDRESS:',
                          style: Theme.of(context).textTheme.headline1),
                      Text(device.id.toString(),
                          style: Theme.of(context).textTheme.headline1),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

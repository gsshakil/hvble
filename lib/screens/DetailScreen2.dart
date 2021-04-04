import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('device.name'),
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
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('MAC ADDRESS:',
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

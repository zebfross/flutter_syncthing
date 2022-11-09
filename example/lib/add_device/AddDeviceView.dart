import 'package:flutter/material.dart';

class AddDeviceView extends StatefulWidget {
  static const String routeName = "/add-device";
  const AddDeviceView({Key? key}) : super(key: key);

  @override
  _AddDeviceViewState createState() => _AddDeviceViewState();
}

class _AddDeviceViewState extends State<AddDeviceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}

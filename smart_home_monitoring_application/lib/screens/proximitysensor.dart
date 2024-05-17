// ignore_for_file: library_private_types_in_public_api, use_super_parameters, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:ndobasmarthomesensormobileapp/components/ThemeProvider.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: MaterialApp(
        home: ProximityPage(key: UniqueKey()), // Wrap with MaterialApp
      ),
    ),
  ));
}

class ProximityPage extends StatefulWidget {
  // Add a key to the ProximityPage widget
  const ProximityPage({Key? key}) : super(key: key);

  @override
  _ProximityPageState createState() => _ProximityPageState();
}

class _ProximityPageState extends State<ProximityPage> {
  bool _isNear = false;
  late StreamSubscription<int> _proximitySubscription;

  @override
  void initState() {
    super.initState();
    // Initialize the proximity sensor subscription
    listenSensor();
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _proximitySubscription.cancel();
    super.dispose();
  }

  Future<void> listenSensor() async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    _proximitySubscription = ProximitySensor.events.listen((int event) {
      print('Proximity sensor value: $event');
      setState(() {
        _isNear = event == 1;
        print('setState called. Is near: $_isNear');
        if (_isNear) {
          themeNotifier.toggleTheme();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.hintColor,
        title: Text(
          'Motion Sensor',
          style: TextStyle(color: theme.primaryColor),
        ),
        iconTheme: IconThemeData(
          color: theme.primaryColor, // This sets the back arrow color
        ),
      ),
      body: Container(
        color: theme.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isNear ? 'You are close!' : 'Get Near To Change Theme',
                style: TextStyle(color: theme.hintColor),
              ),
              Lottie.asset(
                'lib/assets/Animation - 1712058538433.json',
                width: 400,
                height: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

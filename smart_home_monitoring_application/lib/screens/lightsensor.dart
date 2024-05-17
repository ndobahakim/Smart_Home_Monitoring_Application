// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

class LightSensorPage extends StatefulWidget {
  @override
  _LightSensorPageState createState() => _LightSensorPageState();
}

class _LightSensorPageState extends State<LightSensorPage> {
  double _lightIntensity = 0.0;
  bool _showHighIntensityPopup = true; // Flag for showing high intensity popup
  bool _showLowIntensityPopup = true; // Flag for showing low intensity popup
  late StreamSubscription<int> _lightSubscription;

  @override
  void initState() {
    super.initState();
    _startListeningToLightSensor();
  }

  @override
  void dispose() {
    _lightSubscription.cancel();
    super.dispose();
  }

  void _startListeningToLightSensor() {
    LightSensor.hasSensor().then((hasSensor) {
      if (hasSensor) {
        _lightSubscription = LightSensor.luxStream().listen((int luxValue) {
          setState(() {
            _lightIntensity = luxValue.toDouble();
            checkAndTriggerPopups();
          });
        });
      } else {
        print("Device does not have a light sensor");
      }
    });
  }

  void checkAndTriggerPopups() {
    // Check for the specific intensity values to trigger popups
    if (_lightIntensity == 40000.0 && _showHighIntensityPopup) {
      _showPopup('High Light Intensity', 'Ambient light level is at its highest.');
      _showHighIntensityPopup = false; // Prevent further high intensity popups until condition resets
    } else if (_lightIntensity != 40000.0) {
      _showHighIntensityPopup = true; // Reset the flag when not at 40000
    }

    if (_lightIntensity == 0 && _showLowIntensityPopup) {
      _showPopup('Low Light Intensity', 'Ambient light level is at its lowest.');
      _showLowIntensityPopup = false; // Prevent further low intensity popups until condition resets
    } else if (_lightIntensity != 0) {
      _showLowIntensityPopup = true; // Reset the flag when not at 0
    }
  }

  void _showPopup(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double containerOpacity = 1 - (_lightIntensity / 40000);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.hintColor,
        title: Text(
          'Light Sensor',
          style: TextStyle(color: theme.primaryColor),
        ),
        iconTheme: IconThemeData(
          color: theme.primaryColor,
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
              right: 20,
              left: 20,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 255, 255)
                      .withOpacity(containerOpacity),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 250, 250, 250)
                          .withOpacity(containerOpacity),
                      blurRadius: 10,
                      spreadRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'lib/assets/bulb.png',
              width: 1000,
              height: 1000,
            ),
          ],
        ),
      ),
    );
  }
}

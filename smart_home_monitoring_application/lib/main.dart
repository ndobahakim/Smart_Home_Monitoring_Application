// ignore_for_file: prefer_const_constructors, use_super_parameters, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:ndobasmarthomesensormobileapp/components/ThemeProvider.dart';
import 'package:ndobasmarthomesensormobileapp/screens/StepCounter.dart';
import 'package:ndobasmarthomesensormobileapp/screens/compass.dart';
import 'package:ndobasmarthomesensormobileapp/screens/lightsensor.dart';
import 'package:ndobasmarthomesensormobileapp/screens/maps.dart';
import 'package:ndobasmarthomesensormobileapp/screens/proximitysensor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
  await initNotifications();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      // Handle notification tap
    },
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Mobile App',
      theme: themeNotifier.currentTheme,
      home: const MyHomePage(title: 'Smart Home Monitoring App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.hintColor,
        title: Text(
          widget.title,
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
      body: Center(
        child: Text(
          'Real-Time Monitoring and Smart Automation for Your Home',
          style: TextStyle(color: theme.hintColor, fontWeight:FontWeight.bold),
        ),
      ),
      floatingActionButton: _buildSpeedDial(context, themeNotifier, theme),
    );
  }

  Widget _buildSpeedDial(
      BuildContext context, ThemeNotifier themeNotifier, ThemeData theme) {
    return SpeedDial(
      icon: Icons.sensors,
      activeIcon: Icons.close,
      backgroundColor: theme.hintColor,
      foregroundColor: theme.primaryColor,
      overlayColor: Colors.transparent,
      children: [
        SpeedDialChild(
          child: Icon(Icons.mode_night, color: theme.primaryColor,),
          backgroundColor: theme.hintColor,
          label: 'Dark Mode',
          onTap: () => themeNotifier.toggleTheme(),
          
        ),
        SpeedDialChild(
          child: Icon(Icons.directions,
              color: theme.primaryColor),
              backgroundColor: theme.hintColor,
              label: 'DirectionFinder',
              onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CompassPage())),
        ),
        SpeedDialChild(
          child: Icon(Icons.gps_fixed, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Map - Geofencing',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MapPage())),
        ),
        
        
        SpeedDialChild(
          child: Icon(Icons.light_mode, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Light Level Sensor',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LightSensorPage())),
        ),
        SpeedDialChild(
          child: Icon(Icons.run_circle, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Footstep Counter',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => StepCounterPage())),
        ),
        SpeedDialChild(
          child: Icon(Icons.sensor_window, color: theme.primaryColor),
          backgroundColor: theme.hintColor,
          label: 'Motion Sensor',
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProximityPage())),
        ),
        
      ],
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use, prefer_const_constructors, sized_box_for_whitespace, prefer_const_declarations

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class CompassPage extends StatefulWidget {
  @override
  _CompassPageState createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double _heading = 0.0;
  late StreamSubscription<MagnetometerEvent> _magnetometerSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize the magnetometer sensor subscription
    _startListeningToMagnetometer();
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is disposed
    _magnetometerSubscription.cancel();
    super.dispose();
  }

  void _startListeningToMagnetometer() {
    _magnetometerSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      // Calculate the heading based on magnetometer data
      double heading = math.atan2(event.y, event.x);
      setState(() {
        _heading = heading;
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
          'DirectionFinder',
          style: TextStyle(color: theme.primaryColor),
        ),
        iconTheme: IconThemeData(
          color: theme.primaryColor,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(300, 300),
              painter: CompassPainter(heading: _heading, themeColor: theme.hintColor), // Pass theme color
              child: Container(
                width: 200,
                height: 200,
                child: Transform.rotate(
                  angle: -_heading - math.pi / 2,
                  child: Image.asset(
                    'lib/assets/compass-arrow-navigation.png',
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 250),
            Text(
              'Heading: ${(_heading * 180 / math.pi).toStringAsFixed(2)}°',
              style: TextStyle(fontSize: 24, color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final double heading;
  final Color themeColor;

  CompassPainter({required this.heading, required this.themeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    // Define compass point labels
    final List<String> points = ['E', 'NE', 'N', 'NW', 'W', 'SW', 'S', 'SE'];

    // Increase the spacing between compass points and center
    final double textOffset = 40.0;

    // Define text style for normal points
    final TextStyle textStyle = TextStyle(color: themeColor, fontSize: 20.0, fontWeight: FontWeight.bold); // Modified color

    // Define text style for the bold point
    final TextStyle boldTextStyle = TextStyle(
        color: const Color.fromARGB(255, 105, 29, 24), fontSize: 35.0, fontWeight: FontWeight.bold); // Modified color

    // Determine the sector size
    final double sectorSize = 2 * math.pi / points.length;

    // Calculate the normalized heading between 0 and 2*pi
    double normalizedHeading = heading % (2 * math.pi);
    if (normalizedHeading < 0) {
      normalizedHeading += 2 * math.pi;
    }

    // Determine the sector index where the arrow is pointing
    int arrowSectorIndex =
        ((normalizedHeading + math.pi / 8) / sectorSize).floor() %
            points.length;

    // Loop through each compass point and draw lines and text
    for (int i = 0; i < points.length; i++) {
      final double angle = (2 * math.pi / points.length) * i;
      final double textX = centerX + math.cos(angle) * (radius + textOffset);
      final double textY = centerY - math.sin(angle) * (radius + textOffset);

      // Draw lines
      final double lineX = centerX + math.cos(angle) * radius;
      final double lineY = centerY - math.sin(angle) * radius;

      canvas.drawLine(Offset(centerX, centerY), Offset(lineX, lineY),
          Paint()..color = themeColor); // Modified color

      // Determine if the point should be bold
      bool isBold = arrowSectorIndex == i;

      // Draw text with appropriate style
      TextSpan span =
          TextSpan(style: isBold ? boldTextStyle : textStyle, text: points[i]);
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(textX - tp.width / 2, textY - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

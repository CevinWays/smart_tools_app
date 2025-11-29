import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class LevelerScreen extends StatefulWidget {
  const LevelerScreen({super.key});

  @override
  State<LevelerScreen> createState() => _LevelerScreenState();
}

class _LevelerScreenState extends State<LevelerScreen> {
  double x = 0, y = 0;
  StreamSubscription<AccelerometerEvent>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      setState(() {
        // Low pass filter to smooth out movements
        x = event.x * 0.1 + x * 0.9;
        y = event.y * 0.1 + y * 0.9;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate angle in degrees
    // Assuming device is held flat (z-axis is gravity)
    // x and y are acceleration in m/s^2

    // Simple 2D bubble level logic
    // Map -10 to 10 range to screen coordinates

    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Sensitivity factor
    const sensitivity = 20.0;

    double bubbleX = centerX - (x * sensitivity);
    double bubbleY = centerY + (y * sensitivity);

    // Clamp to circle
    final maxRadius = 100.0;
    final dx = bubbleX - centerX;
    final dy = bubbleY - centerY;
    final dist = math.sqrt(dx * dx + dy * dy);

    if (dist > maxRadius) {
      final angle = math.atan2(dy, dx);
      bubbleX = centerX + maxRadius * math.cos(angle);
      bubbleY = centerY + maxRadius * math.sin(angle);
    }

    bool isLevel = x.abs() < 0.5 && y.abs() < 0.5;

    return Scaffold(
      appBar: AppBar(title: const Text('Bubble Level')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey[600]!, width: 2),
                  ),
                ),
                // Inner target circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isLevel ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                ),
                // Crosshairs
                Container(width: 280, height: 1, color: Colors.grey),
                Container(width: 1, height: 280, color: Colors.grey),

                // Bubble
                Transform.translate(
                  offset: Offset(bubbleX - centerX, bubbleY - centerY),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.greenAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              "X: ${x.toStringAsFixed(1)}  Y: ${y.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              isLevel ? "LEVEL" : "",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';

class LightIntensityScreen extends StatefulWidget {
  const LightIntensityScreen({super.key});

  @override
  State<LightIntensityScreen> createState() => _LightIntensityScreenState();
}

class _LightIntensityScreenState extends State<LightIntensityScreen> {
  int _luxValue = 0;
  StreamSubscription? _subscription;
  String _status = "Initializing...";
  Light? _light;

  @override
  void initState() {
    super.initState();
    _initLightSensor();
  }

  void _initLightSensor() async {
    try {
      _light = Light();
      _subscription = _light!.lightSensorStream.listen(
        (lux) {
          setState(() {
            _luxValue = lux;
            _status = "";
          });
        },
        onError: (error) {
          setState(() => _status = "Error: $error");
        },
      );
    } catch (e) {
      setState(() => _status = "Error initializing sensor: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  String _getLightLevel() {
    if (_luxValue < 10) return "Dark";
    if (_luxValue < 50) return "Dim";
    if (_luxValue < 200) return "Normal";
    if (_luxValue < 1000) return "Bright";
    return "Very Bright";
  }

  Color _getLightColor() {
    if (_luxValue < 10) return Colors.grey[900]!;
    if (_luxValue < 50) return Colors.grey[700]!;
    if (_luxValue < 200) return Colors.amber[700]!;
    if (_luxValue < 1000) return Colors.yellow;
    return Colors.yellow[100]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Light Intensity')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_status, style: const TextStyle(color: Colors.red)),
              ),
            Icon(Icons.wb_sunny, size: 100, color: _getLightColor()),
            const SizedBox(height: 40),
            Text(
              '$_luxValue',
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Lux',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              _getLightLevel(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: _getLightColor(),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 300,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[900]!,
                    Colors.grey[700]!,
                    Colors.amber[700]!,
                    Colors.yellow,
                    Colors.yellow[100]!,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

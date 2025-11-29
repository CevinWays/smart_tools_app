import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundMeterScreen extends StatefulWidget {
  const SoundMeterScreen({super.key});

  @override
  State<SoundMeterScreen> createState() => _SoundMeterScreenState();
}

class _SoundMeterScreenState extends State<SoundMeterScreen> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  double _decibels = 0.0;
  double _maxDecibels = 0.0;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter();
    _start();
  }

  void _start() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        _noiseSubscription = _noiseMeter.noise.listen(
          (NoiseReading noiseReading) {
            setState(() {
              _decibels = noiseReading.meanDecibel;
              if (_decibels > _maxDecibels) {
                _maxDecibels = _decibels;
              }
            });
          },
          onError: (Object error) {
            debugPrint(error.toString());
          },
        );
        setState(() => _isRecording = true);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  void _stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      setState(() => _isRecording = false);
    } catch (err) {
      debugPrint('stopRecorder error: $err');
    }
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound Meter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _decibels.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'dB',
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Max: ${_maxDecibels.toStringAsFixed(1)} dB',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (_decibels / 120).clamp(0.0, 1.0),
              minHeight: 20,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _decibels > 80
                    ? Colors.red
                    : (_decibels > 50 ? Colors.orange : Colors.green),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isRecording ? _stop : _start,
        child: Icon(_isRecording ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}

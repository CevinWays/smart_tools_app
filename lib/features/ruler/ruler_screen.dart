import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RulerScreen extends StatefulWidget {
  const RulerScreen({super.key});

  @override
  State<RulerScreen> createState() => _RulerScreenState();
}

class _RulerScreenState extends State<RulerScreen> {
  double pixelsPerCm = 38.0; // Default approximation

  @override
  void initState() {
    super.initState();
    _loadCalibration();
  }

  Future<void> _loadCalibration() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pixelsPerCm = prefs.getDouble('ruler_ppcm') ?? 38.0;
    });
  }

  Future<void> _saveCalibration(double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('ruler_ppcm', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Calibrate'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Adjust slider until the ruler matches a real ruler.',
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Slider(
                            value: pixelsPerCm,
                            min: 20.0,
                            max: 60.0,
                            onChanged: (value) {
                              setState(() => pixelsPerCm = value);
                              this.setState(() {}); // Update main screen
                            },
                            onChangeEnd: (value) {
                              _saveCalibration(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // CM Ruler
          Expanded(
            child: Container(
              color: Colors.orange[50],
              child: CustomPaint(
                painter: RulerPainter(pixelsPerCm: pixelsPerCm, isMetric: true),
                size: Size.infinite,
              ),
            ),
          ),
          // Inch Ruler
          Expanded(
            child: Container(
              color: Colors.yellow[50],
              child: CustomPaint(
                painter: RulerPainter(
                  pixelsPerCm: pixelsPerCm,
                  isMetric: false,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RulerPainter extends CustomPainter {
  final double pixelsPerCm;
  final bool isMetric;

  RulerPainter({required this.pixelsPerCm, required this.isMetric});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    double unitPixels = isMetric ? pixelsPerCm : (pixelsPerCm * 2.54);
    double totalUnits = size.height / unitPixels;

    for (int i = 0; i <= totalUnits; i++) {
      double y = i * unitPixels;

      // Major tick
      canvas.drawLine(
        Offset(isMetric ? 0 : size.width, y),
        Offset(isMetric ? 40 : size.width - 40, y),
        paint,
      );

      // Label
      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(color: Colors.black, fontSize: 14),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          isMetric ? 45 : size.width - 45 - textPainter.width,
          y - textPainter.height / 2,
        ),
      );

      // Minor ticks
      int subdivisions = isMetric ? 10 : 8; // mm or 1/8th inch
      for (int j = 1; j < subdivisions; j++) {
        double subY = y + (j * unitPixels / subdivisions);
        if (subY > size.height) break;

        double length = 10.0;
        if (isMetric && j == 5) length = 20.0; // Half cm
        if (!isMetric && j == 4) length = 20.0; // Half inch
        if (!isMetric && (j == 2 || j == 6)) length = 15.0; // Quarter inch

        canvas.drawLine(
          Offset(isMetric ? 0 : size.width, subY),
          Offset(isMetric ? length : size.width - length, subY),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant RulerPainter oldDelegate) {
    return oldDelegate.pixelsPerCm != pixelsPerCm ||
        oldDelegate.isMetric != isMetric;
  }
}

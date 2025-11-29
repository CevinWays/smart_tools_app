import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compass')),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error reading heading: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          double? direction = snapshot.data!.heading;

          if (direction == null) {
            return const Center(child: Text("Device does not have sensors!"));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${direction.ceil()}°",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getDirectionLabel(direction),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: (direction * (math.pi / 180) * -1),
                      child: CustomPaint(
                        size: const Size(300, 300),
                        painter: CompassPainter(
                          color:
                              Theme.of(context).iconTheme.color ?? Colors.black,
                        ),
                      ),
                    ),
                    // Fixed marker at the top
                    Positioned(
                      top: -10,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 50,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getDirectionLabel(double heading) {
    if (heading >= 337.5 || heading < 22.5) return "N";
    if (heading >= 22.5 && heading < 67.5) return "NE";
    if (heading >= 67.5 && heading < 112.5) return "E";
    if (heading >= 112.5 && heading < 157.5) return "SE";
    if (heading >= 157.5 && heading < 202.5) return "S";
    if (heading >= 202.5 && heading < 247.5) return "SW";
    if (heading >= 247.5 && heading < 292.5) return "W";
    if (heading >= 292.5 && heading < 337.5) return "NW";
    return "";
  }
}

class CompassPainter extends CustomPainter {
  final Color color;

  CompassPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw outer circle
    canvas.drawCircle(center, radius, paint);

    // Draw ticks
    for (int i = 0; i < 360; i += 2) {
      final angle = i * (math.pi / 180);
      final isMajor = i % 90 == 0;
      final isMinor = i % 30 == 0;

      final tickLength = isMajor ? 20.0 : (isMinor ? 10.0 : 5.0);
      final tickPaint = Paint()
        ..color = isMajor ? Colors.red : color
        ..strokeWidth = isMajor ? 3 : 1;

      final p1 = Offset(
        center.dx + (radius - tickLength) * math.sin(angle),
        center.dy - (radius - tickLength) * math.cos(angle),
      );
      final p2 = Offset(
        center.dx + radius * math.sin(angle),
        center.dy - radius * math.cos(angle),
      );

      canvas.drawLine(p1, p2, tickPaint);
    }

    // Draw Labels (N, E, S, W)
    _drawText(canvas, center, radius - 40, "N", 0, Colors.red);
    _drawText(canvas, center, radius - 40, "E", 90, color);
    _drawText(canvas, center, radius - 40, "S", 180, color);
    _drawText(canvas, center, radius - 40, "W", 270, color);
  }

  void _drawText(
    Canvas canvas,
    Offset center,
    double radius,
    String text,
    double angleDeg,
    Color color,
  ) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final angle = angleDeg * (math.pi / 180);
    final offset = Offset(
      center.dx + radius * math.sin(angle) - textPainter.width / 2,
      center.dy - radius * math.cos(angle) - textPainter.height / 2,
    );

    // Rotate text to be upright relative to the dial?
    // Usually on a compass dial, the letters rotate with it.
    // So we just draw them at the correct position.

    // However, if we want the text to be readable (upright) when it's at the top,
    // we might need to rotate the canvas. But standard compasses have fixed text on the dial.

    canvas.save();
    canvas.translate(
      offset.dx + textPainter.width / 2,
      offset.dy + textPainter.height / 2,
    );
    canvas.rotate(
      -angle,
    ); // Rotate text to align with the circle radius? Or keep it upright?
    // Let's keep it upright relative to the dial (so "N" is always top of the dial).
    // Actually, "N" should be at the top of the dial.
    // Since we rotate the whole CustomPaint, the text will rotate with it.
    // So we just draw it normally at the position.
    canvas.translate(
      -(offset.dx + textPainter.width / 2),
      -(offset.dy + textPainter.height / 2),
    );

    textPainter.paint(canvas, offset);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Flashlight')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  if (isActive) {
                    await TorchLight.disableTorch();
                  } else {
                    await TorchLight.enableTorch();
                  }
                  setState(() {
                    isActive = !isActive;
                  });
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Flashlight not available')),
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? const Color(0xFF4CAF50)
                      : (isDark ? Colors.grey[800] : Colors.grey[300]),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF4CAF50,
                            ).withValues(alpha: 0.6),
                            blurRadius: 50,
                            spreadRadius: 20,
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFF4CAF50,
                            ).withValues(alpha: 0.3),
                            blurRadius: 100,
                            spreadRadius: 40,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                ),
                child: Icon(
                  Icons.power_settings_new,
                  size: 100,
                  color: isActive ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              isActive ? 'ON' : 'OFF',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

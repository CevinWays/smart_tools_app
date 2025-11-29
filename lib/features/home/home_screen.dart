import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tools_app/core/theme/theme_cubit.dart';
import 'package:smart_tools_app/features/flashlight/flashlight_screen.dart';
import 'package:smart_tools_app/features/compass/compass_screen.dart';
import 'package:smart_tools_app/features/ruler/ruler_screen.dart';
import 'package:smart_tools_app/features/calculator/calculator_screen.dart';
import 'package:smart_tools_app/features/speedometer/speedometer_screen.dart';
import 'package:smart_tools_app/features/sound_meter/sound_meter_screen.dart';
import 'package:smart_tools_app/features/stopwatch/stopwatch_screen.dart';
import 'package:smart_tools_app/features/sound_recorder/sound_recorder_screen.dart';
import 'package:smart_tools_app/features/bmi_calculator/bmi_calculator_screen.dart';
import 'package:smart_tools_app/features/leveler/leveler_screen.dart';
import 'package:smart_tools_app/features/light_intensity/light_intensity_screen.dart';
import 'package:smart_tools_app/features/system_info/system_info_screen.dart';
import 'package:smart_tools_app/features/qr_scanner/qr_scanner_screen.dart';
import 'package:smart_tools_app/features/age_calculator/age_calculator_screen.dart';
import 'package:smart_tools_app/features/battery_info/battery_info_screen.dart';
import 'package:smart_tools_app/features/network_speed/network_speed_screen.dart';
import 'package:smart_tools_app/features/text_scanner/text_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _ToolItem(
        icon: Icons.flashlight_on,
        label: 'Flashlight',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FlashlightScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.explore,
        label: 'Compass',
        color: Colors.red,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompassScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.straighten,
        label: 'Ruler',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RulerScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.calculate,
        label: 'Calculator',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CalculatorScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.speed,
        label: 'Speedometer',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SpeedometerScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.graphic_eq,
        label: 'Sound Meter',
        color: Colors.teal,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SoundMeterScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.timer,
        label: 'Stopwatch',
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StopwatchScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.mic,
        label: 'Recorder',
        color: Colors.pink,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SoundRecorderScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.monitor_weight,
        label: 'BMI',
        color: Colors.cyan,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BmiCalculatorScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.compress,
        label: 'Leveler',
        color: Colors.brown,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LevelerScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.light_mode,
        label: 'Light',
        color: Colors.amber,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LightIntensityScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.info,
        label: 'System Info',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SystemInfoScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.qr_code_scanner,
        label: 'QR Scanner',
        color: Colors.deepOrange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QrScannerScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.cake,
        label: 'Age Calc',
        color: Colors.pinkAccent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AgeCalculatorScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.battery_full,
        label: 'Battery',
        color: Colors.lightGreen,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BatteryInfoScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.network_check,
        label: 'Network',
        color: Colors.blueGrey,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NetworkSpeedScreen()),
        ),
      ),
      _ToolItem(
        icon: Icons.document_scanner,
        label: 'Text Scan',
        color: Colors.deepPurpleAccent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TextScannerScreen()),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Tools',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: tools.length,
        itemBuilder: (context, index) => tools[index],
      ),
    );
  }
}

class _ToolItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ToolItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

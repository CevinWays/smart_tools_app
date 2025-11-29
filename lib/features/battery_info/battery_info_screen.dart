import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryInfoScreen extends StatefulWidget {
  const BatteryInfoScreen({super.key});

  @override
  State<BatteryInfoScreen> createState() => _BatteryInfoScreenState();
}

class _BatteryInfoScreenState extends State<BatteryInfoScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _getBatteryInfo();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((
      BatteryState state,
    ) {
      setState(() {
        _batteryState = state;
      });
    });
  }

  Future<void> _getBatteryInfo() async {
    final level = await _battery.batteryLevel;
    final state = await _battery.batteryState;
    setState(() {
      _batteryLevel = level;
      _batteryState = state;
    });
  }

  @override
  void dispose() {
    _batteryStateSubscription?.cancel();
    super.dispose();
  }

  IconData _getBatteryIcon() {
    if (_batteryState == BatteryState.charging) {
      return Icons.battery_charging_full;
    }
    if (_batteryLevel > 90) return Icons.battery_full;
    if (_batteryLevel > 70) return Icons.battery_6_bar;
    if (_batteryLevel > 50) return Icons.battery_5_bar;
    if (_batteryLevel > 30) return Icons.battery_3_bar;
    if (_batteryLevel > 10) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  Color _getBatteryColor() {
    if (_batteryState == BatteryState.charging) return Colors.green;
    if (_batteryLevel > 50) return Colors.green;
    if (_batteryLevel > 20) return Colors.orange;
    return Colors.red;
  }

  String _getBatteryStateText() {
    switch (_batteryState) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.full:
        return 'Full';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.unknown:
        return 'Unknown';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Info')),
      body: RefreshIndicator(
        onRefresh: _getBatteryInfo,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  Icon(_getBatteryIcon(), size: 120, color: _getBatteryColor()),
                  const SizedBox(height: 16),
                  Text(
                    '$_batteryLevel%',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: _getBatteryColor(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getBatteryStateText(),
                    style: const TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoCard(
              'Battery Level',
              '$_batteryLevel%',
              Icons.battery_std,
              _getBatteryColor(),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Status',
              _getBatteryStateText(),
              Icons.info,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Estimated Time',
              _batteryState == BatteryState.charging
                  ? 'Charging...'
                  : _batteryLevel > 0
                  ? '~${(_batteryLevel / 10).toStringAsFixed(1)} hours'
                  : 'N/A',
              Icons.access_time,
              Colors.purple,
            ),
            const SizedBox(height: 24),
            const Text(
              'Pull down to refresh',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkSpeedScreen extends StatefulWidget {
  const NetworkSpeedScreen({super.key});

  @override
  State<NetworkSpeedScreen> createState() => _NetworkSpeedScreenState();
}

class _NetworkSpeedScreenState extends State<NetworkSpeedScreen> {
  final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = [ConnectivityResult.none];
    }
    if (!mounted) return;
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  String _getConnectionType() {
    if (_connectionStatus.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (_connectionStatus.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (_connectionStatus.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else {
      return 'No Connection';
    }
  }

  IconData _getConnectionIcon() {
    if (_connectionStatus.contains(ConnectivityResult.wifi)) {
      return Icons.wifi;
    } else if (_connectionStatus.contains(ConnectivityResult.mobile)) {
      return Icons.signal_cellular_alt;
    } else if (_connectionStatus.contains(ConnectivityResult.ethernet)) {
      return Icons.settings_ethernet;
    } else {
      return Icons.signal_wifi_off;
    }
  }

  Color _getConnectionColor() {
    if (_connectionStatus.contains(ConnectivityResult.none)) {
      return Colors.red;
    }
    return Colors.green;
  }

  Future<void> _testSpeed() async {
    setState(() => _isTesting = true);
    // Simulate speed test
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isTesting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Speed')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    _getConnectionIcon(),
                    size: 100,
                    color: _getConnectionColor(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getConnectionType(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _getConnectionColor(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoCard(
              'Connection Type',
              _getConnectionType(),
              _getConnectionIcon(),
              _getConnectionColor(),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Status',
              _connectionStatus.contains(ConnectivityResult.none)
                  ? 'Disconnected'
                  : 'Connected',
              Icons.info,
              _getConnectionColor(),
            ),
            const SizedBox(height: 24),
            if (!_connectionStatus.contains(ConnectivityResult.none))
              ElevatedButton.icon(
                onPressed: _isTesting ? null : _testSpeed,
                icon: _isTesting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.speed),
                label: Text(_isTesting ? 'Testing...' : 'Test Speed'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Note: Speed testing requires additional implementation',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
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

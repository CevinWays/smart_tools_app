import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class SystemInfoScreen extends StatefulWidget {
  const SystemInfoScreen({super.key});

  @override
  State<SystemInfoScreen> createState() => _SystemInfoScreenState();
}

class _SystemInfoScreenState extends State<SystemInfoScreen> {
  Map<String, String> _deviceInfo = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String> info = {};

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        info = {
          'Device': androidInfo.model,
          'Manufacturer': androidInfo.manufacturer,
          'Brand': androidInfo.brand,
          'Android Version': androidInfo.version.release,
          'SDK': androidInfo.version.sdkInt.toString(),
          'Board': androidInfo.board,
          'Hardware': androidInfo.hardware,
          'Product': androidInfo.product,
          'Display': androidInfo.display,
          'ID': androidInfo.id,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        info = {
          'Device': iosInfo.name,
          'Model': iosInfo.model,
          'System Name': iosInfo.systemName,
          'System Version': iosInfo.systemVersion,
          'Machine': iosInfo.utsname.machine,
          'Is Physical Device': iosInfo.isPhysicalDevice.toString(),
        };
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        info = {
          'Name': linuxInfo.name,
          'Version': linuxInfo.version ?? 'N/A',
          'ID': linuxInfo.id,
          'Pretty Name': linuxInfo.prettyName,
          'Version Codename': linuxInfo.versionCodename ?? 'N/A',
          'Machine': linuxInfo.machineId ?? 'N/A',
        };
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        info = {
          'Computer Name': windowsInfo.computerName,
          'Number of Cores': windowsInfo.numberOfCores.toString(),
          'System Memory':
              '${(windowsInfo.systemMemoryInMegabytes / 1024).toStringAsFixed(2)} GB',
        };
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfoPlugin.macOsInfo;
        info = {
          'Computer Name': macInfo.computerName,
          'Host Name': macInfo.hostName,
          'Model': macInfo.model,
          'Kernel Version': macInfo.kernelVersion,
          'OS Release': macInfo.osRelease,
        };
      }
    } catch (e) {
      info = {'Error': 'Failed to load device info: $e'};
    }

    setState(() {
      _deviceInfo = info;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Info')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _deviceInfo.length,
              itemBuilder: (context, index) {
                final key = _deviceInfo.keys.elementAt(index);
                final value = _deviceInfo[key]!;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(value),
                  ),
                );
              },
            ),
    );
  }
}

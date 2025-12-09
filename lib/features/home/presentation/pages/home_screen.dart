import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tools_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:smart_tools_app/features/home/presentation/cubit/home_state.dart';

import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..initLocation(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(context, state),
                Expanded(child: _buildPanicButton(context, state)),
                _buildQuickActions(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                state.position != null
                    ? 'Lat: ${state.position!.latitude.toStringAsFixed(5)} Lng: ${state.position!.longitude.toStringAsFixed(5)}'
                    : 'Fetching Location...',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => context.read<HomeCubit>().shareLocation(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.placemark != null
                      ? '${state.placemark!.street}, ${state.placemark!.locality}, ${state.placemark!.country}'
                      : 'Fetching Address...',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              state.position != null
                  ? 'Accuracy: ${state.position!.accuracy.toStringAsFixed(1)} m'
                  : 'Accuracy: --',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanicButton(BuildContext context, HomeState state) {
    return Center(
      child: GestureDetector(
        onLongPressStart: (_) => context.read<HomeCubit>().setPanicActive(true),
        onLongPressEnd: (_) => context.read<HomeCubit>().setPanicActive(false),
        onLongPress: () {
          // Trigger Panic Action
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SOS TRIGGERED! Sending alerts...')),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: state.isPanicActive ? 220 : 200,
          height: state.isPanicActive ? 220 : 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD32F2F),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD32F2F).withValues(alpha: 0.4),
                blurRadius: state.isPanicActive ? 30 : 20,
                spreadRadius: state.isPanicActive ? 10 : 5,
              ),
            ],
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: const Center(
            child: Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, HomeState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () async {
                  // Placeholder for Camera intent
                  // For now just request permission as a dummy action
                  await Permission.camera.request();
                },
              ),
              _ActionButton(
                icon: Icons.mic,
                label: 'Voice',
                onTap: () async {
                  await Permission.microphone.request();
                },
              ),
              _ActionButton(
                icon: Icons.videocam,
                label: 'Video',
                onTap: () async {
                  await Permission.camera.request();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: Icons.gps_fixed,
                label: 'GPS',
                isActive: state.position != null,
                onTap: () async {
                  await openAppSettings();
                },
              ),
              _ActionButton(
                icon: Icons.wifi,
                label: 'Data',
                isActive:
                    true, // Hard to check actual toggle state without platform channel
                onTap: () async {
                  // Open settings
                  await openAppSettings();
                },
              ),
              _ActionButton(
                icon: Icons.flashlight_on,
                label: 'Flash',
                isActive: state.isFlashlightOn,
                onTap: () => context.read<HomeCubit>().toggleFlashlight(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? Colors.red : Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: isActive ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

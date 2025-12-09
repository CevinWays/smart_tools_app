import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_tools_app/features/profile/data/repositories/profile_repository.dart';
import 'package:smart_tools_app/features/profile/domain/entities/user_profile.dart';
import 'package:smart_tools_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:smart_tools_app/features/profile/presentation/cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileRepository())..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Medis'),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await context.push('/profile/edit', extra: state.profile);
                    if (context.mounted) {
                      context.read<ProfileCubit>().loadProfile();
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ProfileLoaded) {
            return _buildProfileContent(context, state.profile);
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum ada data diri'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await context.push('/profile/edit');
                      if (context.mounted) {
                        context.read<ProfileCubit>().loadProfile();
                      }
                    },
                    child: const Text('Isi Data Diri'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(profile),
          const SizedBox(height: 24),
          _buildInfoTile(
            'Tanggal Lahir',
            profile.dob != null
                ? DateFormat('dd MMMM yyyy').format(profile.dob!)
                : '-',
          ),
          _buildInfoTile('Jenis Kelamin', profile.gender),
          _buildInfoTile('Golongan Darah', profile.bloodType),
          const Divider(height: 32),
          const Text(
            'Kontak Darurat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            profile.emergencyContact.isNotEmpty
                ? profile.emergencyContact
                : '-',
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(height: 32),
          const Text(
            'Riwayat Medis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSection('Riwayat Penyakit', profile.medicalHistory),
          _buildSection('Alergi', profile.allergies),
          _buildSection('Obat Rutin', profile.routineMedication),
          _buildSection('Catatan Khusus', profile.specialNotes),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: Text(
            profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            content.isNotEmpty ? content : '-',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_tools_app/features/profile/domain/entities/user_profile.dart';
import 'package:smart_tools_app/features/profile/presentation/cubit/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile? initialProfile;

  const EditProfileScreen({super.key, this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _medicalHistoryController;
  late TextEditingController _allergiesController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _routineMedicationController;
  late TextEditingController _specialNotesController;
  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _selectedDob = profile?.dob;
    _dobController = TextEditingController(
      text: _selectedDob != null
          ? DateFormat('dd-MMMM-yyyy').format(_selectedDob!)
          : '',
    );
    _genderController = TextEditingController(text: profile?.gender ?? '');
    _emergencyContactController = TextEditingController(
      text: profile?.emergencyContact ?? '',
    );
    _medicalHistoryController = TextEditingController(
      text: profile?.medicalHistory ?? '',
    );
    _allergiesController = TextEditingController(
      text: profile?.allergies ?? '',
    );
    _bloodTypeController = TextEditingController(
      text: profile?.bloodType ?? '',
    );
    _routineMedicationController = TextEditingController(
      text: profile?.routineMedication ?? '',
    );
    _specialNotesController = TextEditingController(
      text: profile?.specialNotes ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _emergencyContactController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _bloodTypeController.dispose();
    _routineMedicationController.dispose();
    _specialNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDob) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = DateFormat('dd-MMMM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              // Gender Radio Buttons
              const Text('Jenis Kelamin', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Pria'),
                      value: 'Pria',
                      groupValue: _genderController.text,
                      onChanged: (value) {
                        setState(() {
                          _genderController.text = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Wanita'),
                      value: 'Wanita',
                      groupValue: _genderController.text,
                      onChanged: (value) {
                        setState(() {
                          _genderController.text = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emergencyContactController,
                decoration: const InputDecoration(
                  labelText: 'Kontak Darurat',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicalHistoryController,
                decoration: const InputDecoration(
                  labelText: 'Riwayat Penyakit',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(
                  labelText: 'Alergi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bloodTypeController,
                decoration: const InputDecoration(
                  labelText: 'Golongan Darah',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _routineMedicationController,
                decoration: const InputDecoration(
                  labelText: 'Obat Rutin',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialNotesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Khusus (Epilepsi, Jantung, dll)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final profile = UserProfile(
                        name: _nameController.text,
                        dob: _selectedDob,
                        gender: _genderController.text,
                        emergencyContact: _emergencyContactController.text,
                        medicalHistory: _medicalHistoryController.text,
                        allergies: _allergiesController.text,
                        bloodType: _bloodTypeController.text,
                        routineMedication: _routineMedicationController.text,
                        specialNotes: _specialNotesController.text,
                      );
                      context.read<ProfileCubit>().saveProfile(profile);
                      context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

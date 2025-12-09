import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tools_app/features/contacts/data/repositories/contacts_repository.dart';
import 'package:smart_tools_app/features/contacts/domain/entities/contact_model.dart';
import 'package:smart_tools_app/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:smart_tools_app/features/contacts/presentation/cubit/contacts_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactsCubit(ContactsRepository())..loadContacts(),
      child: const _ContactsView(),
    );
  }
}

class _ContactsView extends StatelessWidget {
  const _ContactsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state.status == ContactsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ContactsStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle('Personal Contacts'),
              if (state.personalContacts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No personal contacts added yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...state.personalContacts.map(
                  (contact) => _ContactTile(contact: contact, isPersonal: true),
                ),

              const SizedBox(height: 24),
              _buildSectionTitle('Emergency Numbers'),
              ...state.defaultContacts.map(
                (contact) => _ContactTile(contact: contact, isPersonal: false),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                context.read<ContactsCubit>().addContact(
                  nameController.text,
                  phoneController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isPersonal;

  const _ContactTile({required this.contact, required this.isPersonal});

  Future<void> _makeCall(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPersonal ? Colors.blue[100] : Colors.red[100],
          child: Icon(
            isPersonal ? Icons.person : Icons.emergency,
            color: isPersonal ? Colors.blue : Colors.red,
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(contact.phone),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () => _makeCall(contact.phone),
            ),
            if (isPersonal)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () =>
                    context.read<ContactsCubit>().deleteContact(contact),
              ),
          ],
        ),
      ),
    );
  }
}

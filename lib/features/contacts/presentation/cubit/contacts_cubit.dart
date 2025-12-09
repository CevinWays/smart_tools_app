import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_tools_app/features/contacts/data/repositories/contacts_repository.dart';
import 'package:smart_tools_app/features/contacts/domain/entities/contact_model.dart';
import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactsRepository _repository;

  ContactsCubit(this._repository) : super(const ContactsState());

  Future<void> loadContacts() async {
    emit(state.copyWith(status: ContactsStatus.loading));
    try {
      final personalContacts = await _repository.getPersonalContacts();
      emit(
        state.copyWith(
          status: ContactsStatus.loaded,
          personalContacts: personalContacts,
          defaultContacts: _repository.defaultContacts,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ContactsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addContact(String name, String phone) async {
    try {
      final newContact = Contact(name: name, phone: phone, type: 'personal');
      await _repository.addContact(newContact);
      loadContacts();
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add contact: $e'));
    }
  }

  Future<void> deleteContact(Contact contact) async {
    try {
      await _repository.deleteContact(contact);
      loadContacts();
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to delete contact: $e'));
    }
  }
}

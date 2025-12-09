import 'package:equatable/equatable.dart';
import 'package:smart_tools_app/features/contacts/domain/entities/contact_model.dart';

enum ContactsStatus { initial, loading, loaded, error }

class ContactsState extends Equatable {
  final ContactsStatus status;
  final List<Contact> personalContacts;
  final List<Contact> defaultContacts;
  final String? errorMessage;

  const ContactsState({
    this.status = ContactsStatus.initial,
    this.personalContacts = const [],
    this.defaultContacts = const [],
    this.errorMessage,
  });

  ContactsState copyWith({
    ContactsStatus? status,
    List<Contact>? personalContacts,
    List<Contact>? defaultContacts,
    String? errorMessage,
  }) {
    return ContactsState(
      status: status ?? this.status,
      personalContacts: personalContacts ?? this.personalContacts,
      defaultContacts: defaultContacts ?? this.defaultContacts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    personalContacts,
    defaultContacts,
    errorMessage,
  ];
}

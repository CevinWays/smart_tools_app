import 'package:hive/hive.dart';
import 'package:smart_tools_app/features/contacts/domain/entities/contact_model.dart';

class ContactsRepository {
  static const String boxName = 'contactsBox';

  final List<Contact> defaultContacts = [
    Contact(name: 'Polisi', phone: '110', type: 'emergency'),
    Contact(name: 'Ambulans', phone: '119', type: 'emergency'),
    Contact(name: 'Pemadam Kebakaran', phone: '113', type: 'emergency'),
    Contact(name: 'SAR', phone: '115', type: 'emergency'),
    Contact(name: 'BNPB', phone: '117', type: 'emergency'),
    Contact(name: 'PLN', phone: '123', type: 'emergency'),
  ];

  Future<Box<Contact>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Contact>(boxName);
    }
    return Hive.box<Contact>(boxName);
  }

  Future<List<Contact>> getPersonalContacts() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> addContact(Contact contact) async {
    final box = await _getBox();
    await box.add(contact);
  }

  Future<void> deleteContact(Contact contact) async {
    await contact.delete();
  }
}

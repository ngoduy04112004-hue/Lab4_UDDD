import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> addNewContact(
    String name,
    String phone,
    String email,
  ) async {
    if (user == null) return;

    final Map<String, dynamic> data = {
      "name": name,
      "phone": phone,
      "email": email,
      "createdAt": FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .add(data);
    } catch (_) {}
  }

  Stream<QuerySnapshot> getContacts({String? searchQuery}) {
    if (user == null) {
      return const Stream.empty();
    }

    Query contactsQuery = _firestore
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .orderBy("name");

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final String query = searchQuery.trim();
      final String searchEnd = "$query\uf8ff";

      contactsQuery = contactsQuery
          .where("name", isGreaterThanOrEqualTo: query)
          .where("name", isLessThan: searchEnd);
    }

    return contactsQuery.snapshots();
  }

  Future<void> updateContact(
    String name,
    String phone,
    String email,
    String docID,
  ) async {
    if (user == null) return;

    final Map<String, dynamic> data = {
      "name": name,
      "phone": phone,
      "email": email,
      "updatedAt": FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .update(data);
    } catch (_) {}
  }

  Future<void> deleteContact(String docID) async {
    if (user == null) return;

    try {
      await _firestore
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .delete();
    } catch (_) {}
  }
}
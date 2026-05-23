import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqikrdnawa/backend/firebase/firestore_paths.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData({
    required String uid,
    required String email,
    required String name,
  }) async {
    await _firestore.doc(FirestorePaths.userDoc(uid)).set({
      'email': email,
      'name': name,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.doc(FirestorePaths.userDoc(uid)).get();
    return doc.data();
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.doc(FirestorePaths.userDoc(uid)).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

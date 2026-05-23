import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqikrdnawa/backend/firebase/firestore_paths.dart';
import 'package:taqikrdnawa/backend/models/favorite_item.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFavorites(String uid, FavoriteItem item) async {
    await _firestore
        .collection(FirestorePaths.userFavorites(uid))
        .doc(item.productId)
        .set(item.toMap(), SetOptions(merge: true));
  }

  Future<void> removeFromFavorites(String uid, String productId) async {
    await _firestore
        .collection(FirestorePaths.userFavorites(uid))
        .doc(productId)
        .delete();
  }

  Stream<List<FavoriteItem>> streamFavorites(String uid) {
    return _firestore
        .collection(FirestorePaths.userFavorites(uid))
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => FavoriteItem.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> toggleFavorite(String uid, FavoriteItem item) async {
    final docRef = _firestore
        .collection(FirestorePaths.userFavorites(uid))
        .doc(item.productId);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set(item.toMap(), SetOptions(merge: true));
    }
  }
}

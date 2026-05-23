import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqikrdnawa/backend/firebase/firestore_paths.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeNotification(String uid, NotificationModel notification) async {
    final docRef = _firestore.collection(FirestorePaths.userNotifications(uid)).doc();
    await docRef.set(notification.toMap(), SetOptions(merge: true));
  }

  Stream<List<NotificationModel>> fetchNotifications(String uid) {
    return _firestore
        .collection(FirestorePaths.userNotifications(uid))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> markAsRead(String uid, String notificationId) async {
    await _firestore
        .collection(FirestorePaths.userNotifications(uid))
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> deleteNotification(String uid, String notificationId) async {
    await _firestore
        .collection(FirestorePaths.userNotifications(uid))
        .doc(notificationId)
        .delete();
  }
}

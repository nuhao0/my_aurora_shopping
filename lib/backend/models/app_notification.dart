import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
  });

  factory AppNotificationItem.fromDoc(
    String id,
    Map<String, dynamic> data,
  ) {
    final ts = data['createdAt'];
    final createdAt = ts is Timestamp
        ? ts.toDate()
        : DateTime.fromMillisecondsSinceEpoch(0);
    return AppNotificationItem(
      id: id,
      title: data['title']?.toString() ?? 'Notification',
      body: data['body']?.toString() ?? '',
      createdAt: createdAt,
      read: (data['read'] as bool?) ?? false,
    );
  }
}


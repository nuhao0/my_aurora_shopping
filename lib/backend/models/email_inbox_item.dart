import 'package:cloud_firestore/cloud_firestore.dart';

class EmailInboxItem {
  EmailInboxItem({
    required this.id,
    required this.title,
    required this.preview,
    required this.createdAt,
    this.kind,
    this.sentToEmail,
  });

  final String id;
  final String title;
  final String preview;
  final DateTime? createdAt;
  final String? kind;
  final String? sentToEmail;

  factory EmailInboxItem.fromDoc(String id, Map<String, dynamic> data) {
    final ts = data['createdAt'];
    DateTime? at;
    if (ts is Timestamp) {
      at = ts.toDate();
    }
    return EmailInboxItem(
      id: id,
      title: data['title']?.toString() ?? 'Message',
      preview: data['preview']?.toString() ?? data['body']?.toString() ?? '',
      createdAt: at,
      kind: data['kind']?.toString(),
      sentToEmail: data['sentToEmail']?.toString(),
    );
  }
}

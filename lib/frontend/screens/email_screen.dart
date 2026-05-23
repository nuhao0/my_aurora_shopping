import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taqikrdnawa/backend/firebase/firestore_paths.dart';
import 'package:taqikrdnawa/backend/models/email_inbox_item.dart';
import 'package:taqikrdnawa/backend/providers/auth_provider.dart';

class EmailScreen extends StatelessWidget {
  static const routeName = '/email';
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final uid = auth.user?.uid;
    final accountEmail = auth.user?.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Email & messages')),
      body: uid == null
          ? const Center(child: Text('Sign in to see messages sent to your account.'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account email',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          accountEmail ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Order confirmations and alerts are delivered to this address '
                          'when you deploy Cloud Functions with a mail provider (e.g. SendGrid). '
                          'Copies also appear in the list below.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    'In-app message log',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection(FirestorePaths.userEmailInboxCollection)
                        .orderBy('createdAt', descending: true)
                        .limit(50)
                        .snapshots(),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Could not load messages.\n'
                              '${snap.error}\n\n'
                              'Add a Firestore index on email_inbox (createdAt) if prompted, '
                              'and allow read on users/{uid}/email_inbox for signed-in uid.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      if (!snap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snap.data!.docs;
                      if (docs.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'No messages yet.\n\n'
                              'After you deploy the included Cloud Function (`functions/`), '
                              'placing an order creates a row here and sends a real email '
                              'if SENDGRID_API_KEY is set.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: docs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, i) {
                          final d = docs[i];
                          final item = EmailInboxItem.fromDoc(d.id, d.data());
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            title: Text(item.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.preview.isNotEmpty) Text(item.preview),
                                if (item.createdAt != null)
                                  Text(
                                    _formatTime(item.createdAt!),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                if (item.kind != null)
                                  Text(
                                    item.kind!,
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                              ],
                            ),
                            isThreeLine: true,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  static String _formatTime(DateTime t) {
    final local = t.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

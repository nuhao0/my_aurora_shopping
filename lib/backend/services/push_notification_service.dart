import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_service.dart';

/// Registers FCM, shows foreground alerts on Android, and saves [fcmToken] on
/// `users/{uid}` for Cloud Functions / Console campaigns.
class PushNotificationService {
  PushNotificationService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? local,
    NotificationService? notificationService,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _messaging = messaging ?? FirebaseMessaging.instance,
        _local = local ?? FlutterLocalNotificationsPlugin(),
        _notificationService = notificationService ?? NotificationService();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;
  final NotificationService _notificationService;

  static const _androidChannelId = 'taqikrdnawa_alerts';
  static const _androidChannelName = 'Orders & updates';

  Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('PushNotificationService: skipped on web (add VAPID if needed).');
      return;
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    await _local.initialize(
      settings: const InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
      ),
    );

    final androidPlugin = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        importance: Importance.high,
      ),
    );
    await androidPlugin?.requestNotificationsPermission();

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('PushNotificationService: user denied notification permission.');
    }

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    _auth.authStateChanges().listen((user) async {
      if (user == null) return;
      await _persistTokenForUser(user.uid);
    });

    _messaging.onTokenRefresh.listen((token) async {
      final user = _auth.currentUser;
      if (user != null) {
        await _saveToken(user.uid, token);
      }
    });

    final user = _auth.currentUser;
    if (user != null) {
      await _persistTokenForUser(user.uid);
    }
  }

  Future<void> _persistTokenForUser(String uid) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveToken(uid, token);
      }
    } catch (e, st) {
      debugPrint('PushNotificationService: getToken failed: $e\n$st');
    }
  }

  Future<void> _saveToken(String uid, String token) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {
          'fcmToken': token,
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e, st) {
      debugPrint('PushNotificationService: save token failed: $e\n$st');
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ??
        message.data['title']?.toString() ??
        'Notification';
    final body = notification?.body ??
        message.data['body']?.toString() ??
        '';

    await showLocalNotification(title: title, body: body, payload: message.data.toString());
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
    String? uid,
    bool showSystemNotification = true,
  }) async {
    if (showSystemNotification) {
      final androidDetails = AndroidNotificationDetails(
        _androidChannelId,
        _androidChannelName,
        importance: Importance.high,
        priority: Priority.high,
      );
      const darwinDetails = DarwinNotificationDetails();

      final notificationId = id ?? (title + body).hashCode & 0x7fffffff;

      await _local.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: androidDetails,
          iOS: darwinDetails,
        ),
        payload: payload,
      );
    }

    // Persist to Firestore if UID is provided
    if (uid != null) {
      await _notificationService.storeNotification(
        uid,
        NotificationModel(
          id: '', // Will be generated by Firestore
          title: title,
          body: body,
          createdAt: DateTime.now(),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/notification_service.dart';

class NotificationsController extends GetxController {
  final NotificationService _notificationService;

  NotificationsController({required NotificationService notificationService})
      : _notificationService = notificationService;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  bool _isInitialLoad = true;
  String? _lastNotificationId;

  @override
  void onInit() {
    super.onInit();
    // Watch the list for changes and show snackbars for new items
    ever(notifications, (List<NotificationModel> newList) {
      if (_isInitialLoad) {
        if (newList.isNotEmpty) {
          _isInitialLoad = false;
          _lastNotificationId = newList.first.id;
        }
        return;
      }

      if (newList.isNotEmpty) {
        final newest = newList.first;
        
        // Only show if it's a NEW document ID that we haven't alerted for yet
        if (newest.id != _lastNotificationId) {
          _lastNotificationId = newest.id;

          // Only show if it's very recent (within last 10 seconds)
          if (newest.createdAt.isAfter(DateTime.now().subtract(const Duration(seconds: 10)))) {
            Get.snackbar(
              newest.title,
              newest.body,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Get.theme.colorScheme.primaryContainer.withOpacity(0.9),
              colorText: Get.theme.colorScheme.onPrimaryContainer,
              icon: const Icon(Icons.notifications_active, color: Colors.pink),
              duration: const Duration(seconds: 4),
              boxShadows: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
              ],
              margin: const EdgeInsets.all(10),
              borderRadius: 15,
            );
          }
        }
      }
    });
  }

  void bindNotifications(String uid) {
    _isInitialLoad = true;
    notifications.bindStream(_notificationService.fetchNotifications(uid));
  }

  Future<void> markAsRead(String uid, String id) async {
    await _notificationService.markAsRead(uid, id);
  }

  Future<void> deleteNotification(String uid, String id) async {
    await _notificationService.deleteNotification(uid, id);
  }
}

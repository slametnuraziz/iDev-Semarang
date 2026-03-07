import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static const String _oneSignalAppId =
      '0919cc60-972a-47a2-abd4-cf5862a30582';

  static void Function(Map<String, dynamic> data)?
  onNotificationOpened;

  static Future<void> initialize() async {
    OneSignal.Debug.setLogLevel(
      OSLogLevel.verbose,
    );
    OneSignal.initialize(_oneSignalAppId);
    await OneSignal
        .Notifications.requestPermission(true);

    OneSignal.Notifications.addClickListener((
      event,
    ) {
      final data =
          event.notification.additionalData;
      debugPrint(
        '🔔 Notification Tapped! Data: $data',
      );
      if (data != null &&
          onNotificationOpened != null) {
        onNotificationOpened!(data);
      }
    });

    OneSignal
        .Notifications.addForegroundWillDisplayListener((
      event,
    ) {
      debugPrint(
        '🔔 Notification received in foreground',
      );
      event.preventDefault();
      event.notification.display();
    });

    debugPrint('✅ OneSignal initialized');
  }

  static Future<void> setExternalUserId(
    String userId,
  ) async {
    try {
      print(
        '🔔 Sebelum OneSignal.login() - userId: $userId',
      );
      await OneSignal.login(userId);
      print(
        '🔔 Sesudah OneSignal.login() - sukses',
      );

      final subId =
          OneSignal.User.pushSubscription.id;
      final subToken =
          OneSignal.User.pushSubscription.token;
      print('🔔 Subscription ID: $subId');
      print('🔔 Subscription Token: $subToken');
    } catch (e) {
      print('❌ OneSignal.login() error: $e');
    }
  }

  static Future<void> logoutUser() async {
    await OneSignal.logout();
    debugPrint('✅ OneSignal user logged out');
  }

  // ✅ FIX: tidak pakai await, langsung return
  static String? getPlayerId() {
    return OneSignal.User.pushSubscription.id;
  }

  static Future<void> setTags(
    Map<String, String> tags,
  ) async {
    OneSignal.User.addTags(tags);
    debugPrint('✅ Tags set: $tags');
  }

  static void removeTags(List<String> keys) {
    OneSignal.User.removeTags(keys);
  }
}

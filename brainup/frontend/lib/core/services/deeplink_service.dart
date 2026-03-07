import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../../features/guru/pages/guru_main_page.dart';
import '../../features/siswa/pages/siswa_main_page.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static Uri? _pendingLink;
  static final GlobalKey<NavigatorState>
  navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    debugPrint('🔗 Initializing Deep Links...');

    try {
      _pendingLink = await _appLinks
          .getInitialLink();
      debugPrint(
        '🔗 Initial link: $_pendingLink',
      );
    } catch (e) {
      debugPrint(
        '❌ Failed to get initial link: $e',
      );
    }

    _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint(
          '🔗 New deep link received: $uri',
        );
        _handleDeepLink(uri);
      },
      onError: (e) {
        debugPrint(
          '❌ Deep link stream error: $e',
        );
      },
    );

    debugPrint('✅ Deep Links initialized');
  }

  static Uri? get pendingLink => _pendingLink;

  static void clearPendingLink() {
    _pendingLink = null;
  }

  // ✅ FIX: type diubah 'jadwal' → 'jadwal_reminder' agar cocok dengan backend
  static void handleFromNotification(
    Map<String, dynamic> data,
  ) {
    final type = data['type'] as String?;
    final jadwalId = data['jadwal_id'];

    debugPrint(
      '🔔 Handle notification: type=$type, jadwalId=$jadwalId',
    );

    if (type == 'jadwal_reminder') {
      _navigateToJadwalTab(
        jadwalId: jadwalId != null
            ? int.tryParse(jadwalId.toString())
            : null,
      );
    }
  }

  static void _handleDeepLink(Uri uri) {
    debugPrint('📍 Handling deep link: $uri');

    if (uri.host == 'jadwal') {
      final jadwalId = uri.pathSegments.isNotEmpty
          ? int.tryParse(uri.pathSegments.first)
          : null;
      _navigateToJadwalTab(jadwalId: jadwalId);
    }
  }

  static void _navigateToJadwalTab({
    int? jadwalId,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint(
        '❌ Navigator context not available',
      );
      return;
    }

    final siswaState = SiswaMainPage.of(context);
    if (siswaState != null) {
      siswaState.setTabIndex(2);
      debugPrint(
        '📅 Siswa: Switched to jadwal tab',
      );
      return;
    }

    final guruState = GuruMainPage.of(context);
    if (guruState != null) {
      guruState.setTabIndex(2);
      debugPrint(
        '📅 Guru: Switched to jadwal tab',
      );
      return;
    }

    debugPrint(
      '❌ No main page found for navigation',
    );
  }

  static Future<void> handleInitialLinkAfterLogin(
    BuildContext context,
    String role,
  ) async {
    if (_pendingLink == null) return;

    debugPrint(
      '🔗 Handling pending link after login: $_pendingLink',
    );
    final uri = _pendingLink!;

    await Future.delayed(
      const Duration(milliseconds: 600),
    );

    if (!context.mounted) return;

    if (uri.host == 'jadwal') {
      _navigateToJadwalTab(
        jadwalId: uri.pathSegments.isNotEmpty
            ? int.tryParse(uri.pathSegments.first)
            : null,
      );
    }

    clearPendingLink();
  }
}

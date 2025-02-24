import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkService {
  static final _appLinks = AppLinks();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> initDeepLinks() async {
    try {
      // Handle initial app link
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        handleDeepLink(uri);
      }

      // Listen to app links while the app is running
      _appLinks.uriLinkStream.listen((uri) {
        if (uri != null) {
          handleDeepLink(uri);
        }
      });
    } catch (e) {
      debugPrint('❌ Error handling app link: $e');
    }
  }

  static void handleDeepLink(Uri uri) {
    debugPrint('🔗 Handling deep link: ${uri.toString()}');

    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'post') {
      final postId = uri.pathSegments[1];
      debugPrint('📝 Extracted postId: $postId');

      if (postId.isNotEmpty) {
        debugPrint('🚀 Navigating to post: $postId');
        navigatorKey.currentContext?.go('/?postId=$postId');
      }
    } else {
      debugPrint('⚠️ Invalid deep link format');
      navigatorKey.currentContext?.go('/');
    }
  }
}

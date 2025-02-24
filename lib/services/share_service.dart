import 'package:share_plus/share_plus.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();

  factory ShareService() {
    return _instance;
  }

  ShareService._internal();

  Future<void> shareBlogPost(String postId) async {
    final String shareUrl = 'https://vite-react-ten-tau-59.vercel.app/post/$postId';
    await Share.share('Check out this interesting blog post: $shareUrl');
  }
}
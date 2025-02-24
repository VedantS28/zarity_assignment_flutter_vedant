import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPost {
  final String id;
  final String imageURL;
  final String title;
  final String summary;
  final String content;
  final String deeplink;

  BlogPost({
    required this.id,
    required this.imageURL,
    required this.title,
    required this.summary,
    required this.content,
    required this.deeplink,
  });

  String get deepLinkUrl => 'https://vite-react-ten-tau-59.vercel.app/post/$id';

  factory BlogPost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BlogPost(
      id: doc.id,
      imageURL: data['imageURL'] ?? '',
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      content: data['content'] ?? '',
      deeplink: 'https://vite-react-ten-tau-59.vercel.app/post/${doc.id}',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageURL': imageURL,
      'title': title,
      'summary': summary,
      'content': content,
      'deeplink': deeplink,
    };
  }
}
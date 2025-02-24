import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/blog_post_model.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
  routes: [],
);

class BlogViewModel extends StateNotifier<List<BlogPost>> {
  BlogViewModel() : super([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> fetchBlogPosts() async {
    try {
      // Get blog posts from Firestore
      final QuerySnapshot snapshot =
          await _firestore.collection('blog_posts').get();

      // Convert the documents to BlogPost objects
      final List<BlogPost> posts = snapshot.docs.map((doc) {
        return BlogPost.fromFirestore(doc);
      }).toList();

      // Update the state with the fetched posts
      state = posts;
    } catch (e) {
      state = []; // Set empty list in case of error
    }
  }

  // Get a single blog post by ID
  Future<BlogPost?> getBlogPostById(String id) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('blog_posts').doc(id).get();
      if (doc.exists) {
        return BlogPost.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching blog post: $e');
      return null;
    }
  }

  Future<void> addBlogPost({
    required String title,
    required String summary,
    required String content,
    required XFile imageFile,
  }) async {
    try {
      // Upload image to Firebase Storage
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = _storage.ref().child('blog_images/$fileName');
      final uploadTask = ref.putFile(File(imageFile.path));

      final snapshot = await uploadTask;
      final String imageURL = await snapshot.ref.getDownloadURL();

      // Create new document in Firestore
      final docRef = await _firestore.collection('blog_posts').add({
        'title': title,
        'summary': summary,
        'content': content,
        'imageURL': imageURL,
        'deeplink':
            'https://vite-react-ten-tau-59.vercel.app/post/', // Base URL
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update deeplink with the generated document ID
      await docRef.update({
        'deeplink':
            'https://vite-react-ten-tau-59.vercel.app/post/${docRef.id}',
      });

      // Refresh the blog posts list
      await fetchBlogPosts();
    } catch (e) {
      print('Error adding blog post: $e');
      rethrow;
    }
  }

  // Add method to handle deep link
  void handleDeepLink(String link) {
    final uri = Uri.parse(link);
    final postId = uri.pathSegments.last;
    if (postId.isNotEmpty) {
      // Navigate to the post using GoRouter
      goRouter.go('/?postId=$postId');
    }
  }
}

final blogViewModelProvider =
    StateNotifierProvider<BlogViewModel, List<BlogPost>>((ref) {
  return BlogViewModel()..fetchBlogPosts();
});

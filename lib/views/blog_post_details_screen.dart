import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/blog_post_model.dart';
import '../services/share_service.dart';

class BlogPostDetailsScreen extends StatelessWidget {
  final BlogPost post;
  final ShareService _shareService = ShareService();

  BlogPostDetailsScreen({required this.post, Key? key}) : super(key: key);

  void _sharePost() {
    _shareService.shareBlogPost(post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: _sharePost,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Featured image
            Hero(
              tag: 'blog-image-${post.id}',
              child: CachedNetworkImage(
                imageUrl: post.imageURL,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                post.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

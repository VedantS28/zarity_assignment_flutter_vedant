import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../models/blog_post_model.dart';
import '../services/deep_link_service.dart';
import '../viewmodels/blog_viewmodel.dart';
import '../views/blog_post_details_screen.dart';
import '../views/blog_list_screen.dart';
import 'custom_page_route.dart';

final router = GoRouter(
  navigatorKey: DeepLinkService.navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(
        child: BlogListScreen(
          highlightedPostId: state.uri.queryParameters['postId'],
        ),
      ),
      builder: (context, state) {
        final postId = state.pathParameters['id'];
        if (postId == null) {
          return const Center(child: Text('Invalid post ID'));
        }

        final blogViewModel = BlogViewModel();
        return FutureBuilder<BlogPost?>(
          future: blogViewModel.getBlogPostById(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Text('Error loading post: ${snapshot.error}'),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Scaffold(
                appBar: AppBar(),
                body: const Center(
                  child: Text('Post not found'),
                ),
              );
            }

            return BlogPostDetailsScreen(post: snapshot.data!);
          },
        );
      },
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zarity_health_assignment_vedant_shrivastava/routes/custom_page_route.dart';
import 'package:zarity_health_assignment_vedant_shrivastava/views/blog_post_details_screen.dart';
import '../services/share_service.dart';
import '../viewmodels/blog_viewmodel.dart';
import '../widgets/blog_post_item.dart';

class BlogListScreen extends ConsumerStatefulWidget {
  final String? highlightedPostId;

  const BlogListScreen({this.highlightedPostId, Key? key}) : super(key: key);

  @override
  ConsumerState<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends ConsumerState<BlogListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToHighlighted = false;
  final _shareService = ShareService();

  @override
  void initState() {
    super.initState();
    if (widget.highlightedPostId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlightedPost();
      });
    }
  }

  @override
  void didUpdateWidget(BlogListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightedPostId != null && !_hasScrolledToHighlighted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlightedPost();
      });
    }
  }

  void _sharePost(String postId) {
    _shareService.shareBlogPost(postId);
  }

  void _scrollToHighlightedPost() {
    if (!mounted) return;

    final blogPosts = ref.read(blogViewModelProvider);
    final index =
        blogPosts.indexWhere((post) => post.id == widget.highlightedPostId);

    if (index != -1 && _scrollController.hasClients) {
      // Calculate total height of one item
      const double estimatedItemHeight = 340.0;
      final double offset = index * estimatedItemHeight;

      _scrollController.animateTo(
        offset - 16.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _hasScrolledToHighlighted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogPosts = ref.watch(blogViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Blog List Assignment',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          final post = blogPosts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  child: BlogPostDetailsScreen(post: post),
                ),
              );
            },
            child: BlogPostItem(
              post: post,
              onShare: () => _sharePost(post.id),
              isHighlighted: post.id == widget.highlightedPostId,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/blog_post_model.dart';

class BlogPostItem extends StatelessWidget {
  final BlogPost post;
  final bool isHighlighted;
  final VoidCallback onShare;

  const BlogPostItem({
    required this.post,
    required this.onShare,
    this.isHighlighted = false,
    Key? key,
  }) : super(key: key);

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.02,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isHighlighted
            ? Border.all(color: Theme.of(context).primaryColor, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog image
              Hero(
                tag: 'image-${post.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: post.imageURL,
                    height: isSmallScreen
                        ? constraints.maxWidth * 0.6
                        : constraints.maxWidth * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: constraints.maxWidth * 0.02),
              Padding(
                padding: EdgeInsets.all(constraints.maxWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Hero(
                      tag: 'title-${post.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          post.title,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxWidth * 0.02),

                    // Summary (truncated)
                    Text(
                      _truncateText(post.summary, isSmallScreen ? 60 : 80),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: constraints.maxWidth * 0.03),

                    // Bottom row with read more and bookmark
                    Row(
                      mainAxisSize:
                          MainAxisSize.min, // Prevents unnecessary stretching
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Read more text button
                        Flexible(
                          child: GestureDetector(
                            onTap: () => context.push('/post/${post.id}'),
                            child: Text(
                              'Read more',
                              softWrap: true,
                              overflow:
                                  TextOverflow.ellipsis, // Avoids overflow
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ),

                        // Add some spacing between text and icon
                        SizedBox(width: isSmallScreen ? 4 : 8),

                        // Share button with controlled size
                        SizedBox(
                          width: isSmallScreen ? 20 : 24,
                          height: isSmallScreen ? 20 : 24,
                          child: IconButton(
                            icon: Icon(
                              Icons.share_outlined,
                              size: isSmallScreen ? 14 : 18,
                            ),
                            onPressed: onShare,
                            padding: EdgeInsets.zero,
                            constraints:
                                const BoxConstraints(), 
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import '../../models/post.dart';

class PostFilter {
  /// Filters posts based on dynamic attributes.
  /// - If `userId` is provided, filters by `creatorId`.
  /// - If `postType` is provided, filters by `postType`.
  /// - If neither is provided, returns all posts.
  static List<Post> filterPosts({
    required List<Post> posts,
    int? userId, // Optional filter for userId
    PostType? postType, // Optional filter for postType
  }) {
    return posts.where((post) {
      // Apply filters conditionally
      bool matchesUserId = userId == null || post.creatorId == userId;
      bool matchesPostType = postType == null || post.postType == postType;

      // Return true only if all provided filters match
      return matchesUserId && matchesPostType;
    }).toList();
  }
}
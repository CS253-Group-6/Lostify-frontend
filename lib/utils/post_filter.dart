import '../../models/post.dart';

class PostFilter {
  /// Filters posts based on dynamic attributes.
  /// Optional filters include userId, postType, location, and registration date range.
  static List<Post> filterPosts({
    required List<Post> posts,
    int? userId,
    PostType? postType,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return posts.where((post) {
      bool matchesUserId = userId == null || post.creatorId == userId;
      bool matchesPostType = postType == null || post.postType == postType;
      bool matchesLocation = location == null ||
          post.address1.toLowerCase() == location.toLowerCase();
      bool matchesDate = true;
      if (startDate != null) {
        // Include posts with regDate equal or after the start date
        matchesDate = !post.regDate.isBefore(startDate);
      }
      if (endDate != null) {
        // Include posts with regDate equal or before the end date
        matchesDate = matchesDate && !post.regDate.isAfter(endDate);
      }
      return matchesUserId && matchesPostType && matchesLocation && matchesDate;
    }).toList();
  }
}

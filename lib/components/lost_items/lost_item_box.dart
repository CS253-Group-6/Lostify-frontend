// lib/components/lost_items/lost_item_box.dart

import 'package:flutter/material.dart';

import '../../models/post.dart';

const double kItemBoxOpacity = 0.7;
const double kItemBoxBorderRadius = 30.0;

/// A widget displaying basic info about a [Post].
/// When tapped, it triggers a callback to show the item details overlay
/// on the same page (LostItem or FoundItem).
class LostItemBox extends StatelessWidget {
  const LostItemBox({
    super.key,
    required this.post,
    required this.onViewDetails,
  });

  final Post post;
  final VoidCallback onViewDetails;

  String _formatDate(DateTime? date) =>
    date != null ? date.toString().split(' ')[0] : 'NA';

  Widget _buildImage() {
    if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
      final imageWidget = post.imageUrl!.startsWith('http')
          ? Image.network(post.imageUrl!, width: 80, height: 80, fit: BoxFit.cover)
          : Image.asset(post.imageUrl!, width: 80, height: 80, fit: BoxFit.cover);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      );
    }
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lowerStatus = post.status.toLowerCase();
    final statusColor = (lowerStatus == 'returned' || lowerStatus == 'found')
        ? Colors.green
        : (lowerStatus == 'not returned' || lowerStatus == 'missing')
        ? Colors.red
        : Colors.black;

    final dateLabel = (lowerStatus == 'returned' || lowerStatus == 'not returned')
        ? 'Returned Date'
        : 'Found Date';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: kItemBoxOpacity),
        borderRadius: BorderRadius.circular(kItemBoxBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text('Status: ${post.status}', style: TextStyle(color: statusColor)),
                const SizedBox(height: 4),
                Text('Registered Date: ${_formatDate(post.regDate)}'),
                const SizedBox(height: 4),
                Text('$dateLabel: ${_formatDate(post.closedDate)}'),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onViewDetails,
                  child: const Text('View'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

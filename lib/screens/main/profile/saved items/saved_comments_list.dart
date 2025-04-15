import 'package:flutter/material.dart';
import '../widgets/empty_state.dart';

class SavedCommentsList extends StatelessWidget {
  const SavedCommentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for saved comments
    final List<Map<String, dynamic>> savedComments = [
      {
        'author': 'DevExpert',
        'comment': 'If you\'re having issues with state management, I highly recommend trying Provider first before jumping to more complex solutions.',
        'post': 'Flutter State Management Comparison',
        'time': '3 days ago',
        'upvotes': 78,
      },
      {
        'author': 'MobileDev',
        'comment': 'The key to smooth animations is to avoid doing heavy work on the UI thread. Offload processing to isolates when possible.',
        'post': 'Optimizing Flutter Performance',
        'time': '1 week ago',
        'upvotes': 124,
      },
    ];

    return savedComments.isEmpty
        ? const EmptyState(
      icon: Icons.bookmark_border,
      title: 'No saved comments',
      subtitle: 'Comments you save will appear here',
    )
        : ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: savedComments.length,
      itemBuilder: (context, index) {
        final comment = savedComments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author info and bookmark icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage('https://via.placeholder.com/32x32'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['author'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            comment['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark, color: Colors.blue),
                      onPressed: () {
                        // Unsave comment functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Comment removed from saved items'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Comment content
                Text(
                  comment['comment'],
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 12),

                // Post reference
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'From post: ${comment['post']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Upvotes
                Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 16, color: Colors.grey.shade700),
                    const SizedBox(width: 4),
                    Text(
                      '${comment['upvotes']} upvotes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
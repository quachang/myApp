import 'package:flutter/material.dart';
import '../widgets/empty_state.dart';

class SavedPostsList extends StatelessWidget {
  const SavedPostsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for saved posts
    final List<Map<String, dynamic>> savedPosts = [
      {
        'author': 'JessicaT',
        'title': 'Top 10 Flutter Widgets Every Developer Should Know',
        'time': '2 days ago',
        'community': 'FlutterDev',
        'likes': 245,
        'comments': 67,
      },
      {
        'author': 'CodeMaster',
        'title': 'Building Responsive UIs in Flutter',
        'time': '1 week ago',
        'community': 'MobileDevs',
        'likes': 189,
        'comments': 42,
      },
      {
        'author': 'TechGuru',
        'title': 'The Future of Mobile App Development in 2025',
        'time': '3 weeks ago',
        'community': 'TechTrends',
        'likes': 512,
        'comments': 98,
      },
    ];

    return savedPosts.isEmpty
        ? const EmptyState(
      icon: Icons.bookmark_border,
      title: 'No saved posts',
      subtitle: 'Posts you save will appear here',
    )
        : ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: savedPosts.length,
      itemBuilder: (context, index) {
        final post = savedPosts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Community and save icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        post['community'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark, color: Colors.blue),
                      onPressed: () {
                        // Unsave post functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Post removed from saved items'),
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
                const SizedBox(height: 8),

                // Post title
                Text(
                  post['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Author and time
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage('https://via.placeholder.com/24x24'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post['author'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Post stats
                Row(
                  children: [
                    Icon(Icons.thumb_up_outlined, size: 16, color: Colors.grey.shade700),
                    const SizedBox(width: 4),
                    Text(
                      post['likes'].toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey.shade700),
                    const SizedBox(width: 4),
                    Text(
                      post['comments'].toString(),
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
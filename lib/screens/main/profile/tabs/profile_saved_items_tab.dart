import 'package:flutter/material.dart';

class ProfileSavedItemsTab extends StatelessWidget {
  final Color themeColor; // Add theme color parameter

  const ProfileSavedItemsTab({
    Key? key,
    this.themeColor = const Color(0xFFEAD78D), // Default to AppColors.primary
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nested TabBar for saved items categories
        Container(
          color: Colors.grey.shade100,
          child: DefaultTabController(
            length: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Comments'),
                    Tab(text: 'Links'),
                  ],
                ),

                // TabBarView with fixed height for the saved items content
                SizedBox(
                  height: 500, // Fixed height for the saved items content
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      _SavedPostsList(),
                      _SavedCommentsList(),
                      _SavedLinksList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Moving the list widgets into the same file to resolve import issues
class _SavedPostsList extends StatelessWidget {
  const _SavedPostsList({Key? key}) : super(key: key);

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
        ? _buildEmptyState('No saved posts', 'Posts you save will appear here')
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

class _SavedCommentsList extends StatelessWidget {
  const _SavedCommentsList({Key? key}) : super(key: key);

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
        ? _buildEmptyState('No saved comments', 'Comments you save will appear here')
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

class _SavedLinksList extends StatelessWidget {
  const _SavedLinksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for saved links
    final List<Map<String, dynamic>> savedLinks = [
      {
        'title': 'Flutter Documentation',
        'url': 'https://flutter.dev/docs',
        'description': 'Official documentation for Flutter development',
        'time': '5 days ago',
      },
      {
        'title': 'Material Design Guidelines',
        'url': 'https://material.io/design',
        'description': 'Design guidelines for creating intuitive and beautiful apps',
        'time': '2 weeks ago',
      },
      {
        'title': 'Dart Packages Repository',
        'url': 'https://pub.dev',
        'description': 'Find and use packages to build Dart and Flutter apps',
        'time': '1 month ago',
      },
    ];

    return savedLinks.isEmpty
        ? _buildEmptyState('No saved links', 'Links you save will appear here')
        : ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: savedLinks.length,
      itemBuilder: (context, index) {
        final link = savedLinks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Link title and saved time
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        link['title'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark, color: Colors.blue),
                      onPressed: () {
                        // Unsave link functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Link removed from saved items'),
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
                Text(
                  'Saved ${link['time']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),

                // URL display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          link['url'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  link['description'],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Open link functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening ${link['url']}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Open'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Share link functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sharing ${link['url']}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
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

// Helper widget for empty states
Widget _buildEmptyState(String title, String subtitle) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.bookmark_border,
          size: 64,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}
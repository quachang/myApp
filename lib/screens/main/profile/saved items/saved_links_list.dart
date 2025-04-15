import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../widgets/empty_state.dart';

class SavedLinksList extends StatelessWidget {
  const SavedLinksList({Key? key}) : super(key: key);

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
        ? const EmptyState(
      icon: Icons.bookmark_border,
      title: 'No saved links',
      subtitle: 'Links you save will appear here',
    )
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
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          link['url'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
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
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
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
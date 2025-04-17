import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/action_button.dart';

class ProfilePostsTab extends StatelessWidget {
  final String? profileImagePath;
  final Color themeColor; // Add theme color parameter

  const ProfilePostsTab({
    Key? key,
    this.profileImagePath,
    this.themeColor = const Color(0xFFEAD78D), // Default to AppColors.primary
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample posts data
    final List<Map<String, dynamic>> posts = [
      {
        'title': 'My latest project',
        'content': 'Just finished working on a new Flutter UI design. Really happy with how it turned out!',
        'time': '20 minutes ago',
        'hasImage': true,
        'likes': 15,
        'comments': 3,
      },
      {
        'title': 'Learning Flutter',
        'content': 'After a month of studying Flutter, I can now create beautiful UIs with ease. The learning curve was worth it!',
        'time': '2 hours ago',
        'hasImage': false,
        'likes': 24,
        'comments': 5,
      },
      {
        'title': 'Mobile Development Tips',
        'content': 'When developing mobile apps, always test on real devices whenever possible. Simulators are great but nothing beats real hardware testing.',
        'time': '1 day ago',
        'hasImage': true,
        'likes': 42,
        'comments': 8,
      },
      {
        'title': 'Good Morning!',
        'content': 'Starting my day with some coding and a cup of coffee. Perfect morning!',
        'time': '2 days ago',
        'hasImage': false,
        'likes': 18,
        'comments': 2,
      },
    ];

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post header with user info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: profileImagePath != null
                          ? FileImage(File(profileImagePath!))
                          : const NetworkImage('https://via.placeholder.com/40x40') as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          post['time'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: themeColor), // Use theme color
                      onPressed: () {
                        // Show post options
                      },
                    ),
                  ],
                ),
              ),

              // Post content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  post['content'],
                  style: const TextStyle(fontSize: 15),
                ),
              ),

              // Sample image for posts with images
              if (post['hasImage'])
                Container(
                  height: 200,
                  width: double.infinity,
                  color: themeColor.withOpacity(0.1), // Use theme color with opacity
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: themeColor.withOpacity(0.5), // Use theme color with opacity
                    ),
                  ),
                ),

              // Post actions (like, comment, share)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ActionButton(
                      icon: Icons.thumb_up_outlined,
                      label: 'Like',
                      count: post['likes'].toString(),
                      themeColor: themeColor, // Pass theme color
                    ),
                    ActionButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Comment',
                      count: post['comments'].toString(),
                      themeColor: themeColor, // Pass theme color
                    ),
                    ActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      count: '',
                      themeColor: themeColor, // Pass theme color
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
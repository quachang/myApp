import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final List<Map<String, dynamic>> _contentTypes = [
    {
      'title': 'Create Poll',
      'icon': Icons.poll,
      'color': AppColors.primary,
      'description': 'Create a poll to gather opinions',
    },
    {
      'title': 'Start Chatter',
      'icon': Icons.chat_bubble,
      'color': AppColors.secondary,
      'description': 'Start a discussion thread',
    },
    {
      'title': 'Share Story',
      'icon': Icons.view_carousel,
      'color': AppColors.tertiary,
      'description': 'Share a photo or video story',
    },
    {
      'title': 'Go Live',
      'icon': Icons.videocam,
      'color': const Color(0xFFE57373),
      'description': 'Start a live video stream',
    },
    {
      'title': 'Create Event',
      'icon': Icons.event,
      'color': const Color(0xFF64B5F6),
      'description': 'Create and share an event',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Content',
                style: AppStyles.headline2,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose what you want to create',
                style: AppStyles.bodyText1.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  itemCount: _contentTypes.length,
                  itemBuilder: (context, index) {
                    final contentType = _contentTypes[index];
                    return _buildContentTypeCard(contentType);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentTypeCard(Map<String, dynamic> contentType) {
    return GestureDetector(
      onTap: () {
        _navigateToCreateScreen(contentType['title']);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: contentType['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                contentType['icon'],
                color: contentType['color'],
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contentType['title'],
                    style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contentType['description'],
                    style: AppStyles.bodyText2.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateScreen(String contentType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigate to $contentType screen'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.black,
          onPressed: () {},
        ),
      ),
    );

    // Actual navigation would be implemented here
    // Example:
    // if (contentType == 'Create Poll') {
    //   Navigator.pushNamed(context, AppRoutes.createPoll);
    // } else if...
  }
}
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';

class LiveFeedScreen extends StatefulWidget {
  const LiveFeedScreen({Key? key}) : super(key: key);

  @override
  _LiveFeedScreenState createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends State<LiveFeedScreen> {
  final List<Map<String, dynamic>> _liveSessions = List.generate(
    10,
        (index) => {
      'id': 'live_$index',
      'username': 'User ${index + 1}',
      'title': 'Live Session ${index + 1}',
      'viewers': (index + 1) * 10 + (index * 5),
      'category': index % 3 == 0
          ? 'Technology'
          : index % 3 == 1
          ? 'Entertainment'
          : 'Gaming',
      'thumbnailColor': index % 4 == 0
          ? Colors.blue.shade200
          : index % 4 == 1
          ? Colors.orange.shade200
          : index % 4 == 2
          ? Colors.green.shade200
          : Colors.purple.shade200,
    },
  );

  bool _showActiveOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filter options
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  'Live Now',
                  style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Show active only',
                  style: AppStyles.bodyText2,
                ),
                Switch(
                  value: _showActiveOnly,
                  onChanged: (value) {
                    setState(() {
                      _showActiveOnly = value;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),

          // Live sessions grid
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                // Implement refresh logic
                await Future.delayed(const Duration(seconds: 1));
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _liveSessions.length,
                itemBuilder: (context, index) {
                  final session = _liveSessions[index];
                  return _buildLiveSessionCard(session);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to go live screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Go Live feature coming soon!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.videocam),
      ),
    );
  }

  Widget _buildLiveSessionCard(Map<String, dynamic> session) {
    return GestureDetector(
      onTap: () {
        // Navigate to live session view
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joining ${session['title']}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                // Thumbnail background
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: session['thumbnailColor'],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.videocam,
                      size: 40,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),

                // Live indicator
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),

                // Viewers count
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${session['viewers']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Session info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['title'],
                    style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session['username'],
                    style: AppStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      session['category'],
                      style: AppStyles.caption.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
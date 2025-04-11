import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate mock friend data
    final List<Map<String, dynamic>> friends = List.generate(
      15,
          (index) => {
        'id': 'user_$index',
        'name': 'Friend ${index + 1}',
        'username': 'friend${index + 1}',
        'isOnline': index % 3 == 0,
        'lastActive': _getRandomLastActive(index),
      },
    );

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search friends...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),

        // Online friends row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Online Friends',
                style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'See All',
                style: AppStyles.bodyText2.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Online friends list
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: friends.where((f) => f['isOnline'] == true).length,
            itemBuilder: (context, index) {
              final onlineFriends = friends.where((f) => f['isOnline'] == true).toList();
              final friend = onlineFriends[index];
              return _buildOnlineFriendItem(friend);
            },
          ),
        ),
        const SizedBox(height: 16),

        // All friends list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'All Friends',
                style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${friends.length} friends',
                style: AppStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return _buildFriendListItem(context, friend);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineFriendItem(Map<String, dynamic> friend) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  friend['name'].substring(0, 1),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            friend['name'],
            style: AppStyles.caption.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFriendListItem(BuildContext context, Map<String, dynamic> friend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  friend['name'].substring(0, 1),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              if (friend['isOnline'])
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend['name'],
                  style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  friend['isOnline']
                      ? 'Online now'
                      : '${friend['lastActive']}',
                  style: AppStyles.caption.copyWith(
                    color: friend['isOnline'] ? Colors.green : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.message, color: AppColors.primary),
            onPressed: () {
              // Navigate to chat with friend
            },
          ),
        ],
      ),
    );
  }

  String _getRandomLastActive(int index) {
    final List<String> lastActiveTimes = [
      '5m ago',
      '10m ago',
      '30m ago',
      '1h ago',
      '2h ago',
      '5h ago',
      'Yesterday',
      '2d ago',
    ];

    return lastActiveTimes[index % lastActiveTimes.length];
  }
}
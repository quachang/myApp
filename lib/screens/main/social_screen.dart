import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
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
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey,
              labelStyle: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: AppStyles.subtitle2,
              tabs: const [
                Tab(text: 'Friends'),
                Tab(text: 'Groups'),
                Tab(text: 'Nearby'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsTab(),
                _buildGroupsTab(),
                _buildNearbyTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add friends/join groups screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Find friends feature coming soon!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add, color: Colors.black87),
      ),
    );
  }

  Widget _buildFriendsTab() {
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
              return _buildFriendListItem(friend);
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

  Widget _buildFriendListItem(Map<String, dynamic> friend) {
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

  Widget _buildGroupsTab() {
    // Generate mock group data
    final List<Map<String, dynamic>> groups = List.generate(
      10,
          (index) => {
        'id': 'group_$index',
        'name': 'Group ${index + 1}',
        'members': (index + 1) * 5 + (index * 2),
        'description': 'This is a group for ${index % 3 == 0 ? 'technology' : index % 3 == 1 ? 'sports' : 'food'} enthusiasts.',
        'category': index % 3 == 0 ? 'Technology' : index % 3 == 1 ? 'Sports' : 'Food',
        'isJoined': index % 2 == 0,
        'color': index % 4 == 0
            ? Colors.blue.shade100
            : index % 4 == 1
            ? Colors.green.shade100
            : index % 4 == 2
            ? Colors.orange.shade100
            : Colors.purple.shade100,
      },
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return _buildGroupCard(group);
      },
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Group header with color
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: group['color'],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: Text(
                    group['name'].substring(0, 1),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        group['name'],
                        style: AppStyles.subtitle1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${group['members']} members',
                        style: AppStyles.caption.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Group info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        group['category'],
                        style: AppStyles.caption.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      group['isJoined'] ? 'Joined' : 'Not Joined',
                      style: AppStyles.caption.copyWith(
                        color: group['isJoined'] ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  group['description'],
                  style: AppStyles.bodyText2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // View group details or join/leave group
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: group['isJoined']
                              ? Colors.white
                              : AppColors.primary,
                          foregroundColor: group['isJoined']
                              ? Colors.black87
                              : Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: group['isJoined']
                                ? const BorderSide(color: Colors.grey)
                                : BorderSide.none,
                          ),
                        ),
                        child: Text(
                          group['isJoined'] ? 'Leave Group' : 'Join Group',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Find People Nearby',
            style: AppStyles.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Connect with people in your area and expand your social circle.',
              style: AppStyles.bodyText1.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Request location permission and find nearby users
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nearby feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Enable Location'),
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
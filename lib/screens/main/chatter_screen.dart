import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';

class ChatterScreen extends StatefulWidget {
  const ChatterScreen({Key? key}) : super(key: key);

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> with SingleTickerProviderStateMixin {
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
          // Tab Bar
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
              indicatorWeight: 3,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey,
              labelStyle: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: AppStyles.subtitle2,
              tabs: const [
                Tab(text: 'Popular'),
                Tab(text: 'Recent'),
                Tab(text: 'Following'),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChatterList('Popular'),
                _buildChatterList('Recent'),
                _buildChatterList('Following'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create new chat thread
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.create, color: Colors.black87),
      ),
    );
  }

  Widget _buildChatterList(String type) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        // Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Mock data count
        itemBuilder: (context, index) {
          return _buildChatterCard(index);
        },
      ),
    );
  }

  Widget _buildChatterCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          // User and time info
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 20,
                child: Icon(Icons.person, color: Colors.grey.shade400),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Name ${index + 1}',
                    style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${index + 1} hour${index == 0 ? '' : 's'} ago',
                    style: AppStyles.caption,
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 16),

          // Chatter title
          Text(
            'This is a sample chatter topic ${index + 1}',
            style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Chatter text
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam eu urna in nisi imperdiet aliquam. Sed bibendum libero vel libero tincidunt, vel rutrum sapien facilisis.',
            style: AppStyles.bodyText2,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Tags
          Wrap(
            spacing: 8,
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#tag${i + 1}',
                    style: AppStyles.caption.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Engagement stats
          Row(
            children: [
              Icon(Icons.forum, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 5} comments',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.favorite, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 3} likes',
                style: AppStyles.caption,
              ),
              const Spacer(),
              Icon(Icons.bookmark_border, size: 18, color: Colors.grey.shade600),
            ],
          ),
        ],
      ),
    );
  }
}
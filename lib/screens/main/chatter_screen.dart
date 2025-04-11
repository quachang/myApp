import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../models/poll_model.dart';
import '../../widgets/polls/poll_card.dart';

class ChatterScreen extends StatefulWidget {
  const ChatterScreen({Key? key}) : super(key: key);

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final ScrollController _scrollController = ScrollController();

  // Categories for the hashtag tabs
  final List<String> _categories = [
    'My Feed',
    'Trending',
    '#Politics',
    '#Technology',
    '#Entertainment',
    '#Sports',
    '#Food',
  ];

  String _selectedCategory = 'My Feed';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Categories horizontal list
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: AppStyles.buttonTextStyle.copyWith(
                        color: isSelected ? Colors.black87 : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Content list
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                // Implement refresh logic
                await Future.delayed(const Duration(seconds: 1));
              },
              child: _buildContentList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create new post/chatter
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create new post feature coming soon!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.create, color: Colors.black87),
      ),
    );
  }

  Widget _buildContentList() {
    // Different content types for the chatter feed
    // This is a placeholder for actual content from your backend

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // Pinned announcement - could be shown conditionally
        // if (_selectedCategory == 'My Feed')
          // _buildAnnouncementCard(),

        // Content items
        ...List.generate(15, (index) {
          // Showcase different content types
          // A more varied distribution for a more realistic feed
          if (index % 7 == 0) {
            return _buildPollCard(index);
          } else if (index % 7 == 1 || index % 7 == 4) {
            return _buildPostCard(index, withImage: index % 3 == 0);
          } else if (index % 7 == 2) {
            return _buildEventCard(index);
          } else if (index % 7 == 3) {
            return _buildVideoCard(index);
          } else if (index % 7 == 5) {
            return _buildSharedPostCard(index);
          } else {
            return _buildCommunityPostCard(index);
          }
        }),
      ],
    );
  }

  Widget _buildAnnouncementCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.campaign, color: Colors.black87),
              const SizedBox(width: 8),
              Text(
                'Announcement',
                style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'Just now',
                style: AppStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Welcome to the new Chatter feed! Here you\'ll see posts, polls, events, videos and more from your subscribed communities.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPollCard(int index) {
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
          // User info row
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
                  Row(
                    children: [
                      Text(
                        '${index + 1}h ago',
                        style: AppStyles.caption,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Poll',
                          style: AppStyles.caption.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 16),

          // Poll question
          Text(
            'What is your favorite programming language?',
            style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Poll options
          for (var i = 0; i < 4; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: i == 0 ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: i == 0 ? AppColors.primary : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Option ${i + 1}',
                      style: AppStyles.bodyText2,
                    ),
                  ),
                  Text(
                    '${25 - (i * 5)}%',
                    style: AppStyles.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Poll stats
          Row(
            children: [
              Icon(Icons.how_to_vote, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '120 votes',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '22 hours left',
                style: AppStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(int index, {bool withImage = false}) {
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
          // User info row
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
                  Row(
                    children: [
                      Text(
                        '${index + 1}h ago',
                        style: AppStyles.caption,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Post',
                          style: AppStyles.caption.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 16),

          // Post title
          Text(
            'This is a sample post title ${index + 1}',
            style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Post content
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam eu urna in nisi imperdiet aliquam. Sed bibendum libero vel libero tincidunt, vel rutrum sapien facilisis.',
            style: AppStyles.bodyText2,
          ),

          // Post image (if any)
          if (withImage) ...[
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],

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
              Icon(Icons.thumb_up_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 5} likes',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 3} comments',
                style: AppStyles.caption,
              ),
              const Spacer(),
              Icon(Icons.share_outlined, size: 18, color: Colors.grey.shade600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(int index) {
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
          // Event header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.event, color: AppColors.tertiary),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Event',
                      style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Posted by User ${index + 1}',
                      style: AppStyles.caption,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${index + 1}h ago',
                  style: AppStyles.caption,
                ),
              ],
            ),
          ),

          // Event content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Meetup ${index + 1}',
                  style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'June ${15 + index}, 2025',
                      style: AppStyles.bodyText2,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      '6:00 PM - 8:00 PM',
                      style: AppStyles.bodyText2,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'Community Center, Downtown',
                      style: AppStyles.bodyText2,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Join us for our monthly community meetup where we\'ll discuss upcoming events and projects.',
                  style: AppStyles.bodyText2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.star_outline),
                        label: const Text('Interested'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.tertiary,
                          side: BorderSide(color: AppColors.tertiary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check),
                        label: const Text('Going'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          foregroundColor: Colors.white,
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

  Widget _buildVideoCard(int index) {
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
          // User info row
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
                  Row(
                    children: [
                      Text(
                        '${index + 1}h ago',
                        style: AppStyles.caption,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Video',
                          style: AppStyles.caption.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 12),

          // Video title
          Text(
            'Check out this amazing video ${index + 1}!',
            style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Video thumbnail with play button
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.red,
                  size: 36,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '1:${(index + 1) % 10}${(index * 3) % 10}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Video stats
          Row(
            children: [
              Icon(Icons.visibility, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 127} views',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.thumb_up_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 24}',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.comment, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 7}',
                style: AppStyles.caption,
              ),
              const Spacer(),
              Icon(Icons.share, size: 18, color: Colors.grey.shade600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSharedPostCard(int index) {
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
          // User info row
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
                  Row(
                    children: [
                      const Icon(Icons.share, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Shared a post • ${index + 1}h ago',
                        style: AppStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 12),

          // User comment on the shared post
          Text(
            'Check out this interesting post I found!',
            style: AppStyles.bodyText2,
          ),
          const SizedBox(height: 16),

          // Shared post container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Original poster info
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 16,
                      child: Text(
                        'O',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Original Poster',
                          style: AppStyles.caption.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '2d ago',
                          style: AppStyles.caption.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Shared post content
                Text(
                  'This is the original post that was shared. It contains some interesting information about topic ${index + 1}.',
                  style: AppStyles.bodyText2,
                ),

                const SizedBox(height: 12),

                // Shared post stats
                Row(
                  children: [
                    Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '142',
                      style: AppStyles.caption.copyWith(fontSize: 10),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '38',
                      style: AppStyles.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Engagement stats
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 2}',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1)}',
                style: AppStyles.caption,
              ),
              const Spacer(),
              Icon(Icons.share_outlined, size: 18, color: Colors.grey.shade600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityPostCard(int index) {
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
          // Community post header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'C${index % 5 + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Community ${index % 5 + 1}',
                        style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        size: 14,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Posted by ',
                        style: AppStyles.caption,
                      ),
                      Text(
                        'Moderator ${index % 3 + 1}',
                        style: AppStyles.caption.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' • ${index + 1}h ago',
                        style: AppStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 12),

          // Community post content
          Text(
            'Important announcement for all community members! We\'re excited to share updates about our upcoming events.',
            style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam eu urna in nisi imperdiet aliquam. Sed bibendum libero vel libero tincidunt, vel rutrum sapien facilisis. Join us to learn more about upcoming opportunities!',
            style: AppStyles.bodyText2,
          ),
          const SizedBox(height: 16),

          // Tags for community
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#community${index % 5 + 1}',
                  style: AppStyles.caption.copyWith(
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#announcement',
                  style: AppStyles.caption.copyWith(
                    color: Colors.amber.shade800,
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
              Icon(Icons.thumb_up_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 8}',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 4}',
                style: AppStyles.caption,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Join',
                  style: AppStyles.caption.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../widgets/polls/poll_card.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({Key? key}) : super(key: key);

  @override
  _PollsScreenState createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  final List<String> _categories = [
    'All',
    'Trending',
    'Politics',
    'Technology',
    'Entertainment',
    'Sports',
    'Food',
  ];

  String _selectedCategory = 'All';

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

          // Poll list
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                // Implement refresh logic
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 10, // Mock data count
                itemBuilder: (context, index) {
                  // This will be replaced with actual poll data later
                  return const PollCardPlaceholder();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create poll screen
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}

// Temporary placeholder until we implement the actual PollCard
class PollCardPlaceholder extends StatelessWidget {
  const PollCardPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    'User Name',
                    style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '2 hours ago',
                    style: AppStyles.caption,
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
}
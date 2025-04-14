import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import 'community_detail_screen.dart';

class Community {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isJoined;
  final Color color;
  final int members;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.isJoined,
    required this.color,
    required this.members,
  });
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Community> _communities = [];
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory; // Changed to nullable to allow empty initial state
  final _uuid = const Uuid();

  // Alphabetized categories list with Other at the end
  final List<String> _categories = [
    'Art',
    'Business',
    'Education',
    'Entertainment',
    'Food',
    'Health',
    'Lifestyle',
    'Politics',
    'Sports',
    'Technology',
    'Travel',
    'Other',
  ];

  final List<Color> _communityColors = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.pink.shade100,
    Colors.teal.shade100,
    Colors.amber.shade100,
    Colors.indigo.shade100,
  ];

  Color _getRandomColor() {
    return _communityColors[DateTime.now().millisecond % _communityColors.length];
  }

  void _addCommunity(String name, String description, String category) {
    final newCommunity = Community(
      id: _uuid.v4(),
      name: name,
      description: description,
      category: category,
      isJoined: true, // New communities are automatically joined
      color: _getRandomColor(),
      members: 1, // Start with the creator
    );

    setState(() {
      _communities.add(newCommunity);
    });
  }

  void _deleteCommunity(String id) {
    setState(() {
      _communities.removeWhere((community) => community.id == id);
    });
  }

  void _showAddCommunityDialog() {
    _nameController.clear();
    _descriptionController.clear();
    _selectedCategory = null; // Start with no category selected

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Community'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Community Name (3-21 characters)',
                  hintText: 'Enter a name for your community',
                  counterText: '',
                ),
                maxLength: 21,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(21),
                ],
                onChanged: (value) {
                  // Validate minimum length on change
                  if (value.length < 3 && value.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Community name must be at least 3 characters'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (max 150 characters)',
                  hintText: 'What is this community about?',
                  counterText: '',
                ),
                maxLines: 3,
                maxLength: 150,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(150),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select a category',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final nameText = _nameController.text.trim();
              if (nameText.length >= 3 && nameText.length <= 21 &&
                  _descriptionController.text.trim().isNotEmpty &&
                  _selectedCategory != null) {
                _addCommunity(
                  nameText,
                  _descriptionController.text.trim(),
                  _selectedCategory!,
                );
                Navigator.pop(context);
              } else {
                // Show validation error
                String errorMessage = 'Please fill in all fields';
                if (nameText.length < 3) {
                  errorMessage = 'Community name must be at least 3 characters';
                } else if (_selectedCategory == null) {
                  errorMessage = 'Please select a category';
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black87,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinCommunityDialog() {
    final searchController = TextEditingController();

    // Sample public communities that users can join
    final List<Map<String, dynamic>> publicCommunities = [
      {
        'name': 'Tech Enthusiasts',
        'members': 1250,
        'category': 'Technology',
      },
      {
        'name': 'Foodies Unite',
        'members': 875,
        'category': 'Food',
      },
      {
        'name': 'Local Politics',
        'members': 450,
        'category': 'Politics',
      },
      {
        'name': 'Art & Design',
        'members': 782,
        'category': 'Art',
      },
      {
        'name': 'Travel Adventures',
        'members': 1632,
        'category': 'Travel',
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Community'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search communities',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Popular Communities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: publicCommunities.length,
                  itemBuilder: (context, index) {
                    final community = publicCommunities[index];
                    return ListTile(
                      title: Text(community['name']),
                      subtitle: Text('${community['members']} members • ${community['category']}'),
                      trailing: OutlinedButton(
                        onPressed: () {
                          // Create and join this community
                          _addCommunity(
                            community['name'],
                            'A community for ${community['category'].toLowerCase()} enthusiasts',
                            community['category'],
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Joined ${community['name']}'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Join'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCommunityOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Create New Community'),
            onTap: () {
              Navigator.pop(context);
              _showAddCommunityDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_add),
            title: const Text('Join Existing Community'),
            onTap: () {
              Navigator.pop(context);
              _showJoinCommunityDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Community community) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Community'),
        content: Text('Are you sure you want to delete "${community.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteCommunity(community.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToCommunityDetail(Community community) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityDetailScreen(
          community: community,
          allCommunities: _communities,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _communities.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _communities.length,
          itemBuilder: (context, index) {
            final community = _communities[index];
            return _buildCommunityCard(context, community);
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _showCommunityOptions,
            backgroundColor: AppColors.primary,
            heroTag: 'createCommunity',
            child: const Icon(Icons.group_add,
                color: Colors.black87,
                size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Communities Yet',
            style: AppStyles.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Create or join a community to connect with people who share your interests.',
              style: AppStyles.bodyText1.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _showAddCommunityDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Create'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: _showJoinCommunityDialog,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                icon: const Icon(Icons.group_add),
                label: const Text('Join'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(BuildContext context, Community community) {
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
          // Community header with color
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: community.color,
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
                    community.name.substring(0, 1),
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
                        community.name,
                        style: AppStyles.subtitle1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${community.members} ${community.members == 1 ? 'member' : 'members'}',
                        style: AppStyles.caption.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.black54),
                  onPressed: () => _showDeleteConfirmation(community),
                ),
              ],
            ),
          ),

          // Community info
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
                        community.category,
                        style: AppStyles.caption.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      community.isJoined ? 'Joined' : 'Not Joined',
                      style: AppStyles.caption.copyWith(
                        color: community.isJoined ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  community.description,
                  style: AppStyles.bodyText2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _navigateToCommunityDetail(community),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View Details'),
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
}
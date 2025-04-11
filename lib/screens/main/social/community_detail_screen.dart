import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';

// Import the Community class from community_screen.dart
import 'community_screen.dart';

class Post {
  final String id;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final String? imageUrl;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.comments,
    this.imageUrl,
  });
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int attendees;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.attendees,
  });
}

class Message {
  final String id;
  final String userId;
  final String username;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.timestamp,
  });
}

class CommunityDetailScreen extends StatefulWidget {
  final Community community;
  final List<Community> allCommunities;

  const CommunityDetailScreen({
    Key? key,
    required this.community,
    required this.allCommunities,
  }) : super(key: key);

  @override
  _CommunityDetailScreenState createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final uuid = const Uuid();

  // Mock data lists
  List<Post> _posts = [];
  List<Event> _events = [];
  List<Message> _messages = [];
  List<Post> _filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Add listener to tab controller to update FAB visibility
    _tabController.addListener(_handleTabSelection);

    // Initialize with some mock data
    _initializeMockData();
    _filteredPosts = List.from(_posts);

    // Add listener to search field
    _searchController.addListener(_filterPosts);
  }

  void _handleTabSelection() {
    // Force rebuild when tab changes to update FAB visibility
    setState(() {});
  }

  void _filterPosts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPosts = List.from(_posts);
      } else {
        _filteredPosts = _posts.where((post) {
          return post.username.toLowerCase().contains(query) ||
              post.content.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _initializeMockData() {
    // Initialize with some example posts
    _posts = [
      Post(
        id: uuid.v4(),
        userId: 'user1',
        username: 'Community Admin',
        content: 'Welcome to our ${widget.community.name} community! Looking forward to connecting with everyone here.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 5,
        comments: 2,
      ),
      Post(
        id: uuid.v4(),
        userId: 'user2',
        username: 'Jane Smith',
        content: 'Excited to be part of this community! Anyone here interested in ${widget.community.category.toLowerCase()}?',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likes: 3,
        comments: 1,
      ),
      Post(
        id: uuid.v4(),
        userId: 'user3',
        username: 'Mike Johnson',
        content: 'I\'ve been following ${widget.community.category} for years now. Looking forward to sharing ideas with all of you!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 2,
        comments: 0,
      ),
    ];

    // Initialize an upcoming event
    final eventDate = DateTime.now().add(const Duration(days: 3));
    _events = [
      Event(
        id: uuid.v4(),
        title: '${widget.community.name} Meetup',
        description: 'Join us for our first community meetup! We\'ll discuss upcoming topics and get to know each other.',
        date: eventDate,
        location: 'Community Center',
        attendees: 12,
      ),
    ];

    // Initialize some chat messages
    _messages = [
      Message(
        id: uuid.v4(),
        userId: 'user1',
        username: 'Community Admin',
        content: 'Welcome to the ${widget.community.name} chat! Feel free to introduce yourself.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _postController.dispose();
    _messageController.dispose();
    _searchController.removeListener(_filterPosts);
    _searchController.dispose();
    super.dispose();
  }

  void _addPost() {
    if (_postController.text.trim().isEmpty) return;

    setState(() {
      _posts.insert(
        0,
        Post(
          id: uuid.v4(),
          userId: 'currentUser',
          username: 'You',
          content: _postController.text.trim(),
          createdAt: DateTime.now(),
          likes: 0,
          comments: 0,
        ),
      );
      _filteredPosts = List.from(_posts);
      _postController.clear();
    });
  }

  void _addMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(
          id: uuid.v4(),
          userId: 'currentUser',
          username: 'You',
          content: _messageController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
  }

  void _showCreateEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'Enter the event title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your event',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Where will this event be held?',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Date: '),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        selectedDate = pickedDate;
                      }
                    },
                    child: Text(
                      DateFormat.yMMMd().format(selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
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
              if (titleController.text.trim().isNotEmpty &&
                  descriptionController.text.trim().isNotEmpty &&
                  locationController.text.trim().isNotEmpty) {
                setState(() {
                  _events.add(
                    Event(
                      id: uuid.v4(),
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      date: selectedDate,
                      location: locationController.text.trim(),
                      attendees: 1,
                    ),
                  );
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
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

  void _navigateToCommunity(Community community) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityDetailScreen(
          community: community,
          allCommunities: widget.allCommunities,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: GestureDetector(
        onTap: () {
      _showCommunityDropdown();
    },
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Text(
    widget.community.name,
    style: const TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.bold,
    ),
    ),
    const Icon(Icons.arrow_drop_down, color: Colors.black87),
    ],
    ),
    ),
    backgroundColor: widget.community.color,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black87),
    actions: [
    // User profile icon
    Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: CircleAvatar(
    backgroundColor: Colors.white.withOpacity(0.3),
    child: const Icon(
    Icons.person,
    color: Colors.black87,
    ),
    ),
    ),
    ],
    bottom: TabBar(
    controller: _tabController,
    indicatorColor: AppColors.primary,
    labelColor: Colors.black87,
    unselectedLabelColor: Colors.black54,
    tabs: const [
    Tab(text: 'Posts'),
    Tab(text: 'Events'),
    Tab(text: 'Chat'),
    ],
    ),
    ),
    body: TabBarView(
    controller: _tabController,
    children: [
      _buildPostsTab(),
      _buildEventsTab(),
      _buildChatTab(),
    ],
    ),
      floatingActionButton: _tabController.index == 0 || _tabController.index == 1
          ? FloatingActionButton(
        onPressed: _tabController.index == 0
            ? _showPostInputDialog
            : _showCreateEventDialog,
        backgroundColor: AppColors.primary,
        child: Icon(
          _tabController.index == 0 ? Icons.post_add : Icons.event_available,
          color: Colors.black87,
        ),
      )
          : null, // No FAB for chat tab
    );
  }

  void _showCommunityDropdown() {
    // Filter only communities that the user has joined
    final joinedCommunities = widget.allCommunities.where((c) => c.isJoined).toList();

    if (joinedCommunities.isEmpty || joinedCommunities.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No other communities to display'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Communities',
              style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: joinedCommunities.length,
              itemBuilder: (context, index) {
                final community = joinedCommunities[index];
                final bool isSelected = community.id == widget.community.id;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: community.color,
                    child: Text(
                      community.name.substring(0, 1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  title: Text(community.name),
                  subtitle: Text('${community.members} members'),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    if (!isSelected) {
                      Navigator.pop(context);
                      _navigateToCommunity(community);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    // Show different FAB depending on the current tab
    switch (_tabController.index) {
      case 0: // Posts tab
        return FloatingActionButton(
          onPressed: () {
            _showPostInputDialog();
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.post_add, color: Colors.black87),
        );
      case 1: // Events tab
        return FloatingActionButton(
          onPressed: _showCreateEventDialog,
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.event_available, color: Colors.black87),
        );
      case 2: // Chat tab - no FAB as chat input is in the tab
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  void _showPostInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Post'),
        content: TextField(
          controller: _postController,
          decoration: const InputDecoration(
            hintText: 'What\'s on your mind?',
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_postController.text.trim().isNotEmpty) {
                _addPost();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black87,
            ),
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return Column(
      children: [
        // Search bar instead of post creation field
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search posts...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade300),
        Expanded(
          child: _filteredPosts.isEmpty
              ? _buildEmptyPostsState()
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredPosts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final post = _filteredPosts[index];
              return _buildPostCard(post);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPostsState() {
    if (_searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No Posts Found',
              style: AppStyles.headline3,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'No posts match your search criteria',
                style: AppStyles.bodyText1.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.post_add,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Posts Yet',
            style: AppStyles.headline3,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Be the first to share something with the community!',
              style: AppStyles.bodyText1.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showPostInputDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Create Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    post.username.substring(0, 1),
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _formatPostTime(post.createdAt),
                      style: AppStyles.caption,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {
                    // Show post options
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.content,
              style: AppStyles.bodyText1,
            ),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // Like post
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes}',
                        style: AppStyles.caption.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    // Show comments
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.comments}',
                        style: AppStyles.caption.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    // Share post
                  },
                  child: Icon(
                    Icons.share_outlined,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsTab() {
    return Column(
      children: [
        Expanded(
          child: _events.isEmpty
              ? _buildEmptyEventsState()
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _events.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final event = _events[index];
              return _buildEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyEventsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Events Yet',
            style: AppStyles.headline3,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Create an event to bring the community together!',
              style: AppStyles.bodyText1.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateEventDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Create Event'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final bool isUpcoming = event.date.isAfter(DateTime.now());
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.community.color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.event, color: Colors.black87),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppStyles.subtitle1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd().add_jm().format(event.date),
                        style: AppStyles.caption.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      event.location,
                      style: AppStyles.bodyText2.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isUpcoming ? Colors.green.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isUpcoming ? 'Upcoming' : 'Past',
                        style: TextStyle(
                          fontSize: 12,
                          color: isUpcoming ? Colors.green.shade800 : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.description,
                  style: AppStyles.bodyText1,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${event.attendees} ${event.attendees == 1 ? 'person' : 'people'} attending',
                      style: AppStyles.caption.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    if (isUpcoming)
                      OutlinedButton(
                        onPressed: () {
                          // RSVP to event
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You\'re now attending this event!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('RSVP'),
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

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final bool isCurrentUser = message.userId == 'currentUser';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isCurrentUser) ...[
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade300,
                        child: Text(
                          message.username.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Column(
                        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isCurrentUser ? AppColors.primary : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                if (!isCurrentUser)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      message.username,
                                      style: AppStyles.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                Text(
                                  message.content,
                                  style: AppStyles.bodyText2.copyWith(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatChatTime(message.timestamp),
                            style: AppStyles.caption.copyWith(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: const Text(
                          'Y',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.photo, color: AppColors.primary),
                onPressed: () {
                  // Add photo
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _addMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: _addMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPostTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat.yMMMd().format(dateTime);
    }
  }

  String _formatChatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat.jm().format(dateTime);
    } else if (messageDate == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(dateTime)}';
    } else {
      return DateFormat.MMMd().add_jm().format(dateTime);
    }
  }
}
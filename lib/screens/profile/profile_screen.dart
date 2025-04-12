import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
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

  // Show options menu for profile actions
  void _showOptionsMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // Make the dialog narrower with fixed width
          insetPadding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                onPressed: () {
                  // Handle Copy Link
                  Navigator.pop(context);
                },
                child: const Center(
                  child: Text(
                    'Copy Link',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                onPressed: () {
                  // Handle Edit My Profile
                  Navigator.pop(context);
                  _navigateToEditProfile();
                },
                child: const Center(
                  child: Text(
                    'Edit My Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Navigation to edit profile screen
  void _navigateToEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Remove the AppBar to get rid of the header
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top section with online status and options only
            Container(
              padding: const EdgeInsets.only(top: 40, right: 16, left: 16, bottom: 8),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align to the end
                children: [
                  // Online status indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Online',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Three dots menu
                  GestureDetector(
                    onTap: _showOptionsMenu,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Profile picture section (smaller circle)
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Smaller profile picture without plus button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      // Reduced radius for smaller profile picture
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: const NetworkImage('https://via.placeholder.com/120x120'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Username
                  const Text(
                    'Your Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Level indicator badge
                  Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '5',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Jester',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats section with smaller numbers
            Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('97', 'Reputation'),
                  _buildStatColumn('2', 'Following'),
                  _buildStatColumn('5', 'Followers'),
                ],
              ),
            ),

            // Bio section - centered and without "Bio" header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center alignment
                children: [
                  // Removed the "Bio" text header
                  Text(
                    'Member since June 2018 (6 years, 294 days)',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center, // Center aligned text
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap here to add your bio!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center, // Center aligned text
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Posts 4'),
                  Tab(text: 'Wall 3'),
                  Tab(text: 'Saved Posts'),
                ],
              ),
            ),

            // Create a new post button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              color: Colors.grey.shade900,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Create a new post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // My Communities section (changed from My Wiki Entries)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.grey.shade900,
              child: Row(
                children: [
                  const Text(
                    'My Communities',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600, size: 16),
                ],
              ),
            ),

            // Sample placeholder for posts
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.grey.shade900,
              child: Container(
                width: 100,
                height: 100,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.grey.shade600,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),

            // Removed bottom square with plus icon
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28, // Smaller font size (reduced from 34)
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom sheet for edit profile based on AminoApps design
class EditProfileBottomSheet extends StatefulWidget {
  @override
  _EditProfileBottomSheetState createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _userNameController = TextEditingController(text: 'Your Username');

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with title and buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                  onPressed: () {
                    // Preview profile
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: () {
                    // Save changes
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Profile picture edit section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            color: Colors.grey.shade100,
            child: Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: const NetworkImage('https://via.placeholder.com/120x120'),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Edit Profile Frame',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          const Divider(height: 1, color: Colors.grey),

          // Form fields
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Username field
                ListTile(
                  leading: const Icon(Icons.person_outline, color: Colors.grey),
                  title: TextField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                    ),
                  ),
                ),
                const Divider(),

                // Background choice
                ListTile(
                  leading: const Icon(Icons.palette, color: Colors.grey),
                  title: const Text('Choose Background'),
                  subtitle: const Text('(Optional)'),
                  trailing: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                ),
                const Divider(),

                // Add to gallery
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Colors.grey),
                  title: const Text('Add more to the gallery'),
                ),
                const Divider(),

                // Bio section
                const ListTile(
                  title: Text(
                    'Bio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text('Introduce yourself and your Stories.'),
                ),

                // Text input area with placeholder
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Text(
                        'Text',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Icon(
                        Icons.touch_app,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      Text(
                        'Long press the text to\nembed images',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Advanced options
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: const Text('Advanced Options'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
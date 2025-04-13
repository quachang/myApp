import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../services/auth_service.dart';
import 'edit_profile_screen.dart';

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.link, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Copy Link',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Edit My Profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                onPressed: () {
                  // Handle Settings
                  Navigator.pop(context);
                  // Navigate to settings page
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
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
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed from black to white
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top section with search icon and options
            Container(
              padding: const EdgeInsets.only(top: 35, left: 10, right: 16, bottom: 8),
              color: Colors.white, // Changed from black to white
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Search icon on the left with your specified positioning
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black, // Changed from white to black
                      size: 24,
                    ),
                    onPressed: () {
                      // Handle search action
                    },
                  ),

                  // Right side - only notification icon remains
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.black, // Changed from white to black
                      size: 24,
                    ),
                    onPressed: () {
                      // Handle notification action
                    },
                  ),
                ],
              ),
            ),

            // Profile picture section with white background
            Container(
              color: Colors.white, // Changed from black to white
              padding: const EdgeInsets.only(top: 0, bottom: 20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Add the 3 dots at the top of the profile section
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 0, bottom: 0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Colors.black, // Changed from white to black
                          size: 28,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: _showOptionsMenu,
                      ),
                    ),
                  ),

                  // Profile picture
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2), // Changed border color
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: const NetworkImage('https://via.placeholder.com/120x120'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Username - with black text
                  const Text(
                    'Your Username',
                    style: TextStyle(
                      color: Colors.black, // Changed from white to black
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Level indicator badge
                  Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
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
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Jester',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats section with updated 'Aura' text
            Container(
              color: Colors.white, // Changed from black to white
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('97', 'Aura'), // Changed from 'Reputation' to 'Aura'
                  _buildStatColumn('2', 'Following'),
                  _buildStatColumn('5', 'Followers'),
                ],
              ),
            ),

            // Bio section with lighter background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100, // Changed from grey.shade900 to grey.shade100
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Member since June 2018 (6 years, 294 days)',
                    style: TextStyle(
                      color: Colors.grey.shade700, // Changed from grey.shade400 to grey.shade700
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Tab Bar with updated tab labels
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Changed from black to white
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary, // Changed from white to primary color
                dividerColor: Colors.transparent,
                labelColor: Colors.black, // Changed from white to black
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Posts 4'),
                  Tab(text: 'Artifacts'), // Changed from 'Wall 3' to 'Artifacts'
                  Tab(text: 'Saved Items'), // Changed from 'Saved Posts' to 'Saved Items'
                ],
              ),
            ),

            // My Communities section with lighter background
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: Colors.grey.shade100, // Changed from grey.shade900 to grey.shade100
              child: Row(
                children: [
                  Text(
                    'My Communities',
                    style: TextStyle(
                      color: Colors.black, // Changed from white to black
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 16), // Changed icon color
                ],
              ),
            ),
          ],
        ),
      ),
      // Add floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle create action
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
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
              color: Colors.black, // Changed from white to black
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700, // Changed from grey.shade400 to grey.shade700
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
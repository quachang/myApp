import 'dart:io';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

// Importing new modular components
import 'tabs/profile_posts_tab.dart';
import 'tabs/profile_artifacts_tab.dart';
import 'tabs/profile_saved_items_tab.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats.dart';
import 'widgets/profile_bio.dart';
import 'widgets/profile_communities.dart';

class ProfileScreen extends StatefulWidget {
  final Function(String?)? onProfileImageChanged;

  const ProfileScreen({
    Key? key,
    this.onProfileImageChanged,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  String _username = 'New User';
  String _customBioText = '';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
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
                  // Navigate to Settings
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
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

  void _updateProfileImage(String? imagePath) {
    if (widget.onProfileImageChanged != null) {
      widget.onProfileImageChanged!(imagePath);
    }
  }

  // Update the _navigateToEditProfile method
  void _navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditProfileScreen(
          initialUsername: _username,
          initialBio: _customBioText,
          profileImagePath: _profileImagePath,
          onSave: (newUsername, newBio, newImagePath) {
            setState(() {
              _username = newUsername;
              _customBioText = newBio;
              _profileImagePath = newImagePath;
              // Call the callback to update the navigation bar
              _updateProfileImage(newImagePath);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 24,
                    ),
                    onPressed: () {
                      // Handle search action
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 24,
                    ),
                    onPressed: () {
                      // Handle notification action
                    },
                  ),
                ],
              ),
            ),
          ];
        },
        // Main scrollable content
        body: Column(
          children: [
            // Profile Info Section (not tabbed, always visible)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Profile Header (Avatar, Username, Level)
                  ProfileHeader(
                    username: _username,
                    profileImagePath: _profileImagePath,
                    onOptionsPressed: _showOptionsMenu,
                  ),

                  // Stats section with 'Following' centered
                  ProfileStats(),

                  // My Communities section
                  ProfileCommunities(),

                  // Bio section with lighter background
                  ProfileBio(bioText: _customBioText),

                  // Tab Bar for Posts, Artifacts, Saved Items
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
                      dividerColor: Colors.transparent,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: const [
                        Tab(text: 'Posts 4'),
                        Tab(text: 'Artifacts'),
                        Tab(text: 'Saved Items'),
                      ],
                    ),
                  ),

                  // Tab content - dynamically sized based on content
                  IndexedStack(
                    index: _tabController.index,
                    children: [
                      // Posts Tab
                      ProfilePostsTab(profileImagePath: _profileImagePath),

                      // Artifacts Tab
                      ProfileArtifactsTab(),

                      // Saved Items Tab
                      ProfileSavedItemsTab(),
                    ],
                  ),
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
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}
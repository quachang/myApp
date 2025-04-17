import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../services/auth_service.dart';
import 'actions/edit_profile_screen.dart';
import 'actions/settings_screen.dart';
import 'actions/theme_color_picker_screen.dart';

// Importing new modular components
import 'tabs/profile_posts_tab.dart';
import 'tabs/profile_artifacts_tab.dart';
import 'tabs/profile_saved_items_tab.dart';
import 'widgets/profile_bio.dart';

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
  String? _websiteUrl;
  String? _profileImagePath;
  String? _backgroundImagePath;
  Color _themeColor = const Color(0xFFEAD78D); // Default theme color (AppColors.primary)
  bool _useDarkTextOnBackground = true; // Default to dark text for yellow

  // Background color and contrast for tab area
  late Color _backgroundThemeColor;
  bool _useWhiteTextOnTabBackground = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    // Initialize background theme color and text contrast
    _backgroundThemeColor = _getBackgroundColorFromTheme(_themeColor);
    _calculateTabTextColor();
    // Set status bar to transparent to allow background to show
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Default to dark for yellow
    ));

    // Analyze background image if it exists, otherwise analyze theme color
    if (_backgroundImagePath != null) {
      _analyzeBackgroundImage();
    } else {
      _determineTextColorForTheme();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    // Reset status bar when leaving screen
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  // Method to calculate contrast ratio between text and background
  double _calculateContrastRatio(Color bgcolor) {
    // Calculate relative luminance for the color
    double getRelativeLuminance(Color color) {
      // Normalize RGB components to 0-1
      double r = color.red / 255;
      double g = color.green / 255;
      double b = color.blue / 255;

      // Apply gamma correction
      r = r <= 0.03928 ? r / 12.92 : math.pow((r + 0.055) / 1.055, 2.4).toDouble();
      g = g <= 0.03928 ? g / 12.92 : math.pow((g + 0.055) / 1.055, 2.4).toDouble();
      b = b <= 0.03928 ? b / 12.92 : math.pow((b + 0.055) / 1.055, 2.4).toDouble();

      // Calculate relative luminance
      return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    // Get luminance values
    final double bgLuminance = getRelativeLuminance(bgcolor);
    final double whiteLuminance = 1.0; // White text luminance
    final double blackLuminance = 0.0; // Black text luminance

    // Calculate contrast ratios (per WCAG 2.0)
    final double whiteContrast = (whiteLuminance + 0.05) / (bgLuminance + 0.05);
    final double blackContrast = (bgLuminance + 0.05) / (blackLuminance + 0.05);

    // Return the higher contrast value (white or black)
    return whiteContrast > blackContrast ? whiteContrast : -blackContrast;
  }

  // Helper method to get background color from theme (Option 2)
  Color _getBackgroundColorFromTheme(Color themeColor) {
    // Create a very faint/dark version of the theme color
    return themeColor.withOpacity(0.1);
  }

  // Method to determine text color for tab area
  void _calculateTabTextColor() {
    // Calculate contrast for the tab background color
    final double contrast = _calculateContrastRatio(_backgroundThemeColor);

    // If contrast is positive, white has better contrast
    // If negative, black has better contrast
    _useWhiteTextOnTabBackground = contrast > 0;
  }

  // Method to determine text color based on theme color
  void _determineTextColorForTheme() {
    // Calculate contrast
    final double contrast = _calculateContrastRatio(_themeColor);

    setState(() {
      // If contrast is negative, black has better contrast
      // If positive, white has better contrast
      _useDarkTextOnBackground = contrast < 0;

      // Update status bar icons accordingly
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _useDarkTextOnBackground ? Brightness.dark : Brightness.light,
      ));
      // Update background theme color and recalculate tab text colors
      _backgroundThemeColor = _getBackgroundColorFromTheme(_themeColor);
      _calculateTabTextColor();
    });
  }

  // Method to analyze image brightness and update text color mode
  Future<void> _analyzeBackgroundImage() async {
    if (_backgroundImagePath == null) {
      // Fall back to theme color analysis
      _determineTextColorForTheme();
      return;
    }

    try {
      final File imageFile = File(_backgroundImagePath!);
      final Uint8List bytes = await imageFile.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      // Sample the top portion of the image where text appears
      final ByteData? byteData = await image.toByteData();

      if (byteData != null) {
        // Sample pixels from top section where text appears
        final int width = image.width;
        final int height = image.height ~/ 3; // Top third of the image

        // Calculate average color in the sampled area
        int totalR = 0, totalG = 0, totalB = 0;
        int sampledPixels = 0;

        // Sample pixels (taking every 10th pixel to improve performance)
        for (int y = 0; y < height; y += 10) {
          for (int x = 0; x < width; x += 10) {
            final int pixelOffset = (y * width + x) * 4; // 4 bytes per pixel (RGBA)

            if (pixelOffset + 3 < byteData.lengthInBytes) {
              totalR += byteData.getUint8(pixelOffset);
              totalG += byteData.getUint8(pixelOffset + 1);
              totalB += byteData.getUint8(pixelOffset + 2);
              sampledPixels++;
            }
          }
        }

        // Calculate average color
        final int avgR = totalR ~/ sampledPixels;
        final int avgG = totalG ~/ sampledPixels;
        final int avgB = totalB ~/ sampledPixels;
        final Color avgColor = Color.fromRGBO(avgR, avgG, avgB, 1.0);

        // Calculate contrast with both white and black text
        final double contrast = _calculateContrastRatio(avgColor);

        // Update state based on contrast ratio
        setState(() {
          // If contrast is negative, black has better contrast
          // If positive, white has better contrast
          _useDarkTextOnBackground = contrast < 0;

          // Update status bar icons accordingly
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: _useDarkTextOnBackground ? Brightness.dark : Brightness.light,
          ));
          // Update background theme color and recalculate tab text colors
          _backgroundThemeColor = _getBackgroundColorFromTheme(_themeColor);
          _calculateTabTextColor();
        });
      }
    } catch (e) {
      print('Error analyzing image: $e');
      // Fall back to theme color analysis
      _determineTextColorForTheme();
    }
  }

  void _showOptionsMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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

  void _navigateToEditProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditProfileScreen(
          initialUsername: _username,
          initialBio: _customBioText,
          profileImagePath: _profileImagePath,
          backgroundImagePath: _backgroundImagePath,
          themeColor: _themeColor,
          initialWebsite: _websiteUrl, // Add this parameter
          onSave: (newUsername, newBio, newImagePath, newBackgroundImagePath, newThemeColor, newWebsiteUrl) {
            setState(() {
              _username = newUsername;
              _customBioText = newBio;
              _profileImagePath = newImagePath;
              _backgroundImagePath = newBackgroundImagePath;
              _websiteUrl = newWebsiteUrl; // Store the website URL

              // Check if theme color changed
              bool themeColorChanged = _themeColor != newThemeColor;
              _themeColor = newThemeColor;
              _updateProfileImage(newImagePath);

              // Determine text color based on new background/theme
              if (_backgroundImagePath != null) {
                _analyzeBackgroundImage();
              } else if (themeColorChanged) {
                _determineTextColorForTheme();
              }
            });
          },
        ),
      ),
    );

    // After returning from edit profile, analyze the background
    if (_backgroundImagePath != null) {
      _analyzeBackgroundImage();
    } else {
      _determineTextColorForTheme();
    }
  }

  // Helper method for creating stat columns with dynamic text color
  Widget _buildStatColumn(String count, String title, Color textColor, List<Shadow> shadows) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: shadows,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: textColor.withOpacity(0.9),
            fontSize: 14,
            shadows: shadows,
          ),
        ),
      ],
    );
  }

  // Helper method to wrap tab content with theme-appropriate styling
  Widget _buildTabContent(Widget tabContent, Color textColor) {
    return Theme(
      // Override the text theme colors for all content inside the tab
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
        cardTheme: CardTheme(
          color: _useWhiteTextOnTabBackground
              ? Colors.black.withOpacity(0.4) // Darker cards for light text
              : Colors.white.withOpacity(0.9), // Light cards for dark text
        ),
      ),
      child: tabContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine text color based on analysis
    final Color textColor = _useDarkTextOnBackground ? Colors.black87 : Colors.white;
    final Color iconColor = _useDarkTextOnBackground ? Colors.black87 : Colors.white;

    // Determine text color for tab area based on background theme color
    final Color tabTextColor = _useWhiteTextOnTabBackground ? Colors.white : Colors.black87;
    final Color unselectedTabTextColor = _useWhiteTextOnTabBackground
        ? Colors.white.withOpacity(0.6)
        : Colors.black87.withOpacity(0.5);

    // Configure text shadow based on text color
    final List<Shadow> textShadows = _useDarkTextOnBackground
        ? [
      Shadow(
        color: Colors.white.withOpacity(0.7),
        blurRadius: 5,
        offset: Offset(0, 1),
      ),
    ]
        : [
      Shadow(
        color: Colors.black.withOpacity(0.7),
        blurRadius: 5,
        offset: Offset(0, 1),
      ),
    ];

    return Scaffold(
      backgroundColor: _backgroundThemeColor,
      // Remove app bar to allow background image to cover the top
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Profile Header with background image that includes stats AND My Communities
          Container(
            decoration: BoxDecoration(
              // Use either the background image or a theme color gradient
              image: _backgroundImagePath != null
                  ? DecorationImage(
                image: FileImage(File(_backgroundImagePath!)),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  _themeColor.withOpacity(0.2), // Apply theme color tint
                  BlendMode.overlay,
                ),
              )
                  : null,
              // If no background image, use a gradient with the theme color
              gradient: _backgroundImagePath == null
                  ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _themeColor,
                  _themeColor.withOpacity(0.8),
                  _themeColor.withOpacity(0.6),
                ],
              )
                  : null,
              // Add shadow for depth
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Gradient overlay for better text visibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _useDarkTextOnBackground
                          ? [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ]
                          : [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Content column
                Column(
                  children: [
                    // Status bar padding
                    SizedBox(height: MediaQuery.of(context).padding.top),

                    // Top nav bar row (search and options icons)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: iconColor,
                            size: 24,
                            shadows: textShadows,
                          ),
                          onPressed: () {
                            // Handle search action
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: iconColor,
                            size: 28,
                            shadows: textShadows,
                          ),
                          onPressed: _showOptionsMenu,
                        ),
                      ],
                    ),

                    // Profile Picture
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _profileImagePath != null
                            ? FileImage(File(_profileImagePath!))
                            : const NetworkImage('https://via.placeholder.com/120x120') as ImageProvider,
                      ),
                    ),

                    // Username and Level
                    const SizedBox(height: 16),
                    Text(
                      _username,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        shadows: textShadows,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
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
                            'Garden Snail',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stats Row (Aura, Following, Followers)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildStatColumn('97', 'Aura', textColor, textShadows),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: _buildStatColumn('2', 'Following', textColor, textShadows),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildStatColumn('5', 'Followers', textColor, textShadows),
                          ),
                        ],
                      ),
                    ),

                    // My Communities section - with theme-aware styling
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        // Semi-transparent background based on text color
                        color: _useDarkTextOnBackground
                            ? Colors.black.withOpacity(0.1)  // Dark overlay for light backgrounds
                            : Colors.white.withOpacity(0.15), // Light overlay for dark backgrounds
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: _useDarkTextOnBackground
                                ? Colors.black.withOpacity(0.2)
                                : Colors.white.withOpacity(0.3)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: InkWell(
                        onTap: () {
                          // Handle navigation to Communities
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigating to My Communities'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: textColor,
                              size: 20,
                              shadows: textShadows,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'My Communities',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                shadows: textShadows,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: textColor,
                              size: 16,
                              shadows: textShadows,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Add some padding at the bottom of the background container
                    SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ),

          // Bio section with lighter background
          ProfileBio(
            bioText: _customBioText,
            themeColor: _themeColor,
            websiteUrl: _websiteUrl,
          ),

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
              indicatorColor: _themeColor,
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

          // Tab content based on selected tab
          IndexedStack(
            index: _tabController.index,
            children: [
              // Posts Tab
              ProfilePostsTab(
                profileImagePath: _profileImagePath,
                themeColor: _themeColor,
              ),

              // Artifacts Tab
              ProfileArtifactsTab(
                themeColor: _themeColor,
              ),

              // Saved Items Tab
              ProfileSavedItemsTab(
                themeColor: _themeColor,
              ),
            ],
          ),
        ],
      ),
      // Add floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle create action
        },
        backgroundColor: _themeColor,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}
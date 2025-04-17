import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/colors.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/main/chatter_screen.dart';
import 'screens/main/profile/profile_screen.dart';
import 'screens/main/social/social_screen.dart';
import 'services/auth_service.dart';
import 'widgets/common/custom_app_bar.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HARK!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0,
        ),
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const MainScreen();
        }

        return const AuthScreen();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _profileImagePath; // Track the profile image

  // Update method to handle profile image changes
  void updateProfileImage(String? imagePath) {
    setState(() {
      _profileImagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create the screens list with the original callback
    final List<Widget> _screens = [
      const ChatterScreen(),
      ProfileScreen(
        onProfileImageChanged: (imagePath) {
          updateProfileImage(imagePath);
        },
      ),
      const SocialScreen(),
    ];

    final List<String> _titles = [
      'Chatter',
      'Profile',
      'Social',
    ];

    return Scaffold(
      // Only show AppBar if not on Profile screen (index 1)
      appBar: _selectedIndex != 1 ? CustomAppBar(
        title: _selectedIndex == 0 ? 'HARK!' : _titles[_selectedIndex],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {
              // Navigate to notifications screen
            },
          ),
        ],
      ) : null,
      body: _screens[_selectedIndex],
      // Updated BottomNavigationBar without username
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none, // Important - allows content to overflow
        alignment: Alignment.bottomCenter,
        children: [
          // Standard navigation bar background
          Container(
            height: 56, // Standard height
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Chatter tab
                _buildNavItem(0, Icons.chat_bubble, 'Chatter'),

                // Empty space for profile button
                SizedBox(width: 80),

                // Social tab
                _buildNavItem(2, Icons.people, 'Social'),
              ],
            ),
          ),

          // Elevated profile button without username overlay
          Positioned(
            top: -15, // Move up by 15 pixels to stand out from the bar
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: Container(
                height: 60, // Larger than standard icons
                width: 60,
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _profileImagePath != null
                      ? CircleAvatar(
                    radius: 24, // Doubled from your original 12
                    backgroundImage: FileImage(File(_profileImagePath!)),
                  )
                      : Icon(
                    Icons.person,
                    size: 40, // Larger size
                    color: _selectedIndex == 1 ? AppColors.primary : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for creating navigation items
  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
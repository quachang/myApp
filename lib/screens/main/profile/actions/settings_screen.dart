import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  // Toggle switches for settings
  bool _pushNotifications = true;
  bool _locationEnabled = false;
  bool _onlineStatus = true;
  bool _autoTranslate = false;
  bool _turnOffAds = false;
  bool _announcements = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true, // Add this line to center the title
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Push Notifications
          _buildSwitchTile(
            title: 'Push Notifications',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),

          // Location
          _buildSwitchTile(
            title: 'General Location',
            subtitle: 'To easily get connected to local communities',
            value: _locationEnabled,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
            },
          ),

          // Blocked Users
          _buildNavigationTile(
            title: 'Blocked Users',
            onTap: () {
              // Navigate to blocked users screen
            },
          ),

          // Language
          _buildNavigationTile(
            title: 'Language',
            trailing: const Text('English'),
            onTap: () {
              // Navigate to language selection screen
            },
          ),

          // Online Status
          _buildSwitchTile(
            title: 'Online Status',
            value: _onlineStatus,
            onChanged: (value) {
              setState(() {
                _onlineStatus = value;
              });
            },
          ),

          // Auto Translate
          _buildSwitchTile(
            title: 'Auto Translate',
            value: _autoTranslate,
            onChanged: (value) {
              setState(() {
                _autoTranslate = value;
              });
            },
          ),

          // Turn off ads
          _buildSwitchTile(
            title: 'Turn Off Ads',
            value: _turnOffAds,
            onChanged: (value) {
              setState(() {
                _turnOffAds = value;
              });
            },
          ),

          // Announcements
          _buildSwitchTile(
            title: 'Announcements from HARK! team',
            value: _announcements,
            onChanged: (value) {
              setState(() {
                _announcements = value;
              });
            },
          ),

          // Log out button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () async {
                // Show confirmation dialog
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Log Out'),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  await _authService.signOut();
                  // Navigate to auth screen after sign out
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/auth',
                        (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade800,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Log Out'),
            ),
          ),

          // Version info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
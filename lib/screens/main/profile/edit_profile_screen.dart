import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userNameController = TextEditingController(text: 'Username');
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a full Scaffold instead of a container to take full screen
      body: Column(
        children: [
          // Header with title and buttons
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 12, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
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

          // Form fields with enhanced visual separation
          Expanded(
            child: ListView(
              // Use ClampingScrollPhysics to prevent issues with folding phones
              physics: const ClampingScrollPhysics(),
              children: [
                // Username field - centered text
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person_outline, color: Colors.grey),
                    title: Center(
                      child: TextField(
                        controller: _userNameController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                        ),
                      ),
                    ),
                  ),
                ),

                // Choose Landscape field (moved up, was Add to gallery) - centered text
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.photo_camera, color: Colors.grey),
                    title: const Center(
                      child: Text('Choose Landscape'),
                    ),
                  ),
                ),

                // Background choice - centered text, no Optional text
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.palette, color: Colors.grey),
                    title: const Center(
                      child: Text('Choose Background'),
                    ),
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // Bio section - expanded for user input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      const ListTile(
                        title: Center(
                          child: Text(
                            'Bio',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _bioController,
                          decoration: const InputDecoration(
                            hintText: 'Describe yourself...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ),
                ),

                // Advanced options - centered text
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1),
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const ListTile(
                    leading: Icon(Icons.settings, color: Colors.grey),
                    title: Center(
                      child: Text('Advanced Options'),
                    ),
                  ),
                ),

                // Add extra space at the bottom to ensure scrollability
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
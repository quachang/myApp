import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialUsername;
  final String initialBio;
  final String? profileImagePath; // Add this parameter
  final Function(String, String, String?) onSave; // Updated to handle image path

  const EditProfileScreen({
    Key? key,
    this.initialUsername = 'New User',
    this.initialBio = '',
    this.profileImagePath,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userNameController = TextEditingController();
  final _bioController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isSelectingImage = false;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _userNameController.text = widget.initialUsername;
    _bioController.text = widget.initialBio;
    _selectedImagePath = widget.profileImagePath;
  }

  Future<void> _pickImage() async {
    try {
      // Show loading state
      setState(() {
        _isSelectingImage = true;
      });

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      // Update state based on result
      setState(() {
        _isSelectingImage = false;
        if (pickedFile != null) {
          _selectedImagePath = pickedFile.path;
        }
      });
    } catch (e) {
      print('Error picking image: $e');

      // Show error and reset loading state
      setState(() {
        _isSelectingImage = false;
      });

      _showError('Could not select image. Please try again.');
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Edit My Profile',
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
                    // Call the onSave callback with updated values including the image
                    widget.onSave(
                      _userNameController.text,
                      _bioController.text,
                      _selectedImagePath,
                    );
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
                // Make the CircleAvatar clickable
                  // Make the CircleAvatar clickable
                  GestureDetector(
                    onTap: _isSelectingImage ? null : _pickImage, // Disable when loading
                    child: Stack(
                      children: [
                        // Show loading indicator when selecting image
                        _isSelectingImage
                            ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _selectedImagePath != null
                              ? FileImage(File(_selectedImagePath!))
                              : const NetworkImage('https://via.placeholder.com/120x120') as ImageProvider,
                        ),
                        // Keep the "add" button visible
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
                  ),
                  // Add a SizedBox with height 7 to create space
                  const SizedBox(height: 7),
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
                    title: TextField(
                      controller: _userNameController,
                      textAlign: TextAlign.center,  // This centers the text inside the field
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Username',
                        contentPadding: EdgeInsets.zero,  // Remove padding inside the field
                      ),
                    ),
                    trailing: SizedBox(width: 24),  // Add a trailing widget with the same width as the leading icon
                  ),
                ),
                // Background choice - centered text
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
                    title: const Text(
                      'Choose Background',
                      textAlign: TextAlign.center,
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
// Choose Landscape field - centered text
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
                    title: const Text(
                      'Choose Landscape',
                      textAlign: TextAlign.center,
                    ),
                    trailing: SizedBox(width: 24),  // Balance with leading icon
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
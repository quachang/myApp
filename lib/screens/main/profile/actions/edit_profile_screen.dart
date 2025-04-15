import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialUsername;
  final String initialBio;
  final String? profileImagePath;
  final Function(String, String, String?) onSave;

  const EditProfileScreen({
    Key? key,
    required this.initialUsername,
    required this.initialBio,
    this.profileImagePath,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  String? _selectedImagePath;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Add focus nodes to manage focus
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _bioController = TextEditingController(text: widget.initialBio);
    _selectedImagePath = widget.profileImagePath;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _usernameFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  // Method to unfocus/dismiss keyboard
  void _unfocus() {
    _usernameFocus.unfocus();
    _bioFocus.unfocus();
  }

  // Show bottom sheet for image selection with tap-outside-to-dismiss functionality
  Future<void> _showImagePickerOptions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Make transparent to implement tap-outside-to-dismiss
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {}, // Empty gesture detector to prevent closing when tapping the sheet itself
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library, color: Theme.of(context).primaryColor),
                  title: Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    await _pickImageWithCancellation(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera, color: Theme.of(context).primaryColor),
                  title: Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    await _pickImageWithCancellation(ImageSource.camera);
                  },
                ),
                if (_selectedImagePath != null)
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Remove Photo'),
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                      setState(() {
                        _selectedImagePath = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  // Enhanced image picker that handles cancellation better
  Future<void> _pickImageWithCancellation(ImageSource source) async {
    try {
      // Set a timeout to handle when user taps outside gallery
      final result = await _picker.pickImage(
        source: source,
      ).timeout(
        Duration(minutes: 3), // Long timeout to allow user to select
        onTimeout: () => null, // Return null on timeout
      );

      // Check if the user actually selected an image
      if (result != null) {
        setState(() {
          _selectedImagePath = result.path;
        });
      }
      // If result is null, it means the user canceled, so do nothing
    } catch (e) {
      // Handle any other errors silently
      print('Error picking image: $e');
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Call the onSave callback with the updated values
      widget.onSave(
        _usernameController.text.trim(),
        _bioController.text.trim(),
        _selectedImagePath,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the muted yellow color for the Save button
    final Color mutedYellow = Color(0xFFEFDD6F); // A muted yellow color

    return GestureDetector(
      // Add this GestureDetector to unfocus when tapping anywhere
      onTap: _unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black87),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: mutedYellow, // Muted yellow background
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  )
                      : Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black, // Black text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size(0, 0), // Allow button to shrink to content
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          // Make sure this doesn't interfere with the GestureDetector
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Picture Section - Make entire area tappable
                  Center(
                    child: Stack(
                      children: [
                        // Interactive profile picture area
                        GestureDetector(
                          onTap: _showImagePickerOptions, // Make profile picture tappable
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300, width: 2),
                            ),
                            child: _selectedImagePath != null
                                ? ClipOval(
                              child: Image.file(
                                File(_selectedImagePath!),
                                fit: BoxFit.cover,
                              ),
                            )
                                : const Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        // Camera button overlay
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Username Field - with focus node
                  TextFormField(
                    controller: _usernameController,
                    focusNode: _usernameFocus,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username cannot be empty';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Bio Field - with focus node
                  TextFormField(
                    controller: _bioController,
                    focusNode: _bioFocus,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      hintText: 'Tell us about yourself',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  // Add empty space for tapping
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
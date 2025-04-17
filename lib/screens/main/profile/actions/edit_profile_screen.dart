import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/colors.dart';
import 'theme_color_picker_screen.dart'; // Import the new color picker screen

class EditProfileScreen extends StatefulWidget {
  final String initialUsername;
  final String initialBio;
  final String? profileImagePath;
  final String? backgroundImagePath;
  final Color themeColor;
  final Function(String, String, String?, String?, Color) onSave;

  const EditProfileScreen({
    Key? key,
    required this.initialUsername,
    required this.initialBio,
    this.profileImagePath,
    this.backgroundImagePath,
    this.themeColor = const Color(0xFFEAD78D),
    required this.onSave,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  String? _selectedImagePath;
  String? _selectedBackgroundImagePath;
  Color _selectedThemeColor = const Color(0xFFEAD78D);
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _bioController = TextEditingController(text: widget.initialBio);
    _selectedImagePath = widget.profileImagePath;
    _selectedBackgroundImagePath = widget.backgroundImagePath;
    _selectedThemeColor = widget.themeColor;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _usernameFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  void _unfocus() {
    _usernameFocus.unfocus();
    _bioFocus.unfocus();
  }

  Future<void> _showImagePickerOptions(bool isProfileImage) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {},
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
                  leading: Icon(Icons.photo_library, color: _selectedThemeColor),
                  title: Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImageWithCancellation(ImageSource.gallery, isProfileImage);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera, color: _selectedThemeColor),
                  title: Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImageWithCancellation(ImageSource.camera, isProfileImage);
                  },
                ),
                if ((isProfileImage && _selectedImagePath != null) ||
                    (!isProfileImage && _selectedBackgroundImagePath != null))
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Remove Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        if (isProfileImage) {
                          _selectedImagePath = null;
                        } else {
                          _selectedBackgroundImagePath = null;
                        }
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

  // Method to navigate to the color picker screen
  void _navigateToColorPicker() async {
    final selectedColor = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThemeColorPickerScreen(
          initialColor: _selectedThemeColor,
          onColorSelected: (color) {
            setState(() {
              _selectedThemeColor = color;
            });
          },
        ),
      ),
    );

    // Update color if returned (not needed with the callback, but added for redundancy)
    if (selectedColor != null) {
      setState(() {
        _selectedThemeColor = selectedColor;
      });
    }
  }

  Future<void> _pickImageWithCancellation(ImageSource source, bool isProfileImage) async {
    try {
      final result = await _picker.pickImage(
        source: source,
      ).timeout(
        Duration(minutes: 3),
        onTimeout: () => null,
      );

      if (result != null) {
        setState(() {
          if (isProfileImage) {
            _selectedImagePath = result.path;
          } else {
            _selectedBackgroundImagePath = result.path;
          }
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      widget.onSave(
        _usernameController.text.trim(),
        _bioController.text.trim(),
        _selectedImagePath,
        _selectedBackgroundImagePath,
        _selectedThemeColor,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  color: _selectedThemeColor,
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
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size(0, 0),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Picture Section
                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _showImagePickerOptions(true),
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showImagePickerOptions(true),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _selectedThemeColor,
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

                  // Background Image Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Background Photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _showImagePickerOptions(false),
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: _selectedBackgroundImagePath != null
                                  ? null
                                  : _selectedThemeColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                              image: _selectedBackgroundImagePath != null
                                  ? DecorationImage(
                                image: FileImage(File(_selectedBackgroundImagePath!)),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: _selectedBackgroundImagePath == null
                                ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    size: 40,
                                    color: _selectedThemeColor,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap to add background photo',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : null,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This image will be displayed as your profile header background.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Theme Color Section - Click to open color picker
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme Color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: _navigateToColorPicker,
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _selectedThemeColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Tap to change theme color',
                                style: TextStyle(
                                  color: _isDarkColor(_selectedThemeColor)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This color will be used as your profile theme throughout the app.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Username Field
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

                  // Bio Field
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

  // Helper method to determine if a color is dark
  bool _isDarkColor(Color color) {
    // Calculate the brightness using the luminance formula
    // Luminance = 0.299 * R + 0.587 * G + 0.114 * B
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance < 0.5;
  }
}
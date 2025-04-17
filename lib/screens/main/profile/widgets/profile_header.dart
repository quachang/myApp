import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String? profileImagePath;
  final String? backgroundImagePath; // Added for background image
  final VoidCallback onOptionsPressed;

  const ProfileHeader({
    Key? key,
    required this.username,
    this.profileImagePath,
    this.backgroundImagePath, // New parameter
    required this.onOptionsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Background image container
          Container(
            height: 150, // Height for the background image
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Default color if no image
              image: backgroundImagePath != null
                  ? DecorationImage(
                image: FileImage(File(backgroundImagePath!)),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            // Options button overlay
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 16),
                child: IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white, // White for better visibility over images
                    size: 28,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: onOptionsPressed,
                ),
              ),
            ),
          ),

          // Profile picture - positioned to overlap the background image
          Transform.translate(
            offset: Offset(0, -50), // Move up to overlap with background
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: profileImagePath != null
                    ? FileImage(File(profileImagePath!))
                    : const NetworkImage('https://via.placeholder.com/120x120') as ImageProvider,
              ),
            ),
          ),

          // Username with reduced top margin since we moved the avatar up
          Transform.translate(
            offset: Offset(0, -40),
            child: Column(
              children: [
                // Username - with black text
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.black,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
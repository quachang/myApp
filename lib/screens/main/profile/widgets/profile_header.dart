import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String? profileImagePath;
  final VoidCallback onOptionsPressed;

  const ProfileHeader({
    Key? key,
    required this.username,
    this.profileImagePath,
    required this.onOptionsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 0, bottom: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          // Add the 3 dots at the top of the profile section
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 0, bottom: 0),
              child: IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                  size: 28,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: onOptionsPressed,
              ),
            ),
          ),

          // Profile picture
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: profileImagePath != null
                  ? FileImage(File(profileImagePath!))
                  : const NetworkImage('https://via.placeholder.com/120x120') as ImageProvider,
            ),
          ),

          const SizedBox(height: 16),

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
    );
  }
}
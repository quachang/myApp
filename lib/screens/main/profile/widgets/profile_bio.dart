import 'package:flutter/material.dart';

class ProfileBio extends StatelessWidget {
  final String bioText;

  const ProfileBio({
    Key? key,
    required this.bioText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Static "Member since" text
          Text(
            'Member since June 2018 (6 years, 294 days)',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),

          // Only show the custom bio if it's not empty
          if (bioText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              bioText,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
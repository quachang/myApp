import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

class ProfileCommunities extends StatelessWidget {
  const ProfileCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          // Handle navigation to Communities
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navigating to My Communities'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Row(
          children: [
            Icon(
              Icons.people,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'My Communities',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color themeColor; // Add theme color parameter
  final VoidCallback? onPressed;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.count,
    this.themeColor = const Color(0xFFEAD78D), // Default to AppColors.primary
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: themeColor, // Use theme color for icon
          ),
          const SizedBox(width: 4),
          Text(
            count.isNotEmpty ? '$label ($count)' : label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
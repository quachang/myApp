import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildStatColumn('97', 'Aura'),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: _buildStatColumn('2', 'Following'),
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildStatColumn('5', 'Followers'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
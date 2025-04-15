import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

class ProfileArtifactsTab extends StatelessWidget {
  const ProfileArtifactsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample artifact data
    final List<Map<String, dynamic>> artifacts = [
      {
        'type': 'Badge',
        'name': 'Early Adopter',
        'icon': Icons.military_tech,
        'color': Colors.amber,
        'description': 'Awarded to users who joined during the beta period.'
      },
      {
        'type': 'Achievement',
        'name': 'Content Creator',
        'icon': Icons.create,
        'color': Colors.blue,
        'description': 'Created and shared 10+ original posts.'
      },
      {
        'type': 'Token',
        'name': 'Community Champion',
        'icon': Icons.groups,
        'color': Colors.green,
        'description': 'Recognized for exceptional contributions to community discussions.'
      },
      {
        'type': 'Digital Art',
        'name': 'Jester\'s Crown',
        'icon': Icons.auto_awesome,
        'color': Colors.purple,
        'description': 'A special NFT awarded for reaching Level 5 as a Jester.'
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Info banner explaining artifacts
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Digital Artifacts',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Your unique digital items, badges, and achievements earned through participation.',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Artifacts list
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(12),
          itemCount: artifacts.length,
          itemBuilder: (context, index) {
            final artifact = artifacts[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Artifact icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: artifact['color'].withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        artifact['icon'],
                        color: artifact['color'],
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Artifact details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              artifact['type'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Name
                          Text(
                            artifact['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Description
                          Text(
                            artifact['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          // View details button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Show artifact details
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Viewing ${artifact['name']} details'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
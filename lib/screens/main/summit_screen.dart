import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';

class SummitScreen extends StatefulWidget {
  const SummitScreen({Key? key}) : super(key: key);

  @override
  _SummitScreenState createState() => _SummitScreenState();
}

class _SummitScreenState extends State<SummitScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedPerspective = 'All';

  // AI personas with different political perspectives
  final List<Map<String, dynamic>> _aiPersonas = [
    {
      'name': 'Liberty',
      'perspective': 'Conservative',
      'avatar': 'L',
      'color': Colors.red.shade200,
      'description': 'Provides conservative and traditional viewpoints on current events and social issues.'
    },
    {
      'name': 'Progress',
      'perspective': 'Progressive',
      'avatar': 'P',
      'color': Colors.blue.shade200,
      'description': 'Offers progressive and forward-thinking perspectives on politics and social challenges.'
    },
    {
      'name': 'Centrist',
      'perspective': 'Moderate',
      'avatar': 'C',
      'color': Colors.purple.shade200,
      'description': 'Presents balanced and moderate political analysis, considering multiple viewpoints.'
    },
    {
      'name': 'Global',
      'perspective': 'International',
      'avatar': 'G',
      'color': Colors.green.shade200,
      'description': 'Provides perspectives from an international and global point of view.'
    },
  ];

  // Filter options for different political perspectives
  final List<String> _perspectives = [
    'All',
    'Conservative',
    'Progressive',
    'Moderate',
    'International'
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Categories horizontal list
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _perspectives.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final perspective = _perspectives[index];
                final isSelected = perspective == _selectedPerspective;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPerspective = perspective;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      perspective,
                      style: AppStyles.buttonTextStyle.copyWith(
                        color: isSelected ? Colors.black87 : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // AI Personas section (visible only in 'All' view)
          if (_selectedPerspective == 'All')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summit AI Contributors',
                    style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summit features posts written by 4 AI personas with diverse political perspectives to provide a well-rounded view on current topics.',
                          style: AppStyles.bodyText2,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _aiPersonas.map((persona) {
                            return Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: persona['color'],
                                  radius: 25,
                                  child: Text(
                                    persona['avatar'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  persona['name'],
                                  style: AppStyles.caption.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  persona['perspective'],
                                  style: AppStyles.caption,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Content list with AI-generated posts
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                // Implement refresh logic
                await Future.delayed(const Duration(seconds: 1));
              },
              child: _buildAiContentList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiContentList() {
    // Filter the content based on selected perspective
    List<Map<String, dynamic>> filteredPersonas = _aiPersonas;
    if (_selectedPerspective != 'All') {
      filteredPersonas = _aiPersonas.where((persona) =>
      persona['perspective'] == _selectedPerspective).toList();
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // Generate mock AI posts
        ...List.generate(10, (index) {
          // Cycle through AI personas
          final aiPersona = filteredPersonas.isEmpty
              ? _aiPersonas[index % _aiPersonas.length]
              : filteredPersonas[index % filteredPersonas.length];
          return _buildAiPostCard(index, aiPersona);
        }),
      ],
    );
  }

  Widget _buildAiPostCard(int index, Map<String, dynamic> aiPersona) {
    // List of mock topics
    final List<String> topics = [
      'Universal Basic Income: Policy Analysis',
      'Climate Change: Economic Impact',
      'Healthcare Reform: Perspectives',
      'Education Policy: Future Directions',
      'Immigration: Policy Approaches',
      'Infrastructure Investment: Analysis',
      'Technology Regulation: Balancing Innovation and Safety',
      'Criminal Justice Reform: Different Approaches',
      'Economic Outlook: Next Quarter Predictions',
      'International Trade Relations: Analysis',
    ];

    // Get a topic based on the index
    final String topic = topics[index % topics.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI persona info row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: aiPersona['color'],
                radius: 20,
                child: Text(
                  aiPersona['avatar'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        aiPersona['name'],
                        style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.verified, size: 16, color: aiPersona['color']),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: aiPersona['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      aiPersona['perspective'],
                      style: AppStyles.caption.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '${index + 1}d ago',
                style: AppStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Post title
          Text(
            topic,
            style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Post content - simulating different perspectives
          _buildAiPerspectiveContent(aiPersona['perspective'], topic),

          const SizedBox(height: 16),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: aiPersona['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#${topic.split(':')[0].toLowerCase().replaceAll(' ', '')}',
                  style: AppStyles.caption.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: aiPersona['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#${aiPersona['perspective'].toLowerCase()}',
                  style: AppStyles.caption.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: aiPersona['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#summit',
                  style: AppStyles.caption.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Discussion prompt
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 16, color: aiPersona['color']),
                    const SizedBox(width: 8),
                    Text(
                      'Discussion Prompt',
                      style: AppStyles.bodyText2.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getDiscussionPrompt(topic),
                  style: AppStyles.bodyText2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Engagement stats
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 12}',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${(index + 1) * 8}',
                style: AppStyles.caption,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: aiPersona['color'],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Discuss'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiPerspectiveContent(String perspective, String topic) {
    // Sample content based on political perspective
    String content = '';

    switch (perspective) {
      case 'Conservative':
        content = 'From a conservative perspective, the key priorities for ${topic.split(':')[0]} should be preserving traditional values and ensuring fiscal responsibility. We must carefully consider the long-term implications and focus on market-based solutions that minimize government intervention.';
        break;
      case 'Progressive':
        content = 'From a progressive standpoint, ${topic.split(':')[0]} requires bold action and systemic change. We must focus on equity and inclusivity, ensuring that policies benefit all members of society, especially those who have been historically marginalized.';
        break;
      case 'Moderate':
        content = 'Taking a moderate approach to ${topic.split(':')[0]} means finding common ground between different viewpoints. We should focus on evidence-based policies that have bipartisan support, allowing for incremental changes while maintaining stability.';
        break;
      case 'International':
        content = 'From an international perspective, ${topic.split(':')[0]} must be considered in a global context. How do different countries approach this issue? We can learn from successful models abroad while adapting solutions to fit local contexts and respecting cultural differences.';
        break;
      default:
        content = 'Analyzing various perspectives on ${topic.split(':')[0]} reveals complex considerations that stakeholders must carefully evaluate to find optimal solutions.';
    }

    return Text(
      content,
      style: AppStyles.bodyText2,
    );
  }

  String _getDiscussionPrompt(String topic) {
    // Create discussion prompts based on the topic
    final topicName = topic.split(':')[0];

    final List<String> prompts = [
      'What aspects of $topicName do you think deserve more attention in public discourse?',
      'Do you believe there are perspectives on $topicName that are underrepresented in mainstream discussions?',
      'How might different cultural contexts influence approaches to $topicName?',
      'What compromises do you think could bridge different viewpoints on $topicName?',
      'How has your understanding of $topicName evolved over time?',
    ];

    // Return a prompt based on the hash of the topic to ensure consistency
    return prompts[topicName.length % prompts.length];
  }
}
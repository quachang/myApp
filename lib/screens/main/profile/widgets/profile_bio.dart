import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class ProfileBio extends StatefulWidget {
  final String bioText;
  final Color themeColor;
  final String? websiteUrl;

  const ProfileBio({
    Key? key,
    required this.bioText,
    this.themeColor = const Color(0xFFEAD78D),
    this.websiteUrl,
  }) : super(key: key);

  @override
  _ProfileBioState createState() => _ProfileBioState();
}

class _ProfileBioState extends State<ProfileBio> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // Method to open URLs
  Future<void> _launchUrl(String urlString) async {
    // Ensure URL has a scheme (http/https)
    final String urlToLaunch = urlString.startsWith('http')
        ? urlString
        : 'https://$urlString';

    final Uri url = Uri.parse(urlToLaunch);

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        // Show error if URL can't be launched
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $urlToLaunch'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error if any exception occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening link: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Member since text (always visible - tap to collapse)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Member since June 2018 (6 years, 294 days)',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: widget.themeColor,
                  ),
                ),
              ],
            ),

            // Animated expanded content
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: double.infinity,
                child: _isExpanded
                    ? Column(
                  children: [
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 12),

                    // Bio text
                    Text(
                      widget.bioText.isNotEmpty
                          ? widget.bioText
                          : 'No bio added yet. Tap the Edit Profile button to add your bio.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Additional info in expanded state
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoItem(Icons.location_on, 'New York, USA', null),
                        if (widget.websiteUrl != null && widget.websiteUrl!.isNotEmpty) ...[
                          const SizedBox(width: 24),
                          _buildInfoItem(Icons.link, widget.websiteUrl!, widget.websiteUrl),
                        ],
                      ],
                    ),
                  ],
                )
                    : widget.bioText.isNotEmpty
                    ? Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      widget.bioText,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, String? linkUrl) {
    return InkWell(
      onTap: linkUrl != null ? () => _launchUrl(linkUrl) : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: widget.themeColor,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                decoration: linkUrl != null ? TextDecoration.underline : TextDecoration.none, // Underline links
              ),
            ),
          ],
        ),
      ),
    );
  }
}
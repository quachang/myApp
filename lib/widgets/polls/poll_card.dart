import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../models/poll_model.dart';

class PollCard extends StatefulWidget {
  final PollModel poll;
  final Function(String, String)? onVote;

  const PollCard({
    Key? key,
    required this.poll,
    this.onVote,
  }) : super(key: key);

  @override
  _PollCardState createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  String? _selectedOptionId;
  bool _hasVoted = false;

  @override
  Widget build(BuildContext context) {
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
          // User info row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 20,
                child: Icon(Icons.person, color: Colors.grey.shade400),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.poll.isAnonymous ? 'Anonymous' : 'User Name', // Replace with actual user data
                    style: AppStyles.subtitle2.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        _getTimeAgo(widget.poll.createdAt),
                        style: AppStyles.caption,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.poll.category,
                          style: AppStyles.caption.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 16),

          // Poll question
          Text(
            widget.poll.question,
            style: AppStyles.subtitle1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Poll options
          ...widget.poll.options.map((option) => _buildPollOption(option)).toList(),

          const SizedBox(height: 16),

          // Poll stats
          Row(
            children: [
              Icon(Icons.how_to_vote, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${widget.poll.totalVotes} votes',
                style: AppStyles.caption,
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                _getRemainingTime(),
                style: AppStyles.caption,
              ),
            ],
          ),

          if (!_hasVoted && _selectedOptionId != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedOptionId != null) {
                        widget.onVote?.call(widget.poll.id, _selectedOptionId!);
                        setState(() {
                          _hasVoted = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Submit Vote'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPollOption(PollOption option) {
    final bool isSelected = _selectedOptionId == option.id;
    final double percentage = widget.poll.getPercentage(option.id);
    final bool showResults = _hasVoted || widget.poll.isExpired;

    return GestureDetector(
      onTap: () {
        if (!_hasVoted && !widget.poll.isExpired) {
          setState(() {
            _selectedOptionId = option.id;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (!showResults && !widget.poll.isExpired)
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade400,
                  ),
                if (!showResults && !widget.poll.isExpired)
                  const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.text,
                    style: AppStyles.bodyText2.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (showResults)
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: AppStyles.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            if (showResults) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.shade200,
                  color: AppColors.primary,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${option.votes} votes',
                  style: AppStyles.caption,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  String _getRemainingTime() {
    if (widget.poll.isExpired) {
      return 'Poll ended';
    }

    final Duration timeLeft = widget.poll.timeLeft;

    if (timeLeft.inMinutes < 60) {
      return '${timeLeft.inMinutes}m left';
    } else if (timeLeft.inHours < 24) {
      return '${timeLeft.inHours}h left';
    } else {
      return '${timeLeft.inDays}d left';
    }
  }
}
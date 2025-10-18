import 'package:flutter/material.dart';

class ProposalCard extends StatelessWidget {
  final Map<String, dynamic> proposal;
  final Function(String, bool)? onVote;

  const ProposalCard({
    super.key,
    required this.proposal,
    this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final votesFor = proposal['votesFor'] as int;
    final votesAgainst = proposal['votesAgainst'] as int;
    final totalVotes = proposal['totalVotes'] as int;
    final endDate = proposal['endDate'] as DateTime;
    final status = proposal['status'] as String;

    final forPercentage = totalVotes > 0 ? (votesFor / totalVotes) * 100 : 0.0;
    final againstPercentage =
        totalVotes > 0 ? (votesAgainst / totalVotes) * 100 : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    proposal['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(theme, status),
              ],
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              proposal['description'] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Proposer and End Date
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  'By ${proposal['proposer']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  _getTimeRemaining(endDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Voting Progress
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'For: ${forPercentage.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Against: ${againstPercentage.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: totalVotes > 0 ? votesFor / totalVotes : 0,
                  backgroundColor: Colors.red.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_formatNumber(votesFor)} votes',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '${_formatNumber(votesAgainst)} votes',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Voting Buttons (only for active proposals)
            if (status == 'active' && onVote != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => onVote!(proposal['id'], false),
                      icon: const Icon(Icons.thumb_down, size: 16),
                      label: const Text('Against'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onVote!(proposal['id'], true),
                      icon: const Icon(Icons.thumb_up, size: 16),
                      label: const Text('For'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

            // Result for past proposals
            if (status != 'active')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getResultColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getResultIcon(status),
                      color: _getResultColor(status),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status == 'passed'
                          ? 'Proposal Passed'
                          : 'Proposal Rejected',
                      style: TextStyle(
                        color: _getResultColor(status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, String status) {
    Color color;
    String text;

    switch (status) {
      case 'active':
        color = theme.colorScheme.primary;
        text = 'Active';
        break;
      case 'passed':
        color = Colors.green;
        text = 'Passed';
        break;
      case 'rejected':
        color = Colors.red;
        text = 'Rejected';
        break;
      default:
        color = theme.colorScheme.outline;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getTimeRemaining(DateTime endDate) {
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      return 'Ended';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h remaining';
    } else {
      return '${difference.inMinutes}m remaining';
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  Color _getResultColor(String status) {
    switch (status) {
      case 'passed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getResultIcon(String status) {
    switch (status) {
      case 'passed':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}

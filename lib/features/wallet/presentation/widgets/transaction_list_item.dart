import 'package:flutter/material.dart';
import '../../../../models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncoming = transaction.sellerId == 'current_user'; // Mock current user check
    
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getStatusColor(transaction.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTransactionIcon(isIncoming),
            color: _getStatusColor(transaction.status),
          ),
        ),
        title: Text(
          _getTransactionTitle(isIncoming),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getTransactionSubtitle(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                _buildStatusChip(theme),
                const SizedBox(width: 8),
                Text(
                  _getFormattedDate(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncoming ? '+' : '-'}${transaction.formattedAmount}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isIncoming 
                  ? Colors.green 
                  : theme.colorScheme.error,
              ),
            ),
            if (transaction.platformFee > 0 && isIncoming)
              Text(
                'Fee: ${transaction.platformFee.toStringAsFixed(2)} ${transaction.currency}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    final color = _getStatusColor(transaction.status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        transaction.status.displayName,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getTransactionIcon(bool isIncoming) {
    if (transaction.status.isFailed) {
      return Icons.error;
    }
    
    return isIncoming ? Icons.arrow_downward : Icons.arrow_upward;
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
      case TransactionStatus.processing:
        return Colors.orange;
      case TransactionStatus.failed:
      case TransactionStatus.cancelled:
        return Colors.red;
      case TransactionStatus.refunded:
        return Colors.blue;
    }
  }

  String _getTransactionTitle(bool isIncoming) {
    if (isIncoming) {
      return 'Dataset Sale';
    } else {
      return 'Dataset Purchase';
    }
  }

  String _getTransactionSubtitle() {
    return 'Transaction ID: ${transaction.id}';
  }

  String _getFormattedDate() {
    final date = transaction.createdAt;
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

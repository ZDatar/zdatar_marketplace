import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/dataset.dart';

class PurchaseDialog extends ConsumerStatefulWidget {
  final Dataset dataset;

  const PurchaseDialog({
    super.key,
    required this.dataset,
  });

  @override
  ConsumerState<PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends ConsumerState<PurchaseDialog> {
  bool _isProcessing = false;
  String? _selectedWallet;
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Purchase Dataset',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Dataset Info
            _buildDatasetInfo(theme),

            const SizedBox(height: 16),

            // Wallet Selection
            _buildWalletSelection(theme),

            const SizedBox(height: 16),

            // Price Breakdown
            _buildPriceBreakdown(theme),

            const SizedBox(height: 16),

            // Terms and Conditions
            _buildTermsSection(theme),

            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDatasetInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                widget.dataset.category.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dataset.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${widget.dataset.formattedFileSize} • ${widget.dataset.category.displayName}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSelection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Wallet',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildWalletOption(
                theme,
                'Phantom',
                'phantom',
                '7xKX...sU (Connected)',
                '12.5 SOL • 1,250 USDC',
                Icons.account_balance_wallet,
              ),
              const Divider(height: 1),
              _buildWalletOption(
                theme,
                'Solflare',
                'solflare',
                'Not Connected',
                null,
                Icons.account_balance_wallet_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWalletOption(
    ThemeData theme,
    String name,
    String value,
    String status,
    String? balance,
    IconData icon,
  ) {
    final isConnected = balance != null;
    final isSelected = _selectedWallet == value;

    return InkWell(
      onTap: isConnected
          ? () {
              setState(() {
                _selectedWallet = value;
              });
            }
          : () => _connectWallet(value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary)
              : null,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedWallet,
              onChanged: isConnected
                  ? (val) {
                      setState(() {
                        _selectedWallet = val;
                      });
                    }
                  : null,
            ),
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isConnected
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  if (balance != null)
                    Text(
                      balance,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
            if (!isConnected)
              TextButton(
                onPressed: () => _connectWallet(value),
                child: const Text('Connect'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(ThemeData theme) {
    final platformFee = widget.dataset.price * 0.025; // 2.5% platform fee
    final total = widget.dataset.price + platformFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Breakdown',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildPriceRow(theme, 'Dataset Price',
                  '${widget.dataset.price} ${widget.dataset.currency}'),
              _buildPriceRow(theme, 'Platform Fee (2.5%)',
                  '${platformFee.toStringAsFixed(2)} ${widget.dataset.currency}'),
              const Divider(),
              _buildPriceRow(
                theme,
                'Total',
                '${total.toStringAsFixed(2)} ${widget.dataset.currency}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(ThemeData theme, String label, String amount,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: _acceptedTerms,
          onChanged: (value) {
            setState(() {
              _acceptedTerms = value ?? false;
            });
          },
          title: Text(
            'I agree to the Terms of Use and Privacy Policy',
            style: theme.textTheme.bodyMedium,
          ),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Data is encrypted and can only be decrypted by you',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '• No refunds after successful decryption',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '• Data usage subject to seller\'s license terms',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    final canPurchase =
        _selectedWallet != null && _acceptedTerms && !_isProcessing;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: canPurchase ? _processPurchase : null,
            child: _isProcessing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Purchase'),
          ),
        ),
      ],
    );
  }

  void _connectWallet(String walletType) {
    // Implement wallet connection logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connecting to $walletType...')),
    );
  }

  Future<void> _processPurchase() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate blockchain transaction
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        Navigator.of(context).pop();
        _showPurchaseSuccess();
      }
    } catch (e) {
      if (mounted) {
        _showPurchaseError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showPurchaseSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.secondary,
          size: 48,
        ),
        title: const Text('Purchase Successful!'),
        content: const Text(
          'Your dataset has been purchased successfully. You can now download and decrypt it from your purchases.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        title: const Text('Purchase Failed'),
        content: Text('Failed to complete purchase: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

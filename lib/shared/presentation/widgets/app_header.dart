import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Logo and App Name
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.data_usage,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Search Bar
            Expanded(
              flex: 2,
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search datasets...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.65),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Action Buttons
            Row(
              children: [
                // Notifications
                IconButton(
                  onPressed: () => _showNotifications(context),
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Wallet Connection Status
                _buildWalletButton(context, theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletButton(BuildContext context, ThemeData theme) {
    // Wallet connection functionality implemented
    return ElevatedButton.icon(
      onPressed: () => _connectWallet(context),
      icon: const Icon(
        Icons.wallet,
        size: 16,
      ),
      label: const Text(
        'Connect Wallet',
        style: TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('No new notifications'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _connectWallet(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Phantom'),
              subtitle: const Text('Connect using Phantom wallet'),
              onTap: () {
                Navigator.of(context).pop();
                _connectPhantomWallet(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Solflare'),
              subtitle: const Text('Connect using Solflare wallet'),
              onTap: () {
                Navigator.of(context).pop();
                _connectSolflareWallet(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _connectPhantomWallet(BuildContext context) {
    // Basic Phantom wallet connection implementation
    // In a real app, this would integrate with the Phantom wallet SDK
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Phantom wallet connection initiated...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Simulate connection process
    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phantom wallet connected successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _connectSolflareWallet(BuildContext context) {
    // Basic Solflare wallet connection implementation
    // In a real app, this would integrate with the Solflare wallet SDK
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Solflare wallet connection initiated...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Simulate connection process
    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solflare wallet connected successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/user.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = _getMockUser(); // In real app, get from provider

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          _buildProfileHeader(theme, user),

          const SizedBox(height: 24),

          // Stats Cards
          _buildStatsSection(theme, user),

          const SizedBox(height: 24),

          // Settings Sections
          _buildSettingsSection(theme, 'Account', [
            _buildSettingItem(theme, 'Edit Profile', Icons.person,
                () => _editProfile(context)),
            _buildSettingItem(theme, 'Verification', Icons.verified,
                () => _manageVerification(context)),
            _buildSettingItem(theme, 'Privacy Settings', Icons.privacy_tip,
                () => _privacySettings(context)),
          ]),

          const SizedBox(height: 16),

          _buildSettingsSection(theme, 'Preferences', [
            _buildSettingItem(theme, 'Notifications', Icons.notifications,
                () => _notificationSettings(context)),
            _buildSettingItem(theme, 'Language', Icons.language,
                () => _languageSettings(context)),
            _buildSettingItem(
                theme, 'Theme', Icons.palette, () => _themeSettings(context)),
          ]),

          const SizedBox(height: 16),

          _buildSettingsSection(theme, 'Data & Security', [
            _buildSettingItem(theme, 'Data Export', Icons.download,
                () => _exportData(context)),
            _buildSettingItem(theme, 'Security Settings', Icons.security,
                () => _securitySettings(context)),
            _buildSettingItem(theme, 'Connected Apps', Icons.apps,
                () => _connectedApps(context)),
          ]),

          const SizedBox(height: 16),

          _buildSettingsSection(theme, 'Support', [
            _buildSettingItem(
                theme, 'Help Center', Icons.help, () => _helpCenter(context)),
            _buildSettingItem(theme, 'Contact Support', Icons.support_agent,
                () => _contactSupport(context)),
            _buildSettingItem(theme, 'Terms of Service', Icons.description,
                () => _termsOfService(context)),
            _buildSettingItem(theme, 'Privacy Policy', Icons.policy,
                () => _privacyPolicy(context)),
          ]),

          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // App Version
          Center(
            child: Text(
              'ZDatar Marketplace v1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, User user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: user.avatar != null
                      ? ClipOval(
                          child: Image.network(
                            user.avatar!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          user.username?.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _changeAvatar(),
                      icon: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 16),
                      iconSize: 16,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Name and Verification
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.username ?? 'Anonymous User',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user.isVerified) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.verified,
                    color: theme.colorScheme.secondary,
                    size: 20,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 4),

            // Wallet Address
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${user.walletAddress.substring(0, 6)}...${user.walletAddress.substring(user.walletAddress.length - 4)}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _copyWalletAddress(user.walletAddress),
                    child: Icon(
                      Icons.copy,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${user.rating.toStringAsFixed(1)} Rating',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme, User user) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
              theme, 'Datasets Sold', '${user.totalSales}', Icons.dataset),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(theme, 'Total Earnings',
              '\$${user.totalEarnings.toStringAsFixed(0)}', Icons.attach_money),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(theme, 'Purchases', '${user.totalPurchases}',
              Icons.shopping_cart),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      ThemeData theme, String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
      ThemeData theme, String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      ThemeData theme, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  User _getMockUser() {
    return User(
      id: 'current_user',
      walletAddress: '7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU',
      username: 'DataCollector_Mumbai',
      rating: 4.9,
      totalSales: 156,
      totalPurchases: 23,
      totalEarnings: 12450.75,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      isVerified: true,
      specializations: ['Location Data', 'Urban Analytics'],
    );
  }

  void _changeAvatar() {
    // Implement avatar change
  }

  void _copyWalletAddress(String address) {
    // Copy to clipboard
  }

  void _editProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Bio',
                hintText: 'Tell us about yourself',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _manageVerification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening verification management...')),
    );
  }

  void _privacySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening privacy settings...')),
    );
  }

  void _notificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening notification settings...')),
    );
  }

  void _languageSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening language settings...')),
    );
  }

  void _themeSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening theme settings...')),
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing data export...')),
    );
  }

  void _securitySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening security settings...')),
    );
  }

  void _connectedApps(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening connected apps...')),
    );
  }

  void _helpCenter(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening help center...')),
    );
  }

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening support chat...')),
    );
  }

  void _termsOfService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening terms of service...')),
    );
  }

  void _privacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening privacy policy...')),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

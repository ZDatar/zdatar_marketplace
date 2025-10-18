import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import 'error_boundary.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildWebNavigationBar(context, theme),
              Expanded(
                child: ErrorBoundary(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 0,
                      maxHeight: constraints.maxHeight - 80, // Subtract nav bar height
                    ),
                    child: child,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWebNavigationBar(BuildContext context, ThemeData theme) {
    final currentLocation = GoRouterState.of(context).uri.path;
    
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Logo and Brand
            _buildLogo(theme),
            const SizedBox(width: 48),
            
            // Main Navigation
            Expanded(
              child: _buildMainNavigation(context, currentLocation, theme),
            ),
            
            // Right Side Actions
            _buildRightActions(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
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
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'ZDatar',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildMainNavigation(BuildContext context, String currentLocation, ThemeData theme) {
    final navItems = [
      {'route': AppRoutes.home, 'label': 'Home', 'icon': Icons.home_outlined},
      {'route': AppRoutes.marketplace, 'label': 'Marketplace', 'icon': Icons.store_outlined},
      {'route': AppRoutes.myData, 'label': 'My Data', 'icon': Icons.dataset_outlined},
      {'route': AppRoutes.dao, 'label': 'DAO', 'icon': Icons.how_to_vote_outlined},
    ];

    return Row(
      children: navItems.map((item) {
        final isSelected = _isRouteSelected(currentLocation, item['route'] as String);
        
        return Padding(
          padding: const EdgeInsets.only(right: 32),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go(item['route'] as String),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 20,
                      color: isSelected 
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['label'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRightActions(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wallet Button
        _buildActionButton(
          context,
          theme,
          icon: Icons.account_balance_wallet_outlined,
          label: 'Wallet',
          onTap: () => context.go(AppRoutes.wallet),
        ),
        const SizedBox(width: 16),
        
        // Profile Menu
        _buildProfileMenu(context, theme),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(label, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      constraints: const BoxConstraints(
        minWidth: 200,
        maxWidth: 300,
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Icon(
          Icons.person,
          size: 24,
          color: theme.colorScheme.primary,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.person_outline, size: 18),
              const SizedBox(width: 12),
              Text('Profile', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              const Icon(Icons.settings_outlined, size: 18),
              const SizedBox(width: 12),
              Text('Settings', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, size: 18),
              const SizedBox(width: 12),
              Text('Logout', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'profile':
            context.go(AppRoutes.profile);
            break;
          case 'settings':
            // Handle settings
            break;
          case 'logout':
            // Handle logout
            break;
        }
      },
    );
  }

  bool _isRouteSelected(String currentLocation, String route) {
    if (route == AppRoutes.home) {
      return currentLocation == route;
    }
    return currentLocation.startsWith(route);
  }
}

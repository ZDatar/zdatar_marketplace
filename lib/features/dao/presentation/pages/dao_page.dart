import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/governance_stats.dart';
import '../widgets/proposal_card.dart';
import '../widgets/voting_power_card.dart';

class DaoPage extends ConsumerStatefulWidget {
  const DaoPage({super.key});

  @override
  ConsumerState<DaoPage> createState() => _DaoPageState();
}

class _DaoPageState extends ConsumerState<DaoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // DAO Header
          _buildDaoHeader(theme),

          // Governance Stats
          const Padding(
            padding: EdgeInsets.all(16),
            child: GovernanceStats(),
          ),

          // Voting Power
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: VotingPowerCard(),
          ),

          const SizedBox(height: 16),

          // Tab Bar
          _buildTabBar(theme),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveProposalsTab(),
                _buildPastProposalsTab(),
                _buildTreasuryTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createProposal,
        icon: const Icon(Icons.add),
        label: const Text('New Proposal'),
      ),
    );
  }

  Widget _buildDaoHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ZDatar DAO',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Decentralized Governance',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _showDaoInfo,
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Participate in governance by staking ZDTR tokens and voting on proposals that shape the future of the marketplace.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.7),
        tabs: const [
          Tab(text: 'Active'),
          Tab(text: 'Past'),
          Tab(text: 'Treasury'),
        ],
      ),
    );
  }

  Widget _buildActiveProposalsTab() {
    final proposals = _getMockActiveProposals();

    if (proposals.isEmpty) {
      return _buildEmptyState(
        'No Active Proposals',
        'There are currently no active proposals to vote on.',
        Icons.how_to_vote,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: proposals.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ProposalCard(
            proposal: proposals[index],
            onVote: (proposalId, vote) => _voteOnProposal(proposalId, vote),
          ),
        );
      },
    );
  }

  Widget _buildPastProposalsTab() {
    final proposals = _getMockPastProposals();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: proposals.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ProposalCard(
            proposal: proposals[index],
            onVote: null, // Past proposals can't be voted on
          ),
        );
      },
    );
  }

  Widget _buildTreasuryTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Treasury Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Treasury Overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTreasuryMetric(theme, 'Total Value',
                            '\$2.5M', Icons.account_balance),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTreasuryMetric(theme, 'Monthly Revenue',
                            '\$150K', Icons.trending_up),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Treasury Holdings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Treasury Holdings',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHoldingItem(
                      theme, 'SOL', '5,000', '\$500K', Colors.purple),
                  _buildHoldingItem(
                      theme, 'USDC', '1,500,000', '\$1.5M', Colors.blue),
                  _buildHoldingItem(
                      theme, 'ZDTR', '2,000,000', '\$500K', Colors.green),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recent Transactions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Treasury Transactions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTreasuryTransaction(
                      theme,
                      'Platform Fee Collection',
                      '+\$25K',
                      DateTime.now().subtract(const Duration(hours: 2))),
                  _buildTreasuryTransaction(
                      theme,
                      'Development Grant',
                      '-\$50K',
                      DateTime.now().subtract(const Duration(days: 1))),
                  _buildTreasuryTransaction(
                      theme,
                      'Marketing Campaign',
                      '-\$15K',
                      DateTime.now().subtract(const Duration(days: 3))),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Allocation Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fund Allocation',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Allocation Chart Placeholder'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildAllocationItem(
                              theme, 'Development', '40%', Colors.blue)),
                      Expanded(
                          child: _buildAllocationItem(
                              theme, 'Marketing', '25%', Colors.green)),
                      Expanded(
                          child: _buildAllocationItem(
                              theme, 'Operations', '20%', Colors.orange)),
                      Expanded(
                          child: _buildAllocationItem(
                              theme, 'Reserve', '15%', Colors.purple)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTreasuryMetric(
      ThemeData theme, String title, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildHoldingItem(ThemeData theme, String symbol, String amount,
      String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              symbol == 'SOL'
                  ? Icons.currency_bitcoin
                  : symbol == 'USDC'
                      ? Icons.attach_money
                      : Icons.data_usage,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$amount ${symbol.toUpperCase()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreasuryTransaction(
      ThemeData theme, String description, String amount, DateTime date) {
    final isIncoming = amount.startsWith('+');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
            size: 16,
            color: isIncoming ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isIncoming ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationItem(
      ThemeData theme, String category, String percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          category,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        Text(
          percentage,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getMockActiveProposals() {
    return [
      {
        'id': '1',
        'title': 'Reduce Platform Fee to 2%',
        'description':
            'Proposal to reduce the platform fee from 2.5% to 2% to attract more sellers and increase marketplace activity.',
        'proposer': 'Community Member',
        'votesFor': 1250000,
        'votesAgainst': 450000,
        'totalVotes': 1700000,
        'endDate': DateTime.now().add(const Duration(days: 5)),
        'status': 'active',
      },
      {
        'id': '2',
        'title': 'Add New Data Categories',
        'description':
            'Proposal to add new data categories including Environmental, Social Media, and Financial data types.',
        'proposer': 'Core Team',
        'votesFor': 890000,
        'votesAgainst': 210000,
        'totalVotes': 1100000,
        'endDate': DateTime.now().add(const Duration(days: 12)),
        'status': 'active',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockPastProposals() {
    return [
      {
        'id': '3',
        'title': 'Implement Staking Rewards',
        'description':
            'Proposal to implement staking rewards for ZDTR token holders.',
        'proposer': 'Community Member',
        'votesFor': 2100000,
        'votesAgainst': 300000,
        'totalVotes': 2400000,
        'endDate': DateTime.now().subtract(const Duration(days: 15)),
        'status': 'passed',
      },
      {
        'id': '4',
        'title': 'Increase Marketing Budget',
        'description':
            'Proposal to allocate additional funds for marketing and user acquisition.',
        'proposer': 'Core Team',
        'votesFor': 750000,
        'votesAgainst': 1250000,
        'totalVotes': 2000000,
        'endDate': DateTime.now().subtract(const Duration(days: 30)),
        'status': 'rejected',
      },
    ];
  }

  void _showDaoInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About ZDatar DAO'),
        content: const Text(
          'The ZDatar DAO is a decentralized autonomous organization that governs the ZDatar marketplace. Token holders can stake ZDTR tokens to participate in governance and vote on proposals that shape the future of the platform.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _createProposal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening proposal creation form...')),
    );
  }

  void _voteOnProposal(String proposalId, bool vote) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voted ${vote ? 'FOR' : 'AGAINST'} proposal $proposalId'),
      ),
    );
  }
}

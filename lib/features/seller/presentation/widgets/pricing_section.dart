import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';

class PricingSection extends StatelessWidget {
  final TextEditingController priceController;
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;

  const PricingSection({
    super.key,
    required this.priceController,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Input
          _buildSection(
            theme,
            'Set Price *',
            _buildPriceInput(theme),
          ),
          
          const SizedBox(height: 16),
          
          // Currency Selection
          _buildSection(
            theme,
            'Currency',
            _buildCurrencySelector(theme),
          ),
          
          const SizedBox(height: 16),
          
          // Price Breakdown
          _buildPriceBreakdown(theme),
          
          const SizedBox(height: 16),
          
          // Pricing Suggestions
          _buildPricingSuggestions(theme),
          
          const SizedBox(height: 16),
          
          // Market Insights
          _buildMarketInsights(theme),
        ],
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildPriceInput(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: priceController,
            decoration: const InputDecoration(
              hintText: '0.00',
              prefixText: '\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: selectedCurrency,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            items: AppConstants.supportedTokens.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Row(
                  children: [
                    _getCurrencyIcon(currency),
                    const SizedBox(width: 8),
                    Text(currency),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onCurrencyChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: AppConstants.supportedTokens.map((currency) {
            final isSelected = selectedCurrency == currency;
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getCurrencyIcon(currency),
                  const SizedBox(width: 4),
                  Text(currency),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCurrencyChanged(currency);
                }
              },
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: theme.colorScheme.primary,
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the currency for your dataset pricing',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown(ThemeData theme) {
    final price = double.tryParse(priceController.text) ?? 0.0;
    final platformFee = price * 0.025; // 2.5% platform fee
    final youReceive = price - platformFee;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Breakdown',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildBreakdownRow(theme, 'Dataset Price', price, selectedCurrency),
            _buildBreakdownRow(theme, 'Platform Fee (2.5%)', platformFee, selectedCurrency, isDeduction: true),
            const Divider(),
            _buildBreakdownRow(theme, 'You Receive', youReceive, selectedCurrency, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(ThemeData theme, String label, double amount, String currency, {bool isDeduction = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDeduction ? theme.colorScheme.error : null,
            ),
          ),
          Text(
            '${isDeduction ? '-' : ''}${amount.toStringAsFixed(2)} $currency',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal 
                ? theme.colorScheme.primary 
                : isDeduction 
                  ? theme.colorScheme.error 
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSuggestions(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pricing Suggestions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSuggestionItem(theme, 'Location Data (1-3 months)', '\$50 - \$200'),
            _buildSuggestionItem(theme, 'Health/Fitness Data', '\$30 - \$150'),
            _buildSuggestionItem(theme, 'App Usage Analytics', '\$25 - \$100'),
            _buildSuggestionItem(theme, 'Sensor Data (IoT)', '\$40 - \$180'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tip: Higher quality, larger datasets with samples tend to sell for premium prices.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(ThemeData theme, String dataType, String priceRange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dataType,
            style: theme.textTheme.bodySmall,
          ),
          Text(
            priceRange,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketInsights(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 20,
                  color: theme.colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Market Insights',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInsightItem(theme, 'Average Dataset Price', '\$87.50', Icons.attach_money),
            _buildInsightItem(theme, 'Most Popular Currency', 'USDC (65%)', Icons.currency_exchange),
            _buildInsightItem(theme, 'Datasets with Samples', '+40% sales', Icons.trending_up),
            _buildInsightItem(theme, 'Avg. Time to First Sale', '3.2 days', Icons.schedule),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(ThemeData theme, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCurrencyIcon(String currency) {
    switch (currency) {
      case 'SOL':
        return const Icon(Icons.currency_bitcoin, size: 16);
      case 'USDC':
        return const Icon(Icons.attach_money, size: 16);
      case 'ZDATA':
        return const Icon(Icons.data_usage, size: 16);
      default:
        return const Icon(Icons.monetization_on, size: 16);
    }
  }
}

/// The two repeatable blocks of the storefront and the console.
library;

import 'package:flutter/material.dart';

import '../models/site.dart';
import 'async_view.dart';
import 'formatting.dart';
import 'motion.dart';

/// One product on the storefront, mirroring the legacy `tpls/ware.html`
/// pricing widget: name, discounted cycle price, the list of what is included,
/// and the call to action.
class ProductCardView extends StatelessWidget {
  const ProductCardView({
    super.key,
    required this.card,
    required this.onBuy,
    this.buyLabel = 'Buy',
  });

  final ProductCard card;
  final String buyLabel;

  /// Opens the order flow. The legacy card linked to `/new-order?specID=…`.
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasDiscount = card.discount > 0;
    final displayPrice = hasDiscount
        ? discountedAmount(card.price, card.discount)
        : card.price;
    return HoverCard(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(card.wareName, style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    money(displayPrice),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hasDiscount) ...[
                    Text(
                      money(card.price),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.outline,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    StatusBadge(
                      label: '-${card.discount}%',
                      colour: scheme.tertiary,
                    ),
                  ],
                ],
              ),
              if (card.validDays > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${card.validDays} days',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.outline,
                    ),
                  ),
                ),
              const Divider(height: 24),
              for (final intro in card.intros)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16, color: scheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurface,
                            ),
                            children: [
                              TextSpan(
                                text: introText(
                                  intro.key,
                                  intro.value,
                                  intro.label,
                                ),
                              ),
                              if (intro.hint)
                                TextSpan(
                                  text: '  Email alert',
                                  style: TextStyle(color: scheme.primary),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onBuy, child: Text(buyLabel)),
            ],
          ),
        ),
      ),
    );
  }
}

/// One of the four counters at the top of the console.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.colour,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colour.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colour),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
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
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_exception.dart';
import '../../api/peo_api.dart';
import '../../models/site.dart';
import '../../state/session_cubit.dart';
import '../../state/site_cubit.dart';
import '../../state/storefront_cubit.dart';
import '../../theme/peo_theme.dart';
import '../../widgets/async_view.dart';
import '../../widgets/formatting.dart';
import '../../widgets/cards.dart';
import '../../widgets/responsive.dart';
import '../../widgets/shell.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});
  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (ctx) => StorefrontCubit(ctx.read<PeoApi>())..load(),
    child: const _ShopView(),
  );
}

class _ShopView extends StatefulWidget {
  const _ShopView();

  @override
  State<_ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<_ShopView> {
  String _paymentMethod = 'balance';
  String _billingPeriod = 'monthly';

  @override
  Widget build(BuildContext c) {
    final cubit = c.watch<StorefrontCubit>();
    final site = c.watch<SiteCubit>().config;
    return Scaffold(
      body: AsyncView<Storefront>(
        value: cubit.state,
        onRetry: cubit.load,
        builder: (ctx, data) => LayoutBuilder(
          builder: (ctx, constraints) {
            final pageWidth = math.min(
              constraints.maxWidth,
              PeoBreakpoints.maxContentWidth,
            );
            final horizontalPadding = constraints.maxWidth < 620 ? 16.0 : 32.0;
            final cycles = <_BillingCycle>[
              if (data.monthly.isNotEmpty)
                _BillingCycle('monthly', 'Monthly', data.monthly),
              if (data.quarterly.isNotEmpty)
                _BillingCycle('quarterly', 'Quarterly', data.quarterly),
              if (data.yearly.isNotEmpty)
                _BillingCycle('yearly', 'Yearly', data.yearly),
            ];
            final _BillingCycle? selectedCycle = cycles.isEmpty
                ? null
                : cycles.firstWhere(
                    (cycle) => cycle.id == _billingPeriod,
                    orElse: () => cycles.first,
                  );

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const _StorefrontHero(),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: pageWidth,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        22,
                        horizontalPadding,
                        40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const PageHeader(title: 'Products'),
                          _paymentMethodPicker(site),
                          if (selectedCycle == null) ...[
                            const SizedBox(height: 24),
                            _emptyCatalogue(ctx),
                          ],
                          if (selectedCycle != null) ...[
                            const SizedBox(height: 28),
                            _billingPeriodPicker(cycles, selectedCycle),
                            const SizedBox(height: 20),
                            ..._productGrid(
                              ctx,
                              selectedCycle.cards,
                              totalDiscount: site.totalDiscount,
                              emailNotice: site.emailNotice && data.emailNotice,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _paymentMethodPicker(SiteConfig site) {
    final theme = Theme.of(context);
    final balanceSelected = _paymentMethod == 'balance';
    final detail = balanceSelected
        ? site.alipayEnabled && site.rechargeMode
              ? 'Pay from your account balance. You can top up with Alipay if needed.'
              : 'Pay instantly from your account balance.'
        : 'Use an eligible product key at checkout.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose how to pay', style: theme.textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Your selection will be carried through to checkout.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        SegmentedButton<String>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment<String>(
              value: 'balance',
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: Text('Balance'),
            ),
            ButtonSegment<String>(
              value: 'key',
              icon: Icon(Icons.key_outlined),
              label: Text('Product key'),
            ),
          ],
          selected: {_paymentMethod},
          onSelectionChanged: (selection) =>
              setState(() => _paymentMethod = selection.single),
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  balanceSelected
                      ? Icons.flash_on_outlined
                      : Icons.confirmation_number_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(detail)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _billingPeriodPicker(
    List<_BillingCycle> cycles,
    _BillingCycle selectedCycle,
  ) {
    final theme = Theme.of(context);
    final selectedIndex = cycles.indexWhere(
      (cycle) => cycle.id == selectedCycle.id,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Billing period', style: theme.textTheme.titleMedium),
            ),
            Text(
              '${selectedCycle.cards.length} ${selectedCycle.cards.length == 1 ? 'plan' : 'plans'}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        DefaultTabController(
          key: ValueKey(cycles.map((cycle) => cycle.id).join(',')),
          length: cycles.length,
          initialIndex: selectedIndex,
          child: TabBar(
            isScrollable: true,
            labelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [for (final cycle in cycles) Tab(text: cycle.label)],
            onTap: (index) => setState(() => _billingPeriod = cycles[index].id),
          ),
        ),
      ],
    );
  }

  List<Widget> _productGrid(
    BuildContext c,
    List<ProductCard> cards, {
    required bool totalDiscount,
    required bool emailNotice,
  }) {
    return [
      AdaptiveGrid(
        minTileWidth: 300,
        maxColumns: 3,
        spacing: 16,
        children: [
          for (final card in cards)
            ProductCardView(
              card: card.copyWith(
                discount: totalDiscount ? card.discount : 0,
                intros: [
                  for (final intro in card.intros)
                    intro.copyWith(hint: emailNotice && intro.hint),
                ],
              ),
              buyLabel: _paymentMethod == 'key'
                  ? 'Buy with key'
                  : 'Buy with balance',
              onBuy: () =>
                  c.go('/product/${card.specId}?method=$_paymentMethod'),
            ),
        ],
      ),
    ];
  }

  Widget _emptyCatalogue(BuildContext c) => Card(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 36,
            color: Theme.of(c).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          const Text('No products are available right now.'),
        ],
      ),
    ),
  );
}

class _BillingCycle {
  const _BillingCycle(this.id, this.label, this.cards);

  final String id;
  final String label;
  final List<ProductCard> cards;
}

class _StorefrontHero extends StatelessWidget {
  const _StorefrontHero();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final compact = PeoBreakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MINECRAFT SERVER HOSTING',
          style: textTheme.labelLarge?.copyWith(
            color: PeoTokens.accentPale,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: PeoTokens.space3),
        Text(
          'Find the right plan for your world',
          style: textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: PeoTokens.space2),
        Text(
          'Compare resources and choose a billing period that works for you.',
          style: textTheme.bodyLarge?.copyWith(color: const Color(0xFFDCE8FA)),
        ),
      ],
    );
    final mark = Container(
      width: compact ? 64 : 112,
      height: compact ? 64 : 112,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(PeoTokens.radiusLarge),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Icon(
        Icons.sports_esports_rounded,
        size: compact ? 34 : 58,
        color: Colors.white,
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: ClipPath(
        clipper: _StorefrontHeroClipper(compact: compact),
        child: Container(
          constraints: BoxConstraints(minHeight: compact ? 336 : 316),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                PeoTokens.navBackground,
                Color(0xFF173A72),
                Color(0xFF155A9E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 0.56, 1],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: compact ? -170 : -70,
                top: compact ? -185 : -220,
                child: IgnorePointer(
                  child: Container(
                    width: compact ? 390 : 540,
                    height: compact ? 390 : 540,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          PeoTokens.accent.withValues(alpha: 0.32),
                          PeoTokens.accentAlt.withValues(alpha: 0.12),
                          Colors.transparent,
                        ],
                        stops: const [0, 0.48, 1],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: PeoBreakpoints.maxContentWidth,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      compact ? 24 : 48,
                      compact ? 34 : 48,
                      compact ? 24 : 48,
                      compact ? 88 : 104,
                    ),
                    child: compact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              copy,
                              const SizedBox(height: 22),
                              Align(
                                alignment: Alignment.centerRight,
                                child: mark,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: copy),
                              const SizedBox(width: PeoTokens.space6),
                              mark,
                              const SizedBox(width: PeoTokens.space6),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StorefrontHeroClipper extends CustomClipper<Path> {
  const _StorefrontHeroClipper({required this.compact});

  final bool compact;

  @override
  Path getClip(Size size) {
    final depth = compact ? 32.0 : 68.0;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - depth * 0.62)
      ..cubicTo(
        size.width * 0.8,
        size.height - depth * 0.08,
        size.width * 0.68,
        size.height - depth * 1.18,
        size.width * 0.5,
        size.height - depth * 0.34,
      )
      ..cubicTo(
        size.width * 0.32,
        size.height - depth * 0.05,
        size.width * 0.14,
        size.height - depth * 0.92,
        0,
        size.height - depth * 0.6,
      )
      ..close();
  }

  @override
  bool shouldReclip(_StorefrontHeroClipper oldClipper) =>
      compact != oldClipper.compact;
}

class ProductPage extends StatelessWidget {
  const ProductPage({
    super.key,
    required this.specId,
    this.paymentMethod = 'balance',
  });

  final String specId;

  /// The storefront choice to emphasize after the order is created.
  final String paymentMethod;

  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (ctx) => ProductDetailCubit(ctx.read<PeoApi>(), specId)..load(),
    child: _ProductView(paymentMethod: paymentMethod),
  );
}

class _ProductView extends StatefulWidget {
  const _ProductView({required this.paymentMethod});

  final String paymentMethod;

  @override
  State<_ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<_ProductView> {
  bool _creatingOrder = false;
  String? _error;

  Future<void> _buy(ProductDetail data) async {
    final session = context.read<SessionCubit>();
    if (!session.state.isSignedIn) {
      context.go('/login');
      return;
    }
    setState(() {
      _creatingOrder = true;
      _error = null;
    });
    try {
      final order = await context.read<PeoApi>().createOrder(
        data.product.specId,
      );
      if (mounted) {
        context.go('/orders/${order.id}?method=${widget.paymentMethod}');
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _creatingOrder = false);
    }
  }

  @override
  Widget build(BuildContext c) {
    final cubit = c.watch<ProductDetailCubit>();
    final site = c.watch<SiteCubit>().config;
    return Scaffold(
      body: AsyncView<ProductDetail>(
        value: cubit.state,
        onRetry: cubit.load,
        builder: (ctx, data) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PageHeader(
              title: data.product.wareName,
              subtitle: 'Price: ${money(data.pricing.finalPrice)}',
            ),
            if (site.totalDiscount &&
                data.pricing.originPrice != data.pricing.finalPrice)
              Text('List price: ${money(data.pricing.originPrice)}'),
            if (site.emailNotice)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'We will email you before an idle server is removed.',
                ),
              ),
            Text('${data.product.validDays} days'),
            if (data.nestName.isNotEmpty) Text('Node: ${data.nestName}'),
            if (data.eggName.isNotEmpty) Text('Template: ${data.eggName}'),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Text(
                _error!,
                style: TextStyle(color: Theme.of(ctx).colorScheme.error),
              ),
              const SizedBox(height: 12),
            ],
            FilledButton(
              onPressed: _creatingOrder ? null : () => _buy(data),
              child: Text(
                _creatingOrder
                    ? 'Creating order…'
                    : widget.paymentMethod == 'key'
                    ? 'Continue with product key'
                    : 'Continue with balance',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

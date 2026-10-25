import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/peo_api.dart';
import '../../models/admin.dart' as admin;
import '../../models/content.dart';
import '../../models/documents.dart';
import '../../models/site.dart';
import '../../state/admin_cubits.dart';
import '../../state/async_value.dart';
import '../../theme/peo_theme.dart';
import '../../widgets/async_view.dart';
import '../../widgets/browser.dart';
import '../../widgets/formatting.dart';
import '../../widgets/responsive.dart';
import '../../widgets/shell.dart';

class _AdminFrame extends StatelessWidget {
  const _AdminFrame({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      ResponsivePage(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(title: title),
            ...children,
          ],
        ),
      ),
    ],
  );
}

class _AdminLinks extends StatelessWidget {
  const _AdminLinks();
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final entry in const [
        ('Dashboard', '/admin'),
        ('Users', '/admin/users'),
        ('Orders', '/admin/orders'),
        ('Products', '/admin/products'),
        ('Keys', '/admin/keys'),
        ('Gallery review', '/admin/gallery'),
        ('Work orders', '/admin/work-orders'),
        ('Settings', '/admin/settings'),
      ])
        OutlinedButton(
          onPressed: () => context.go(entry.$2),
          child: Text(entry.$1),
        ),
    ],
  );
}

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => DashboardCubit(context.read<PeoApi>())..load(),
    child: const _AdminDashboardView(),
  );
}

class _AdminDashboardView extends StatelessWidget {
  const _AdminDashboardView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DashboardCubit>();
    return _AdminFrame(
      title: 'Administration',
      children: [
        const _AdminLinks(),
        const SizedBox(height: 20),
        AsyncView<admin.Dashboard>(
          value: cubit.state.value,
          onRetry: cubit.load,
          builder: (context, data) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    'Products',
                    data.specAmount,
                    route: '/admin/products',
                  ),
                  _StatCard('Servers', data.entityAmount),
                  _StatCard('Users', data.userAmount, route: '/admin/users'),
                  _StatCard('Keys', data.keyAmount, route: '/admin/keys'),
                  _StatCard(
                    'Orders',
                    data.orderAmount,
                    route: '/admin/orders',
                  ),
                  _StatCard(
                    'Open tickets',
                    data.workOrderCount,
                    route: '/admin/work-orders',
                  ),
                  _StatCard(
                    'Gallery items',
                    data.galleryCount,
                    route: '/admin/gallery',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SectionCard(
                title: 'Servers awaiting deletion',
                child: data.deleteConfirms.isEmpty
                    ? const EmptyPanel(message: 'No pending server deletions')
                    : Column(
                        children: [
                          for (final item in data.deleteConfirms)
                            ListTile(
                              title: Text(item.serverName),
                              subtitle: Text(
                                '${item.owner} · ${item.hostName} · expires ${item.expire}',
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    tooltip: 'Open panel server',
                                    onPressed: cubit.state.action.busy
                                        ? null
                                        : () => openExternal(item.consoleUrl),
                                    icon: const Icon(Icons.open_in_new),
                                  ),
                                  IconButton(
                                    tooltip: 'Cancel deletion',
                                    onPressed: cubit.state.action.busy
                                        ? null
                                        : () => cubit.resolveDeleteConfirm(
                                            item.entityId,
                                            false,
                                          ),
                                    icon: const Icon(Icons.undo),
                                  ),
                                  IconButton(
                                    tooltip: 'Confirm deletion',
                                    onPressed: cubit.state.action.busy
                                        ? null
                                        : () => _confirm(
                                            context,
                                            'Delete ${item.serverName}?',
                                            () => cubit.resolveDeleteConfirm(
                                              item.entityId,
                                              true,
                                            ),
                                          ),
                                    icon: const Icon(Icons.delete_forever),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
              SectionCard(
                title: 'Gallery submissions awaiting review',
                child: data.galleryItems.where((e) => !e.reviewPassed).isEmpty
                    ? const EmptyPanel(
                        message: 'No gallery submissions to review',
                      )
                    : Column(
                        children: [
                          for (final item in data.galleryItems.where(
                            (e) => !e.reviewPassed,
                          ))
                            ListTile(
                              title: Text(item.itemName),
                              subtitle: Text(
                                '${item.userName} · ${item.itemDescription}',
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    tooltip: 'Approve submission',
                                    onPressed: cubit.state.action.busy
                                        ? null
                                        : () => cubit.reviewGallery(
                                            item.id,
                                            approve: true,
                                          ),
                                    icon: const Icon(Icons.check),
                                  ),
                                  IconButton(
                                    tooltip: 'Reject submission',
                                    onPressed: cubit.state.action.busy
                                        ? null
                                        : () => _confirm(
                                            context,
                                            'Delete ${item.itemName}?',
                                            () => cubit.reviewGallery(
                                              item.id,
                                              approve: false,
                                            ),
                                          ),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
              ),
              SectionCard(
                title: 'Open work orders',
                child: cubit.openWorkOrders.isEmpty
                    ? const EmptyPanel(message: 'No open work orders')
                    : Column(
                        children: [
                          for (final ticket in cubit.openWorkOrders)
                            ListTile(
                              title: Text(ticket.orderTitle),
                              subtitle: Text(
                                '${ticket.userName} · ${ticket.orderText}',
                              ),
                              trailing: IconButton(
                                tooltip: 'Close work order',
                                onPressed: cubit.state.action.busy
                                    ? null
                                    : () =>
                                          _closeTicket(context, cubit, ticket),
                                icon: const Icon(Icons.done),
                              ),
                            ),
                        ],
                      ),
              ),
              ActionFeedback(action: cubit.state.action),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _closeTicket(
    BuildContext context,
    DashboardCubit cubit,
    WorkOrderItem ticket,
  ) async {
    final reply = await _textDialog(
      context,
      'Close ${ticket.orderTitle}',
      'Optional reply to the customer',
    );
    if (reply != null && context.mounted) {
      await cubit.closeWorkOrder(ticket.id, reply);
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.label, this.value, {this.route});

  final String label;
  final int value;
  final String? route;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 180,
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: route == null ? null : () => context.go(route!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('$value', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<bool> _confirm(
  BuildContext context,
  String prompt,
  Future<ActionState> Function() action,
) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Please confirm'),
      content: Text(prompt),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
  if (ok == true && context.mounted) await action();
  return ok == true;
}

Future<String?> _textDialog(
  BuildContext context,
  String title,
  String hint,
) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: hint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Close ticket'),
        ),
      ],
    ),
  );
  controller.dispose();
  return result;
}

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => AdminUsersCubit(context.read<PeoApi>())..load(),
    child: const _AdminUsersView(),
  );
}

class _AdminUsersView extends StatelessWidget {
  const _AdminUsersView();
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminUsersCubit>();
    return _AdminFrame(
      title: 'Users',
      children: [
        const _AdminLinks(),
        const SizedBox(height: 16),
        AsyncView<List<admin.AdminUser>>(
          value: cubit.state.items,
          onRetry: cubit.load,
          empty: const EmptyPanel(message: 'No users found'),
          builder: (context, users) => Column(
            children: [
              for (final user in users)
                Card(
                  child: ListTile(
                    title: Text(
                      '${user.name} ${user.isAdmin ? '· Administrator' : ''}',
                    ),
                    subtitle: Text(
                      '${user.email}\nBalance ${money(user.balance)} · ${user.emailConfirmed ? 'email confirmed' : 'email unconfirmed'} · ${user.pteUserCreated ? 'panel linked' : 'no panel account'} · ${user.createdAt} · ${uptime(user.totalUpTime)} uptime',
                      maxLines: 3,
                    ),
                    isThreeLine: true,
                    trailing: Icon(
                      user.emailConfirmed ? Icons.verified : Icons.mail_outline,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => AdminOrdersCubit(context.read<PeoApi>())..load(),
    child: const _AdminOrdersView(),
  );
}

class _AdminOrdersView extends StatelessWidget {
  const _AdminOrdersView();
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminOrdersCubit>();
    return _AdminFrame(
      title: 'Orders',
      children: [
        const _AdminLinks(),
        const SizedBox(height: 16),
        AsyncView<List<admin.AdminOrder>>(
          value: cubit.state.items,
          onRetry: cubit.load,
          empty: const EmptyPanel(message: 'No completed orders'),
          builder: (context, orders) => Column(
            children: [
              for (final order in orders)
                Card(
                  child: ListTile(
                    title: Text(order.specName),
                    subtitle: Text(
                      '${order.userName} · ${order.specDays} days · ${order.createdAt}',
                    ),
                    trailing: Text(money(order.finalPrice)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => AdminProductsCubit(context.read<PeoApi>())..load(),
    child: const _AdminProductsView(),
  );
}

class _AdminProductsView extends StatelessWidget {
  const _AdminProductsView();
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminProductsCubit>();
    return _AdminFrame(
      title: 'Products',
      children: [
        const _AdminLinks(),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () => context.go('/admin/products/new'),
            icon: const Icon(Icons.add),
            label: const Text('Create product'),
          ),
        ),
        const SizedBox(height: 12),
        AsyncView<List<admin.AdminProduct>>(
          value: cubit.state.products,
          onRetry: cubit.load,
          empty: const EmptyPanel(message: 'No products found'),
          builder: (context, products) => Column(
            children: [
              for (final product in products)
                Card(
                  child: ListTile(
                    title: Text(
                      '${product.wareName} · ${product.validDays} days',
                    ),
                    subtitle: Text(
                      '${product.wareDescription}\n${money(product.pricePerMonth)} / 30 days · discount ${product.discount}% · ${product.memory} MB RAM · ${product.cpu}% CPU · ${product.disk} MB disk · ${product.backups} backups · node ${product.node} · Tag ${product.tagSlug.isEmpty ? 'unmapped' : product.tagSlug} · legacy Nest ${product.nest}, Egg ${product.egg} · reinstall Eggs ${product.allowedEggIds.join(', ')}',
                      maxLines: 3,
                    ),
                    isThreeLine: true,
                    trailing: Wrap(
                      children: [
                        IconButton(
                          tooltip: 'Edit product',
                          onPressed: () => context.go(
                            '/admin/products/${product.specId}/edit',
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          tooltip: 'Delete product',
                          onPressed: cubit.state.action.busy
                              ? null
                              : () => _confirm(
                                  context,
                                  'Delete ${product.wareName}?',
                                  () => cubit.delete(product.specId),
                                ),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                ),
              ActionFeedback(action: cubit.state.action),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminProductEditorPage extends StatelessWidget {
  const AdminProductEditorPage({super.key, this.specId});
  final String? specId;
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) =>
        AdminProductsCubit(context.read<PeoApi>())..loadEditor(),
    child: _AdminProductEditorView(specId: specId),
  );
}

class _AdminProductEditorView extends StatefulWidget {
  const _AdminProductEditorView({this.specId});
  final String? specId;
  @override
  State<_AdminProductEditorView> createState() =>
      _AdminProductEditorViewState();
}

class _AdminProductEditorViewState extends State<_AdminProductEditorView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _seeded = false;
  String? _tagSlug;
  int? _eggId;
  Set<int> _allowedEggIds = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _seed(AdminProductsCubit cubit) {
    if (_seeded || !cubit.state.fields.hasValue || !cubit.state.raw.hasValue) {
      return;
    }
    final spec = widget.specId == null ? null : cubit.specOf(widget.specId!);
    final defaults = <String, Object?>{};
    for (final field in cubit.state.fields.value!) {
      defaults[field.name] = field.defaultValue;
    }
    if (spec != null) {
      defaults.addAll({
        'ware_name': spec.wareName,
        'ware_description': spec.wareDescription,
        'cpu': spec.cpu,
        'disk': spec.disk,
        'memory': spec.memory,
        'swap': spec.swap,
        'io': spec.io,
        'backups': spec.backups,
        'node_id': spec.node,
        'nest_id': spec.nest,
        'image': spec.dockerImage,
        'delete_time': Duration(microseconds: spec.deleteDuration ~/ 1000)
            .inDays,
        'price': spec.pricePerMonth,
        'discount0': spec.discount,
        'discount1': spec.discount,
        'discount2': spec.discount,
      });
      if (spec.tagSlug.isNotEmpty) {
        _tagSlug = spec.tagSlug;
        _eggId = spec.egg;
        _allowedEggIds = spec.allowedEggIds.toSet();
        unawaited(cubit.loadTagEggs(spec.tagSlug));
      }
    }
    for (final field in cubit.state.fields.value!) {
      _controllers[field.name] = TextEditingController(
        text: '${defaults[field.name] ?? ''}',
      );
    }
    _seeded = true;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminProductsCubit>();
    _seed(cubit);
    return _AdminFrame(
      title: widget.specId == null ? 'Create product' : 'Edit product',
      children: [
        const _AdminLinks(),
        AsyncView<List<admin.FormField>>(
          value: cubit.state.fields,
          onRetry: cubit.loadEditor,
          builder: (context, fields) {
            if (!cubit.state.raw.hasValue) {
              return AsyncView<List<WareSpec>>(
                value: cubit.state.raw,
                onRetry: cubit.loadEditor,
                builder: (context, _) => const SizedBox.shrink(),
              );
            }
            if (widget.specId != null && cubit.specOf(widget.specId!) == null) {
              return const EmptyPanel(message: 'Product not found');
            }
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.specId != null &&
                      cubit.specOf(widget.specId!)!.nest > 0)
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Legacy Nest ID',
                        helperText: 'Retained for migration; choose a Tag below to save this product.',
                      ),
                      child: Text('${cubit.specOf(widget.specId!)!.nest}'),
                    ),
                  _tagPicker(cubit),
                  for (final field in fields.where(
                    (field) =>
                        field.name != 'nest_id' &&
                        field.name != 'egg_id' &&
                        field.name != 'tag_slug',
                  ))
                    _field(field),
                  ActionFeedback(action: cubit.state.action),
                  FilledButton(
                    onPressed: cubit.state.action.busy
                        ? null
                        : () => _save(cubit, fields),
                    child: Text(
                      cubit.state.action.busy ? 'Saving…' : 'Save product',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _field(admin.FormField field) {
    final controller = _controllers[field.name];
    if (controller == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: field.type == 'number'
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: field.label,
          helperText: field.description,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          final input = value?.trim() ?? '';
          if (field.required && input.isEmpty) return 'Required';
          if (input.isNotEmpty &&
              field.type == 'number' &&
              int.tryParse(input) == null) {
            return 'Enter a whole number';
          }
          return null;
        },
      ),
    );
  }

  Widget _tagPicker(AdminProductsCubit cubit) {
    final tags = cubit.state.tags.value ?? const <admin.PanelTag>[];
    final selectedTag = tags.any((tag) => tag.slug == _tagSlug)
        ? _tagSlug
        : null;
    final eggs = cubit.state.tagEggs.value ?? const <Egg>[];
    final selectedEgg = eggs.any((egg) => egg.id == _eggId) ? _eggId : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedTag,
          decoration: const InputDecoration(
            labelText: 'Panel Tag',
            helperText: 'Choose the template category for this product.',
          ),
          items: [
            for (final tag in tags)
              DropdownMenuItem(
                value: tag.slug,
                child: Text(
                  '${tag.name} · ${tag.slug}${tag.legacyNestId == null ? '' : ' · legacy Nest ${tag.legacyNestId}'}',
                ),
              ),
          ],
          onChanged: (slug) {
            setState(() {
              _tagSlug = slug;
              _eggId = null;
              _allowedEggIds = {};
            });
            unawaited(cubit.loadTagEggs(slug ?? ''));
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Choose a Tag' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: selectedEgg,
          decoration: InputDecoration(
            labelText: 'Egg template',
            helperText: cubit.state.tagEggs.isLoading
                ? 'Loading Egg templates…'
                : 'Only Eggs in the selected Tag are available.',
          ),
          items: [
            for (final egg in eggs)
              DropdownMenuItem(value: egg.id, child: Text(egg.name)),
          ],
          onChanged: (eggId) => setState(() => _eggId = eggId),
          validator: (value) => value == null ? 'Choose an Egg template' : null,
        ),
        if (selectedEgg != null) ...[
          const SizedBox(height: 8),
          Text(
            'Eggs allowed for reinstall',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final egg in eggs)
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(egg.name),
              value: egg.id == selectedEgg || _allowedEggIds.contains(egg.id),
              onChanged: egg.id == selectedEgg
                  ? null
                  : (enabled) => setState(() {
                      if (enabled == true) {
                        _allowedEggIds.add(egg.id);
                      } else {
                        _allowedEggIds.remove(egg.id);
                      }
                    }),
            ),
        ],
        if (cubit.state.tags.hasFailed)
          TextButton.icon(
            onPressed: cubit.loadEditor,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry loading Panel Tags'),
          ),
        if (_tagSlug == null && widget.specId != null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'This legacy product has no unique Tag mapping. Select its Tag and Egg before saving.',
            ),
          ),
      ],
    );
  }

  Future<void> _save(
    AdminProductsCubit cubit,
    List<admin.FormField> fields,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    final raw = <String, dynamic>{};
    for (final field in fields) {
      if (field.name == 'nest_id' || field.name == 'egg_id') continue;
      final key = switch (field.name) {
        'ware_name' => 'wareName',
        'ware_description' => 'wareDescription',
        'node_id' => 'nodeId',
        'nest_id' => 'nestId',
        'egg_id' => 'eggId',
        'delete_time' => 'deleteTime',
        _ => field.name,
      };
      final value = _controllers[field.name]!.text.trim();
      raw[key] = field.type == 'number' ? int.parse(value) : value;
    }
    raw['tagSlug'] = _tagSlug ?? '';
    raw['eggId'] = _eggId ?? 0;
    raw['allowedEggIds'] = {..._allowedEggIds, ?_eggId}.toList();
    if (widget.specId != null) {
      raw['nestId'] = cubit.specOf(widget.specId!)?.nest ?? 0;
    }
    if (widget.specId != null) raw['discount'] = raw.remove('discount0') ?? 0;
    final input = admin.ProductInput.fromJson(raw);
    final result = widget.specId == null
        ? await cubit.create(input)
        : await cubit.update(widget.specId!, input);
    if (result.succeeded && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Product saved')),
      );
      context.go('/admin/products');
    }
  }
}

class AdminKeysPage extends StatelessWidget {
  const AdminKeysPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => AdminKeysCubit(context.read<PeoApi>())..load(),
    child: const _AdminKeysView(),
  );
}

class _AdminKeysView extends StatefulWidget {
  const _AdminKeysView();
  @override
  State<_AdminKeysView> createState() => _AdminKeysViewState();
}

class _AdminKeysViewState extends State<_AdminKeysView> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController(text: '1');
  final _days = TextEditingController(text: '1');
  String? _target;
  @override
  void dispose() {
    _amount.dispose();
    _days.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminKeysCubit>();
    return _AdminFrame(
      title: 'Activation keys',
      children: [
        const _AdminLinks(),
        const SizedBox(height: 16),
        AsyncView<List<admin.KeyTarget>>(
          value: cubit.state.targets,
          onRetry: cubit.load,
          builder: (context, targets) {
            final selected = targets.any((item) => item.target == _target)
                ? _target
                : null;
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selected,
                    decoration: const InputDecoration(
                      labelText: 'Key target',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final item in targets)
                        DropdownMenuItem(
                          value: item.target,
                          child: Text(
                            '${item.name} · ${item.description} · ${switch (item.validity) {
                              0 => 'balance key',
                              -1 => 'all product cycles',
                              _ => '${item.validity} days',
                            }}',
                          ),
                        ),
                    ],
                    onChanged: (value) => setState(() => _target = value),
                    validator: (value) =>
                        value == null ? 'Choose a target' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Number of keys (1–99)',
                      border: OutlineInputBorder(),
                    ),
                    validator: _positiveInt,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _days,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Key validity in days',
                      border: OutlineInputBorder(),
                    ),
                    validator: _positiveInt,
                  ),
                  const SizedBox(height: 12),
                  ActionFeedback(action: cubit.state.action),
                  FilledButton.icon(
                    onPressed: cubit.state.action.busy
                        ? null
                        : () => _generate(context, cubit),
                    icon: const Icon(Icons.download),
                    label: Text(
                      cubit.state.action.busy
                          ? 'Generating…'
                          : 'Generate and download ZIP',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String? _positiveInt(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null || parsed < 1) return 'Enter a positive whole number';
    if (parsed >= 100) return 'Enter a number less than 100';
    return null;
  }

  Future<void> _generate(BuildContext context, AdminKeysCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;
    final bytes = await cubit.generate(
      admin.GenerateKeysRequest(
        target: _target!,
        amount: int.parse(_amount.text),
        validityDays: int.parse(_days.text),
      ),
    );
    if (bytes != null && context.mounted) {
      saveBytes(bytes, 'peo-keys.zip');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cubit.state.action.message ?? 'Keys downloaded'),
        ),
      );
    }
  }
}

class AdminGalleryPage extends StatelessWidget {
  const AdminGalleryPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => DashboardCubit(context.read<PeoApi>())..load(),
    child: const _AdminGalleryView(),
  );
}

class _AdminGalleryView extends StatelessWidget {
  const _AdminGalleryView();
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DashboardCubit>();
    return _AdminFrame(
      title: 'Gallery moderation',
      children: [
        const _AdminLinks(),
        const SizedBox(height: 12),
        AsyncView<admin.Dashboard>(
          value: cubit.state.value,
          onRetry: cubit.load,
          builder: (context, data) {
            final pending = data.galleryItems
                .where((item) => !item.reviewPassed)
                .toList();
            if (pending.isEmpty) {
              return const EmptyPanel(
                message: 'No gallery submissions to review',
              );
            }
            return Column(
              children: [
                for (final item in pending)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text('${item.userName} · ${item.createdAt}'),
                          if (item.itemDescription.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(item.itemDescription),
                            ),
                          if (item.imgSource.isNotEmpty)
                            Image.network(
                              item.imgSource,
                              height: 240,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) =>
                                  const Text('Image unavailable'),
                            ),
                          Wrap(
                            spacing: 8,
                            children: [
                              FilledButton.icon(
                                onPressed: cubit.state.action.busy
                                    ? null
                                    : () => cubit.reviewGallery(
                                        item.id,
                                        approve: true,
                                      ),
                                icon: const Icon(Icons.check),
                                label: const Text('Approve'),
                              ),
                              OutlinedButton.icon(
                                onPressed: cubit.state.action.busy
                                    ? null
                                    : () => _confirm(
                                        context,
                                        'Delete ${item.itemName}?',
                                        () => cubit.reviewGallery(
                                          item.id,
                                          approve: false,
                                        ),
                                      ),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Reject and delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ActionFeedback(action: cubit.state.action),
              ],
            );
          },
        ),
      ],
    );
  }
}

class AdminWorkOrdersPage extends StatelessWidget {
  const AdminWorkOrdersPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => AdminWorkOrdersCubit(context.read<PeoApi>())..load(),
    child: const _AdminWorkOrdersView(),
  );
}

class _AdminWorkOrdersView extends StatelessWidget {
  const _AdminWorkOrdersView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminWorkOrdersCubit>();
    return _AdminFrame(
      title: 'Work orders',
      children: [
        const _AdminLinks(),
        const SizedBox(height: 12),
        AsyncView<List<WorkOrderItem>>(
          value: cubit.state.items,
          onRetry: cubit.load,
          empty: const EmptyPanel(message: 'No work orders'),
          builder: (context, orders) => Column(
            children: [
              for (final ticket in orders)
                Card(
                  child: ListTile(
                    title: Text(ticket.orderTitle),
                    subtitle: Text(
                      '${ticket.userName} · ${ticket.createdAt}\n${ticket.orderText}',
                      maxLines: 4,
                    ),
                    isThreeLine: true,
                    trailing: ticket.closed
                        ? const Chip(label: Text('Closed'))
                        : IconButton(
                            tooltip: 'Close ticket',
                            icon: const Icon(Icons.done),
                            onPressed: cubit.state.action.busy
                                ? null
                                : () async {
                                    final reply = await _textDialog(
                                      context,
                                      'Close ${ticket.orderTitle}',
                                      'Optional reply to the customer',
                                    );
                                    if (reply != null && context.mounted) {
                                      await cubit.closeTicket(ticket.id, reply);
                                    }
                                  },
                          ),
                  ),
                ),
              ActionFeedback(action: cubit.state.action),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AdminSettingsCubit(context.read<PeoApi>())..load(),
      ),
      BlocProvider(
        create: (context) => AdminHealthCubit(context.read<PeoApi>())..load(),
      ),
    ],
    child: const _AdminSettingsView(),
  );
}

class _AdminSettingsView extends StatefulWidget {
  const _AdminSettingsView();

  @override
  State<_AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<_AdminSettingsView> {
  final Map<String, TextEditingController> _controllers = {};
  bool _syncScheduled = false;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(AdminSettingsCubit settings) {
    final fields = settings.state.fields.value;
    if (fields == null) return;

    final fieldKeys = fields.map((field) => field.key).toSet();
    for (final key in _controllers.keys.toList()) {
      if (!fieldKeys.contains(key)) {
        _controllers.remove(key)?.dispose();
      }
    }

    for (final field in fields) {
      final value = settings.state.valueOf(field);
      _controllers.putIfAbsent(
        field.key,
        () => TextEditingController(text: value),
      );
    }

    if (settings.state.edits.isEmpty &&
        fields.any(
          (field) =>
              _controllers[field.key]?.text != settings.state.valueOf(field),
        ) &&
        !_syncScheduled) {
      _syncScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncScheduled = false;
        if (!mounted || settings.state.edits.isNotEmpty) return;
        for (final field in settings.state.fields.value ?? const []) {
          final value = settings.state.valueOf(field);
          final controller = _controllers[field.key];
          if (controller == null || controller.text == value) continue;
          controller.value = TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(offset: value.length),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AdminSettingsCubit>();
    final health = context.watch<AdminHealthCubit>();
    _syncControllers(settings);
    return _AdminFrame(
      title: 'Settings and diagnostics',
      children: [
        const _AdminLinks(),
        const SizedBox(height: 12),
        AsyncView<admin.Health>(
          value: health.state,
          onRetry: health.load,
          builder: (context, value) => SectionCard(
            title: 'Service health',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _healthRow('MongoDB', value.mongo),
                _healthRow('Redis', value.redis),
                _healthRow('Pterodactyl', value.pterodactyl),
                const Divider(),
                Text(
                  'Version ${value.version} · ${value.goVersion} · built ${value.buildTime}',
                ),
              ],
            ),
          ),
        ),
        AsyncView<List<admin.SettingField>>(
          value: settings.state.fields,
          onRetry: settings.load,
          empty: const EmptyPanel(message: 'No settings are available'),
          builder: (context, fields) => Column(
            children: [
              for (final field in fields)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      switch (field.type) {
                        'bool' => SwitchListTile(
                          title: Text(field.label),
                          subtitle: Text(field.description),
                          value:
                              settings.state.valueOf(field).toLowerCase() ==
                              'true',
                          onChanged: (value) =>
                              settings.edit(field.key, '$value'),
                        ),
                        'number' => TextFormField(
                          controller: _controllers[field.key],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: field.label,
                            helperText: field.description,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) => settings.edit(field.key, value),
                        ),
                        _ => TextFormField(
                          controller: _controllers[field.key],
                          obscureText: field.secret,
                          decoration: InputDecoration(
                            labelText: field.label,
                            helperText: field.secret && field.configured
                                ? 'Configured. Leave blank to keep the current value.'
                                : field.description,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) => settings.edit(field.key, value),
                        ),
                      },
                      if (field.key == 'PterodactylHostname')
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => openExternal(
                              _controllers[field.key]!.text.trim(),
                            ),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Open Panel sign-in'),
                          ),
                        ),
                    ],
                  ),
                ),
              ActionFeedback(action: settings.state.action),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton(
                    onPressed:
                        settings.state.action.busy || !settings.state.isDirty
                        ? null
                        : settings.save,
                    child: const Text('Save settings'),
                  ),
                  OutlinedButton(
                    onPressed: settings.state.isDirty ? settings.discard : null,
                    child: const Text('Discard changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _healthRow(String name, admin.ComponentStatus component) => ListTile(
    dense: true,
    leading: Icon(
      component.ok ? Icons.check_circle : Icons.error,
      color: component.ok ? PeoTokens.success : PeoTokens.danger,
    ),
    title: Text(name),
    subtitle: Text(component.message),
  );
}

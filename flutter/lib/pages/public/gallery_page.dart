import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/peo_api.dart';
import '../../models/content.dart';
import '../../state/gallery_cubit.dart';
import '../../state/session_cubit.dart';
import '../../theme/peo_theme.dart';
import '../../widgets/async_view.dart';
import '../../widgets/shell.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => GalleryCubit(context.read<PeoApi>())..load(),
    child: const _GalleryView(),
  );
}

class _GalleryView extends StatelessWidget {
  const _GalleryView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GalleryCubit>();
    final signedIn = context.watch<SessionCubit>().state.isSignedIn;
    final mine = cubit.mine;

    return Scaffold(
      body: AsyncView<List<GalleryCard>>(
        value: cubit.state.items,
        onRetry: cubit.load,
        builder: (context, items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const PageHeader(title: 'Gallery'),
            if (signedIn) ...[
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Public album'),
                    icon: Icon(Icons.photo_library_outlined),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('My submissions'),
                    icon: Icon(Icons.person_outline),
                  ),
                ],
                selected: {mine},
                onSelectionChanged: (selection) =>
                    cubit.load(mine: selection.single),
              ),
              const SizedBox(height: 16),
              const _GallerySubmissionForm(),
              const SizedBox(height: 8),
              ActionFeedback(action: cubit.state.action),
            ],
            if (items.isEmpty)
              EmptyPanel(
                message: mine
                    ? 'You have not submitted any pictures yet.'
                    : 'The album is empty.',
                icon: Icons.photo_library_outlined,
              )
            else
              ...items.map(
                (item) =>
                    _GalleryCard(item: item, mine: mine, canAct: signedIn),
              ),
          ],
        ),
      ),
    );
  }
}

class _GallerySubmissionForm extends StatefulWidget {
  const _GallerySubmissionForm();

  @override
  State<_GallerySubmissionForm> createState() => _GallerySubmissionFormState();
}

class _GallerySubmissionFormState extends State<_GallerySubmissionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GalleryCubit>();

    return SectionCard(
      title: 'Share a picture',
      icon: Icons.add_photo_alternate_outlined,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Picture name'),
              textInputAction: TextInputAction.next,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a picture name.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter an image URL.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: SubmitButton(
                label: 'Submit for review',
                icon: Icons.upload_outlined,
                busy: cubit.state.action.busy,
                onPressed: cubit.state.action.busy ? null : _submit,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.read<SessionCubit>().state.isAdmin
                  ? 'Your picture will be published immediately.'
                  : 'Your picture will be visible after an administrator approves it.',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<GalleryCubit>();
    final wasShowingMine = cubit.mine;
    final result = await cubit.submit(
      GallerySubmitRequest(
        itemName: _nameController.text.trim(),
        itemDescription: _descriptionController.text.trim(),
        imgSource: _imageController.text.trim(),
      ),
    );
    if (result.succeeded) {
      _nameController.clear();
      _descriptionController.clear();
      _imageController.clear();
      if (!wasShowingMine) await cubit.load(mine: true);
    }
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({
    required this.item,
    required this.mine,
    required this.canAct,
  });

  final GalleryCard item;
  final bool mine;
  final bool canAct;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GalleryCubit>();
    final busy = context.watch<GalleryCubit>().state.action.busy;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: InkWell(
              onTap: () => _showImage(context),
              child: Image.network(
                item.imgSource,
                fit: BoxFit.cover,
                semanticLabel: item.itemName,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image_outlined, size: 48),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (mine && !item.reviewPassed)
                      const StatusBadge(
                        label: 'Pending review',
                        colour: PeoTokens.warning,
                      ),
                    if (mine)
                      IconButton(
                        tooltip: 'Delete submission',
                        onPressed: busy ? null : () => _delete(context, cubit),
                        icon: const Icon(Icons.delete_outline),
                      ),
                  ],
                ),
                if (item.itemDescription.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(item.itemDescription),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (item.userName.isNotEmpty) Text('By ${item.userName}'),
                    if (item.createdAt.isNotEmpty) Text(item.createdAt),
                    if (!mine || item.reviewPassed)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 18,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 4),
                          Text('${item.likes} likes'),
                          if (canAct && item.reviewPassed) ...[
                            const SizedBox(width: 4),
                            TextButton.icon(
                              onPressed: () => cubit.like(item.id),
                              icon: const Icon(
                                Icons.thumb_up_outlined,
                                size: 18,
                              ),
                              label: const Text('Like'),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImage(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: Image.network(
            item.imgSource,
            semanticLabel: item.itemName,
            errorBuilder: (context, error, stackTrace) => const Padding(
              padding: EdgeInsets.all(32),
              child: Icon(Icons.broken_image_outlined, size: 48),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, GalleryCubit cubit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete picture?'),
        content: Text('“${item.itemName}” will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) await cubit.delete(item.id);
  }
}

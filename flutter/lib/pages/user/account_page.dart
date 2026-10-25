import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/peo_api.dart';
import '../../models/auth.dart';
import '../../state/account_cubit.dart';
import '../../widgets/async_view.dart';
import '../../widgets/shell.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (ctx) => AccountCubit(ctx.read<PeoApi>()),
    child: const _AccountView(),
  );
}

class _AccountView extends StatefulWidget {
  const _AccountView();
  @override
  State<_AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<_AccountView> {
  final oldPassword = TextEditingController(),
      newPassword = TextEditingController(),
      email = TextEditingController(),
      code = TextEditingController();
  @override
  void dispose() {
    oldPassword.dispose();
    newPassword.dispose();
    email.dispose();
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final cubit = c.watch<AccountCubit>();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const PageHeader(title: 'Account settings'),
          Section(
            title: 'Password',
            children: [
              TextField(
                controller: oldPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current password',
                ),
              ),
              TextField(
                controller: newPassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
              ),
              FilledButton(
                onPressed: () => cubit.changePassword(
                  ChangePasswordRequest(
                    oldPassword: oldPassword.text,
                    newPassword: newPassword.text,
                  ),
                ),
                child: const Text('Change password'),
              ),
              ActionFeedback(action: cubit.state.password),
            ],
          ),
          Section(
            title: 'Email',
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'New email'),
              ),
              TextField(
                controller: code,
                decoration: const InputDecoration(
                  labelText: 'Confirmation code',
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton(
                    onPressed: () => cubit.requestEmailChange(email.text),
                    child: const Text('Send code'),
                  ),
                  FilledButton(
                    onPressed: () => cubit.confirmEmailChange(
                      email: email.text,
                      code: code.text,
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
              ActionFeedback(action: cubit.state.email),
            ],
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext c) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(c).textTheme.titleLarge),
          ...children.map(
            (w) => Padding(padding: const EdgeInsets.only(top: 12), child: w),
          ),
        ],
      ),
    ),
  );
}

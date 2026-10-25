import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/api_exception.dart';
import '../../api/peo_api.dart';
import '../../models/auth.dart';
import '../../state/session_cubit.dart';
import '../../widgets/shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final login = TextEditingController(), password = TextEditingController();
  bool remember = false, busy = false;
  @override
  void dispose() {
    login.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => busy = true);
    final r = await context.read<SessionCubit>().signIn(
      LoginRequest(
        login: login.text.trim(),
        password: password.text,
        remember: remember,
      ),
    );
    if (!mounted) return;
    setState(() => busy = false);
    if (r.error == null) {
      TextInput.finishAutofillContext(shouldSave: true);
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext c) => AuthCard(
    title: 'Sign in',
    children: [
      AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: login,
              autofillHints: const [AutofillHints.username],
              decoration: const InputDecoration(labelText: 'Username or email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: password,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
      ),
      CheckboxListTile(
        value: remember,
        onChanged: (v) => setState(() => remember = v ?? false),
        title: const Text('Remember me'),
        contentPadding: EdgeInsets.zero,
      ),
      ActionButton(label: 'Sign in', busy: busy, onPressed: submit),
      TextButton(
        onPressed: () => c.go('/forget-password'),
        child: const Text('Forgot password?'),
      ),
      TextButton(
        onPressed: () => c.go('/register'),
        child: const Text('Create an account'),
      ),
    ],
  );
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController();
  bool busy = false;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => busy = true);
    final r = await context.read<SessionCubit>().register(
      RegisterRequest(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text,
      ),
    );
    if (!mounted) return;
    setState(() => busy = false);
    if (r.error == null) context.go('/');
  }

  @override
  Widget build(BuildContext c) => AuthCard(
    title: 'Create account',
    children: [
      TextField(
        controller: name,
        decoration: const InputDecoration(labelText: 'Name'),
      ),
      TextField(
        controller: email,
        decoration: const InputDecoration(labelText: 'Email'),
      ),
      TextField(
        controller: password,
        obscureText: true,
        decoration: const InputDecoration(labelText: 'Password'),
      ),
      ActionButton(label: 'Register', busy: busy, onPressed: submit),
      TextButton(
        onPressed: () => c.go('/login'),
        child: const Text('Already have an account? Sign in'),
      ),
    ],
  );
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final email = TextEditingController(),
      code = TextEditingController(),
      newPassword = TextEditingController();
  bool busy = false, sent = false, resetComplete = false;
  String? error;

  @override
  void dispose() {
    email.dispose();
    code.dispose();
    newPassword.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await context.read<PeoApi>().forgetPassword(
        ForgetPasswordRequest(email: email.text.trim()),
      );
      if (mounted) setState(() => sent = true);
    } on ApiException catch (e) {
      if (mounted) setState(() => error = e.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'Unable to send the reset code. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> reset() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await context.read<PeoApi>().resetPassword(
        ResetPasswordRequest(
          email: email.text.trim(),
          code: code.text.trim(),
          newPassword: newPassword.text,
        ),
      );
      if (mounted) setState(() => resetComplete = true);
    } on ApiException catch (e) {
      if (mounted) setState(() => error = e.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'Unable to reset the password. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext c) => AuthCard(
    title: 'Reset password',
    children: [
      if (resetComplete)
        const Text('Your password has been reset. You can now sign in.'),
      if (sent && !resetComplete)
        const Text(
          'If that address is registered, a reset code has been sent.',
        ),
      if (error != null)
        Text(error!, style: TextStyle(color: Theme.of(c).colorScheme.error)),
      TextField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email'),
      ),
      if (sent && !resetComplete) ...[
        TextField(
          controller: code,
          decoration: const InputDecoration(labelText: 'Reset code'),
        ),
        TextField(
          controller: newPassword,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'New password'),
        ),
        ActionButton(label: 'Reset password', busy: busy, onPressed: reset),
      ] else if (!resetComplete)
        ActionButton(label: 'Send reset code', busy: busy, onPressed: submit),
      TextButton(
        onPressed: () => c.go('/login'),
        child: const Text('Back to sign in'),
      ),
    ],
  );
}

class ConfirmEmailPage extends StatelessWidget {
  const ConfirmEmailPage({super.key, required this.confirmKey});
  final String confirmKey;
  @override
  Widget build(BuildContext c) => AuthCard(
    title: 'Confirm email',
    children: [
      const Text('Confirm your email address to continue.'),
      ActionButton(
        label: 'Confirm email',
        onPressed: () async {
          await c.read<PeoApi>().confirmEmail(confirmKey);
          if (c.mounted) c.go('/login');
        },
      ),
    ],
  );
}

class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext c) => Scaffold(
    body: AuthScaffold(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(c).textTheme.headlineSmall),
              const SizedBox(height: 20),
              ...children.map(
                (w) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: w,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  @override
  Widget build(BuildContext c) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: busy
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label),
  );
}

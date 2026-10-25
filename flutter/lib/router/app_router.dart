/// The client-side route table.
///
/// The Go binary owns exactly one HTML route: the catch-all that serves
/// `index.html`. Every path below therefore exists only here, which is why the
/// SPA is free to choose its own names — see `docs/CONTRACT-ROUTES.md` §9.
///
/// Two route families are deliberately *outside* the [AppShell]:
///
/// * the three account cards (sign in, register, reset password), which the
///   legacy templates rendered without the navigation bar, and
/// * `/confirm-email/:key`, because the mail the server sends links to
///   `WebHostName + "/confirm-email/" + key`.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../pages/admin/admin_dashboard_page.dart';
import '../pages/admin/admin_gallery_page.dart';
import '../pages/admin/admin_keys_page.dart';
import '../pages/admin/admin_orders_page.dart';
import '../pages/admin/admin_products_page.dart';
import '../pages/admin/admin_settings_page.dart';
import '../pages/admin/admin_users_page.dart';
import '../pages/admin/admin_work_orders_page.dart';
import '../pages/public/auth_pages.dart';
import '../pages/public/gallery_page.dart';
import '../pages/public/not_found_page.dart';
import '../pages/public/shop_page.dart';
import '../pages/public/terms_page.dart';
import '../pages/user/account_page.dart';
import '../pages/user/console_page.dart';
import '../pages/user/messages_page.dart';
import '../pages/user/order_pages.dart';
import '../pages/user/recharge_page.dart';
import '../pages/user/server_workspace_page.dart';
import '../pages/user/server_file_editor_page.dart';
import '../pages/user/work_orders_page.dart';
import '../state/session_cubit.dart';
import '../state/server_workspace_cubit.dart';
import '../api/peo_api.dart';
import '../widgets/shell.dart';
import '../theme/peo_theme.dart';

/// The path prefixes that need a signed-in visitor.
const List<String> _signedInPrefixes = <String>[
  '/console',
  '/orders',
  '/servers',
  '/recharge',
  '/messages',
  '/account',
  '/work-orders',
  '/admin',
];

/// True for a path that may not be reached while signed out.
@visibleForTesting
bool needsSession(String path) =>
    _signedInPrefixes.any((p) => path == p || path.startsWith('$p/'));

/// True for a path that additionally needs the admin flag.
@visibleForTesting
bool needsAdmin(String path) => path == '/admin' || path.startsWith('/admin/');

@visibleForTesting
String? normalizeServerWorkspacePath(String path) {
  final match = RegExp(r'^/servers/([^/]+)/([^/]+)$').firstMatch(path);
  if (match == null ||
      const {
        'console',
        'files',
        'backups',
        'startup',
        'manage',
        'editor',
      }.contains(match.group(2))) {
    return null;
  }
  return '/servers/${match.group(1)}/console';
}

/// Bridges a cubit's stream to the [Listenable] the router re-runs its redirect
/// on.
///
/// `go_router` v18 removed `GoRouterRefreshStream`, which was the usual way to
/// do this; a [ChangeNotifier] over the same subscription is its direct
/// replacement. Without it, signing in or out would leave the guard's verdict
/// stale until the next navigation.
class SessionRefresh extends ChangeNotifier {
  SessionRefresh(Stream<SessionState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<SessionState> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

/// The one route table.
GoRouter buildRouter({
  required SessionCubit session,
  required Listenable refresh,
}) {
  final editorPageKeys = <String, GlobalKey<ServerFileEditorPageState>>{};

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    errorBuilder: (context, state) => const NotFoundPage(),
    redirect: (context, state) => _guard(session, state),
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                _transitionPage(state, const ShopPage()),
          ),
          GoRoute(
            path: '/product/:specId',
            pageBuilder: (context, state) => _transitionPage(
              state,
              ProductPage(
                specId: state.pathParameters['specId'] ?? '',
                paymentMethod: state.uri.queryParameters['method'] == 'key'
                    ? 'key'
                    : 'balance',
              ),
            ),
          ),
          GoRoute(
            path: '/gallery',
            pageBuilder: (context, state) =>
                _transitionPage(state, const GalleryPage()),
          ),
          GoRoute(
            path: '/terms',
            pageBuilder: (context, state) =>
                _transitionPage(state, const TermsPage()),
          ),
          GoRoute(
            path: '/console',
            pageBuilder: (context, state) =>
                _transitionPage(state, const ConsolePage()),
          ),
          GoRoute(
            path: '/orders',
            pageBuilder: (context, state) =>
                _transitionPage(state, const OrdersPage()),
          ),
          GoRoute(
            path: '/orders/:id',
            pageBuilder: (context, state) => _transitionPage(
              state,
              OrderDetailPage(
                orderId: state.pathParameters['id'] ?? '',
                paymentMethod: state.uri.queryParameters['method'] == 'key'
                    ? 'key'
                    : 'balance',
              ),
            ),
          ),
          GoRoute(
            path: '/recharge',
            pageBuilder: (context, state) =>
                _transitionPage(state, const RechargePage()),
          ),
          GoRoute(
            path: '/messages',
            pageBuilder: (context, state) =>
                _transitionPage(state, const MessagesPage()),
          ),
          GoRoute(
            path: '/account',
            pageBuilder: (context, state) =>
                _transitionPage(state, const AccountPage()),
          ),
          GoRoute(
            path: '/work-orders',
            pageBuilder: (context, state) =>
                _transitionPage(state, const WorkOrdersPage()),
          ),
          GoRoute(
            path: '/admin',
            pageBuilder: (context, state) =>
                _transitionPage(state, const AdminDashboardPage()),
            routes: <RouteBase>[
              GoRoute(
                path: 'users',
                pageBuilder: (context, state) =>
                    _transitionPage(state, const AdminUsersPage()),
              ),
              GoRoute(
                path: 'orders',
                pageBuilder: (context, state) =>
                    _transitionPage(state, const AdminOrdersPage()),
              ),
              GoRoute(
                path: 'products',
                pageBuilder: (context, state) =>
                    _transitionPage(state, const AdminProductsPage()),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'new',
                    pageBuilder: (context, state) =>
                        _transitionPage(state, const AdminProductEditorPage()),
                  ),
                  GoRoute(
                    path: ':specId/edit',
                    pageBuilder: (context, state) => _transitionPage(
                      state,
                      AdminProductEditorPage(
                        specId: state.pathParameters['specId'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'keys',
                pageBuilder: (context, state) =>
                    _transitionPage(state, const AdminKeysPage()),
              ),
              GoRoute(
                path: 'gallery',
                pageBuilder: (context, state) =>
                    _transitionPage(state, const AdminGalleryPage()),
              ),
              GoRoute(
                path: 'work-orders',
                pageBuilder: (context, state) =>
                    _transitionPage(state, const AdminWorkOrdersPage()),
              ),
              GoRoute(
                path: 'settings',
                pageBuilder: (context, state) =>
                    _transitionPage(state, const AdminSettingsPage()),
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) {
          final serverId = RegExp(r'^/servers/([^/]+)')
              .firstMatch(state.uri.path)
              ?.group(1);
          if (serverId == null) return AppShell(child: child);
          context.read<SessionCubit>().rememberServer(serverId);
          return BlocProvider(
            key: ValueKey(serverId),
            create: (context) =>
                ServerWorkspaceCubit(context.read<PeoApi>(), serverId)
                  ..load()
                  ..startResourcePolling(),
            child: AppShell(child: child),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/servers/:id',
            redirect: (context, state) =>
                '/servers/${state.pathParameters['id'] ?? ''}/console',
          ),
          GoRoute(
            path: '/servers/:id/editor',
            onExit: (context, state) {
              final serverId = state.pathParameters['id'] ?? '';
              return editorPageKeys[serverId]?.currentState?.confirmExit() ??
                  true;
            },
            pageBuilder: (context, state) {
              final serverId = state.pathParameters['id'] ?? '';
              final editorPageKey = editorPageKeys.putIfAbsent(
                serverId,
                () => GlobalKey<ServerFileEditorPageState>(),
              );
              return NoTransitionPage<void>(
                key: ValueKey('server-editor-$serverId'),
                child: ServerFileEditorPage(
                  key: editorPageKey,
                  serverId: serverId,
                  path: state.uri.queryParameters['path'] ?? '',
                  onDisposed: () {
                    if (identical(editorPageKeys[serverId], editorPageKey)) {
                      editorPageKeys.remove(serverId);
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: '/servers/:id/:tab',
            pageBuilder: (context, state) {
              final serverId = state.pathParameters['id'] ?? '';
              return NoTransitionPage<void>(
                key: ValueKey('server-workspace-$serverId'),
                child: ServerWorkspacePage(
                  serverId: serverId,
                  tab: state.pathParameters['tab'] ?? 'console',
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forget-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/confirm-email/:key',
        builder: (context, state) =>
            ConfirmEmailPage(confirmKey: state.pathParameters['key'] ?? ''),
      ),
    ],
  );
}

Page<void> _transitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: PeoTokens.motionStandard,
    reverseTransitionDuration: PeoTokens.motionFast,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.disableAnimationsOf(context)) return child;
      final eased = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: Tween<double>(begin: 0.96, end: 1).animate(eased),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.012),
            end: Offset.zero,
          ).animate(eased),
          child: child,
        ),
      );
    },
  );
}

/// Decides whether a navigation may proceed.
///
/// While the stored token is still being examined the guard answers `null`,
/// which means "stay where you are" rather than "deny": bouncing an
/// authenticated deep link to the login page and back would be a visible flash
/// for no reason. [SessionRefresh] re-runs this the moment the status resolves.
FutureOr<String?> _guard(SessionCubit session, GoRouterState state) {
  final current = session.state;
  if (current.isUnknown) return null;

  final path = state.uri.path;
  final normalizedServerPath = normalizeServerWorkspacePath(path);
  if (normalizedServerPath != null) return normalizedServerPath;
  if (current.isSignedIn) {
    // An authenticated visitor has no business on the account cards.
    if (path == '/login' || path == '/register') return '/';
    if (needsAdmin(path) && !current.isAdmin) return '/';
    return null;
  }

  if (needsSession(path)) return '/login';
  return null;
}

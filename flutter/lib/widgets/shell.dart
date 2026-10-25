/// The application chrome.
///
/// The legacy site had one Bootstrap navigation bar, included by hand in every
/// template, whose right-hand side was built from `handleNavbar`. This is that
/// bar, rebuilt from [SiteConfig] — same items, same order, same gates — plus
/// the user sidebar the four signed-in pages carried.
library;

import 'dart:async';

import 'package:flutter/gestures.dart'
    show PointerScrollEvent, PointerSignalEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../api/peo_api.dart';
import '../models/documents.dart';
import '../models/site.dart';
import '../pages/user/messages_page.dart';
import '../state/session_cubit.dart';
import '../state/site_cubit.dart';
import '../theme/peo_theme.dart';
import 'browser.dart';
import 'formatting.dart';
import 'peo_logo.dart';
import 'responsive.dart';
import 'server_workspace_navigation.dart';

/// One destination of the top bar.
@immutable
class NavItem {
  const NavItem({
    required this.label,
    required this.icon,
    required this.location,
    this.external = false,
    this.badge = 0,
    this.emphasised = false,
  });

  final String label;
  final IconData icon;

  /// An in-app path, or a URL when [external] is set.
  final String location;

  final bool external;
  final int badge;
  final bool emphasised;
}

/// The whole site frame: top bar, optional drawer, and the page.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  static const List<(String, String, IconData)> _userDestinations = [
    ('Order history', '/orders', Icons.receipt_long_outlined),
    ('Account settings', '/account', Icons.manage_accounts_outlined),
    ('Recharge', '/recharge', Icons.account_balance_wallet_outlined),
    ('Work orders', '/work-orders', Icons.forum_outlined),
  ];

  final Widget child;

  /// The items the current configuration and session expose, in the legacy
  /// order: shop, album, messages, console, the external social link, login,
  /// administration.
  static List<NavItem> navItems(SiteConfig config) {
    final items = <NavItem>[
      const NavItem(
        label: 'Product list',
        icon: Icons.shopping_cart_outlined,
        location: '/',
      ),
    ];
    if (config.albumEnabled) {
      items.add(
        const NavItem(
          label: 'Album',
          icon: Icons.photo_library_outlined,
          location: '/gallery',
        ),
      );
    }
    if (config.loggedIn) {
      items.add(
        NavItem(
          label: 'Message',
          icon: Icons.mail_outline,
          location: '/messages',
          badge: config.unread,
        ),
      );
      items.add(
        const NavItem(
          label: 'User console',
          icon: Icons.dashboard_outlined,
          location: '/console',
        ),
      );
    }
    if (config.socialLink.isNotEmpty) {
      items.add(
        NavItem(
          label: config.socialLinkTitle.isEmpty
              ? 'Link'
              : config.socialLinkTitle,
          icon: Icons.open_in_new,
          location: config.socialLink,
          external: true,
        ),
      );
    }
    if (!config.loggedIn) {
      items.add(
        const NavItem(
          label: 'Login',
          icon: Icons.login,
          location: '/login',
          emphasised: true,
        ),
      );
    }
    if (config.isAdmin) {
      items.add(
        const NavItem(
          label: 'Admin console',
          icon: Icons.settings_outlined,
          location: '/admin',
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final siteConfig = context.watch<SiteCubit>().config;
    final session = context.watch<SessionCubit>().state;
    final tokenStore = context.read<SessionCubit>().tokenStore;
    final hasUnverifiedToken =
        session.isUnknown &&
        tokenStore.current != null &&
        tokenStore.current!.isNotEmpty;
    final config = siteConfig.copyWith(
      loggedIn:
          session.isSignedIn || (hasUnverifiedToken && siteConfig.loggedIn),
      isAdmin: session.isSignedIn
          ? session.isAdmin
          : hasUnverifiedToken && siteConfig.isAdmin,
    );
    final configuredApplicationName = config.applicationName.trim();
    final applicationName = configuredApplicationName.isEmpty
        ? 'Account Manager'
        : configuredApplicationName;
    final location = GoRouterState.of(context).matchedLocation;
    final items = navItems(config);
    final width = MediaQuery.sizeOf(context).width;
    final mobile = PeoBreakpoints.isMobile(width);
    final desktop = PeoBreakpoints.isDesktop(width);
    final compact = !mobile && !desktop;
    final userSection = _userSection(location);
    void activate(NavItem item) {
      if (item.location == 'logout') {
        unawaited(
          _UserSidebarState._confirmLogout(
            context,
            context.read<SessionCubit>(),
          ),
        );
        return;
      }
      if (item.external) {
        openExternal(item.location);
        return;
      }
      if (item.location == '/messages') {
        unawaited(showMessagesDialog(context));
        return;
      }
      context.go(item.location);
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: InkWell(
          onTap: () => context.go('/'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedPeoLogo(),
              if (applicationName.trim().toUpperCase() != 'PEO') ...[
                const SizedBox(width: 8),
                Text(
                  applicationName,
                  style: TextStyle(
                    color: PeoTokens.navText,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        leading: !desktop
            ? Builder(
                builder: (context) => IconButton(
                  tooltip: 'Open navigation',
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
              )
            : null,
        actions: !mobile
            ? [
                for (final item in items)
                  _NavButton(
                    item: item,
                    active:
                        !item.external && _isActive(location, item.location),
                    compact: compact,
                    onTap: () => activate(item),
                  ),
                if (config.loggedIn)
                  PopupMenuButton<String>(
                    tooltip: 'Account navigation',
                    icon: const Icon(Icons.person_outline),
                    constraints: const BoxConstraints(
                      minWidth: 312,
                      maxWidth: 312,
                    ),
                    onSelected: (destination) {
                      if (destination == 'logout') {
                        unawaited(
                          _UserSidebarState._confirmLogout(
                            context,
                            context.read<SessionCubit>(),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        enabled: false,
                        height: 112,
                        child: _AccountMenuProfile(user: session.user),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      drawer: !desktop
          ? Drawer(
              backgroundColor: PeoTokens.navBackground,
              child: SafeArea(
                child: ListTileTheme(
                  data: ListTileThemeData(
                    minTileHeight: 48,
                    iconColor: PeoTokens.navTextMuted,
                    textColor: PeoTokens.navTextMuted,
                    selectedColor: PeoTokens.navText,
                    selectedTileColor: PeoTokens.navActive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        PeoTokens.radiusSmall,
                      ),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.rocket_launch,
                              color: PeoTokens.accentAlt,
                              size: 28,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              config.applicationName.isEmpty
                                  ? 'Account Manager'
                                  : config.applicationName,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: PeoTokens.navText),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: PeoTokens.navDivider),
                      if (config.loggedIn) ...[
                        const _DrawerHeading('Server'),
                        ListTile(
                          leading: const Icon(Icons.dns_outlined),
                          title: const Text('Server List'),
                          selected: location == '/console',
                          onTap: () {
                            Navigator.of(context).pop();
                            context.go('/console');
                          },
                        ),
                        ServerSwitcher(
                          location: location,
                          onNavigate: (path) {
                            Navigator.of(context).pop();
                            context.go(path);
                          },
                        ),
                        const Divider(color: PeoTokens.navDivider),
                        const _DrawerHeading('Site'),
                        for (final item in items.where(
                          (item) => item.location != '/console',
                        ))
                          ListTile(
                            leading: Icon(item.icon),
                            title: Text(item.label),
                            trailing: item.badge > 0
                                ? Badge(label: Text('${item.badge}'))
                                : null,
                            selected:
                                !item.external &&
                                _isActive(location, item.location),
                            onTap: () {
                              Navigator.of(context).pop();
                              activate(item);
                            },
                          ),
                        const Divider(color: PeoTokens.navDivider),
                        const _DrawerHeading('Account'),
                        for (final (label, path, icon) in _userDestinations)
                          ListTile(
                            leading: Icon(icon),
                            title: Text(label),
                            selected: _isActive(location, path),
                            onTap: () {
                              Navigator.of(context).pop();
                              context.go(path);
                            },
                          ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          onTap: () {
                            Navigator.of(context).pop();
                            unawaited(
                              _UserSidebarState._confirmLogout(
                                context,
                                context.read<SessionCubit>(),
                              ),
                            );
                          },
                        ),
                      ],
                      if (!config.loggedIn)
                        for (final item in items)
                          ListTile(
                            leading: Icon(item.icon),
                            title: Text(item.label),
                            trailing: item.badge > 0
                                ? Badge(label: Text('${item.badge}'))
                                : null,
                            selected:
                                !item.external &&
                                _isActive(location, item.location),
                            onTap: () {
                              Navigator.of(context).pop();
                              activate(item);
                            },
                          ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: _PageScrollbar(
        maxContentWidth: PeoBreakpoints.maxContentWidth,
        child: _Background(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: width < PeoBreakpoints.maxContentWidth
                    ? width
                    : PeoBreakpoints.maxContentWidth,
                maxWidth: PeoBreakpoints.maxContentWidth,
              ),
              child: desktop && config.loggedIn && userSection != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 232,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 24, 0, 24),
                            child: UserSidebar(section: userSection),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Semantics(
                            container: true,
                            explicitChildNodes: true,
                            child: child,
                          ),
                        ),
                      ],
                    )
                  : child,
            ),
          ),
        ),
      ),
    );
  }

  static bool _isActive(String location, String target) {
    if (target == '/') return location == '/';
    return location == target || location.startsWith('$target/');
  }

  static String? _userSection(String location) {
    if (location == '/console') return 'dashboard';
    if (location == '/account') return 'account';
    if (location == '/recharge') return 'recharge';
    if (location == '/work-orders') return 'tickets';
    if (location == '/orders' || location.startsWith('/orders/')) {
      return 'orders';
    }
    if (location.startsWith('/servers/')) return 'server';
    return null;
  }
}

class _AccountMenuProfile extends StatelessWidget {
  const _AccountMenuProfile({required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.name.trim();
    final displayName = name == null || name.isEmpty ? 'Account' : name;
    final role = user?.isAdmin == true ? 'Administrator' : 'Customer';
    final balance = user?.balance;

    return SizedBox(
      width: 280,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: PeoTokens.accentPale,
            foregroundColor: PeoTokens.accent,
            child: Text(
              displayName.characters.first.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (user?.email case final email? when email.isNotEmpty)
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: PeoTokens.textMuted),
                  ),
                const SizedBox(height: 4),
                Text(
                  balance == null
                      ? role
                      : '$role  ·  Balance ${money(balance)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: PeoTokens.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeading extends StatelessWidget {
  const _DrawerHeading(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: PeoTokens.navTextMuted),
    ),
  );
}

/// Shared server picker used in the desktop sidebar and mobile drawer.
class ServerSwitcher extends StatefulWidget {
  const ServerSwitcher({super.key, required this.location, this.onNavigate});

  final String location;
  final ValueChanged<String>? onNavigate;

  @override
  State<ServerSwitcher> createState() => _ServerSwitcherState();
}

class _ServerSwitcherState extends State<ServerSwitcher> {
  late Future<List<WareEntity>> _servers = context.read<PeoApi>().servers();

  void _retry() => setState(() => _servers = context.read<PeoApi>().servers());

  void _navigate(BuildContext context, String path) {
    final callback = widget.onNavigate;
    if (callback != null) {
      callback(path);
    } else {
      context.go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'^/servers/([^/]+)(?:/([^/]+))?$')
        .firstMatch(widget.location);
    final routeServerId = match?.group(1);
    final session = context.read<SessionCubit>();
    if (routeServerId != null) session.rememberServer(routeServerId);
    final activeId = routeServerId ?? session.selectedServerId;
    final activeTab = routeServerId == null
        ? null
        : match?.group(2) == 'editor'
        ? 'files'
        : match?.group(2) ?? 'console';

    return FutureBuilder<List<WareEntity>>(
      future: _servers,
      builder: (context, snapshot) {
        final servers = snapshot.data ?? const <WareEntity>[];
        WareEntity? activeServer;
        for (final server in servers) {
          if (server.id == activeId) {
            activeServer = server;
            break;
          }
        }
        final title = activeServer == null
            ? activeId == null
                  ? 'Select a server'
                  : 'Server $activeId'
            : activeServer.hostName.trim().isEmpty
            ? 'Server'
            : activeServer.hostName;
        final menuItems = <PopupMenuEntry<_ServerPickerAction>>[];
        if (snapshot.connectionState == ConnectionState.waiting) {
          menuItems.add(
            const PopupMenuItem<_ServerPickerAction>(
              enabled: false,
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading servers'),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          menuItems.add(
            const PopupMenuItem<_ServerPickerAction>(
              enabled: false,
              child: Text('Could not load servers'),
            ),
          );
          menuItems.add(
            const PopupMenuItem<_ServerPickerAction>(
              value: _ServerPickerAction.retry,
              child: Text('Retry loading servers'),
            ),
          );
        } else if (servers.isEmpty) {
          menuItems.add(
            const PopupMenuItem<_ServerPickerAction>(
              enabled: false,
              child: Text('No servers yet'),
            ),
          );
        } else {
          for (final server in servers) {
            if (server.id == null) continue;
            menuItems.add(
              CheckedPopupMenuItem<_ServerPickerAction>(
                checked: server.id == activeId,
                value: _ServerPickerAction.select(server.id!),
                child: Text(
                  server.hostName.trim().isEmpty ? 'Server' : server.hostName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              dense: true,
              minTileHeight: 48,
              hoverColor: PeoTokens.navHover.withValues(alpha: .62),
              minLeadingWidth: 24,
              contentPadding: const EdgeInsets.only(left: 16, right: 4),
              leading: const Icon(Icons.dns_outlined, size: 20),
              title: Tooltip(
                message: title,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: ListTileTheme(
                data: ListTileTheme.of(context).copyWith(
                  textColor: PeoTokens.text,
                  iconColor: PeoTokens.textSecondary,
                ),
                child: PopupMenuTheme(
                  data: PopupMenuTheme.of(context).copyWith(
                    labelTextStyle: WidgetStateProperty.resolveWith(
                      (states) => TextStyle(
                        color: states.contains(WidgetState.disabled)
                            ? PeoTokens.textMuted
                            : PeoTokens.text,
                      ),
                    ),
                  ),
                  child: PopupMenuButton<_ServerPickerAction>(
                    tooltip: 'Choose server',
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: PeoTokens.navText,
                    ),
                    onSelected: (action) {
                      if (action.isRetry) {
                        _retry();
                        return;
                      }
                      final serverId = action.serverId;
                      if (serverId == null) return;
                      session.rememberServer(serverId);
                      _navigate(
                        context,
                        '/servers/$serverId/${routeServerId == null ? 'console' : activeTab}',
                      );
                    },
                    itemBuilder: (_) => menuItems,
                  ),
                ),
              ),
            ),
            if (activeId != null)
              for (final item in serverWorkspaceDestinations(activeId))
                _SidebarTile(
                  icon: item.icon,
                  label: item.label,
                  selected: activeTab == item.path.split('/').last,
                  indent: true,
                  onTap: () => _navigate(context, item.path),
                ),
          ],
        );
      },
    );
  }
}

class _ServerPickerAction {
  const _ServerPickerAction.select(this.serverId) : isRetry = false;
  const _ServerPickerAction._retry() : serverId = null, isRetry = true;

  static const retry = _ServerPickerAction._retry();

  final String? serverId;
  final bool isRetry;
}

/// A light page background, so cards stand out the way the legacy body did.
class _Background extends StatelessWidget {
  const _Background({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerLowest,
    child: child,
  );
}

/// Places page scrollbars at the edge of the viewport, outside the centered
/// content width used by the site layout.
class _PageScrollbar extends StatefulWidget {
  const _PageScrollbar({required this.child, required this.maxContentWidth});

  final Widget child;
  final double maxContentWidth;

  @override
  State<_PageScrollbar> createState() => _PageScrollbarState();
}

class _PageScrollbarState extends State<_PageScrollbar> {
  ScrollableState? _activeScrollable;

  void _rememberScrollable(BuildContext? context) {
    if (context == null) return;
    final scrollable = Scrollable.maybeOf(context, axis: Axis.vertical);
    if (scrollable != null) _activeScrollable = scrollable;
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth == 0 && notification.metrics.axis == Axis.vertical) {
      _rememberScrollable(notification.context);
    }
    return false;
  }

  bool _onScrollMetrics(ScrollMetricsNotification notification) {
    if (notification.depth == 0 && notification.metrics.axis == Axis.vertical) {
      _rememberScrollable(notification.context);
    }
    return false;
  }

  void _onPointerSignal(PointerSignalEvent event, double left, double right) {
    if (event is! PointerScrollEvent) return;
    final x = event.localPosition.dx;
    if (x >= left && x <= right) return;

    final scrollable = _activeScrollable;
    if (scrollable == null || !scrollable.mounted) return;
    final position = scrollable.position;
    if (!position.hasContentDimensions) return;

    final delta = event.scrollDelta.dy;
    if (delta == 0) return;
    final target = (position.pixels + delta)
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();
    if (target == position.pixels) return;

    position.pointerScroll(delta);
    event.respond(allowPlatformDefault: false);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final contentWidth = constraints.maxWidth < widget.maxContentWidth
          ? constraints.maxWidth
          : widget.maxContentWidth;
      final gap = (constraints.maxWidth - contentWidth) / 2;
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: NotificationListener<ScrollMetricsNotification>(
          onNotification: _onScrollMetrics,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerSignal: (event) =>
                  _onPointerSignal(event, gap, constraints.maxWidth - gap),
              child: Scrollbar(interactive: false, child: widget.child),
            ),
          ),
        ),
      );
    },
  );
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.compact,
    required this.onTap,
  });

  final NavItem item;
  final bool active;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = active
        ? PeoTokens.navText
        : item.emphasised
        ? PeoTokens.accentAlt
        : PeoTokens.navTextMuted;
    if (compact) {
      final button = IconButton(
        tooltip: item.label,
        onPressed: onTap,
        style: IconButton.styleFrom(
          backgroundColor: active ? PeoTokens.navActive : null,
          foregroundColor: foreground,
          overlayColor: PeoTokens.navHover.withValues(alpha: 0.72),
        ),
        icon: Icon(item.icon),
      );
      return item.badge > 0
          ? Badge(label: Text('${item.badge}'), child: button)
          : button;
    }
    final button = TextButton.icon(
      onPressed: onTap,
      icon: Icon(item.icon, size: 16, color: foreground),
      label: Text(
        item.label,
        style: TextStyle(
          fontWeight: item.emphasised ? FontWeight.bold : FontWeight.w500,
          color: foreground,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: foreground,
        backgroundColor: active ? PeoTokens.navActive : null,
        overlayColor: PeoTokens.navHover.withValues(alpha: 0.72),
      ),
    );
    if (item.badge <= 0) return button;
    return Badge(label: Text('${item.badge}'), child: button);
  }
}

/// The four signed-in pages of the legacy site carried a sidebar; this is it.
///
/// The panel hand-off is a real top-level navigation rather than an API call
/// shown inline, because the panel sets its own session cookie on its own
/// document — the port of the legacy `/delay/login` redirect.
class UserSidebar extends StatefulWidget {
  const UserSidebar({super.key, required this.section});

  /// The active entry: `dashboard`, `account`, `recharge` or `tickets`.
  final String section;
  @override
  State<UserSidebar> createState() => _UserSidebarState();
}

class _UserSidebarState extends State<UserSidebar> {
  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final session = context.watch<SessionCubit>();

    return Card(
      color: PeoTokens.navBackground,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PeoTokens.radiusMedium),
        side: const BorderSide(color: PeoTokens.navSurface),
      ),
      child: ListTileTheme(
        data: ListTileThemeData(
          minTileHeight: 48,
          iconColor: PeoTokens.navTextMuted,
          textColor: PeoTokens.navTextMuted,
          selectedColor: PeoTokens.navText,
          selectedTileColor: PeoTokens.navActive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PeoTokens.radiusSmall),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  'SERVER',
                  style: TextStyle(
                    color: PeoTokens.navTextMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _SidebarTile(
                icon: Icons.dashboard_outlined,
                label: 'Server List',
                selected: section == 'dashboard',
                onTap: () => context.go('/console'),
              ),
              ServerSwitcher(
                location: GoRouterState.of(context).matchedLocation,
              ),
              const Divider(height: 16, color: PeoTokens.navDivider),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  'ACCOUNT',
                  style: TextStyle(
                    color: PeoTokens.navTextMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _SidebarTile(
                icon: Icons.receipt_long_outlined,
                label: 'Order history',
                selected: section == 'orders',
                onTap: () => context.go('/orders'),
              ),
              _SidebarTile(
                icon: Icons.manage_accounts_outlined,
                label: 'Account Settings',
                selected: section == 'account',
                onTap: () => context.go('/account'),
              ),
              _SidebarTile(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Balance Recharge',
                selected: section == 'recharge',
                onTap: () => context.go('/recharge'),
              ),
              _SidebarTile(
                icon: Icons.forum_outlined,
                label: 'Ticket System',
                selected: section == 'tickets',
                onTap: () => context.go('/work-orders'),
              ),
              const Divider(height: 8, color: PeoTokens.navDivider),
              _SidebarTile(
                icon: Icons.logout,
                label: 'Logout',
                selected: false,
                onTap: () => _confirmLogout(context, session),
              ),
              const Divider(height: 8, color: PeoTokens.navDivider),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  '${session.state.userName}  ${money(session.state.balance)}',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: PeoTokens.navTextMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _confirmLogout(
    BuildContext context,
    SessionCubit session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure to log out? You will need to log in again to access '
          'some content.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await session.signOut();
    if (!context.mounted) return;
    context.go('/');
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.indent = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool indent;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ListTile(
        dense: true,
        minTileHeight: 48,
        hoverColor: PeoTokens.navHover.withValues(alpha: .62),
        minLeadingWidth: 24,
        contentPadding: EdgeInsets.only(left: indent ? 28 : 16, right: 12),
        leading: Icon(icon, size: 20),
        title: Text(label),
        selected: selected,
        onTap: onTap,
      ),
      if (selected)
        const Positioned(
          left: 8,
          top: 8,
          bottom: 8,
          child: SizedBox(
            width: 3,
            child: ColoredBox(color: PeoTokens.accentAlt),
          ),
        ),
    ],
  );
}

/// A signed-in page: sidebar on the left on wide screens, content on the right.
class UserScaffold extends StatelessWidget {
  const UserScaffold({
    super.key,
    required this.section,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const <Widget>[],
  });

  final String section;
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final desktop = PeoBreakpoints.isDesktop(width);
    final page = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(title: title, subtitle: subtitle, actions: actions),
        child,
      ],
    );

    return ResponsivePage(
      padding: EdgeInsets.all(PeoBreakpoints.isMobile(width) ? 16 : 24),
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 232, child: UserSidebar(section: section)),
                const SizedBox(width: 24),
                Expanded(child: page),
              ],
            )
          : page,
    );
  }
}

/// The heading every page opens with.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const <Widget>[],
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: theme.textTheme.headlineSmall),
              if (subtitle != null && subtitle!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
            ],
          ),
          if (actions.isNotEmpty)
            Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }
}

/// Centres a narrow card, the shape of the three standalone auth screens.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<SiteCubit>().config;
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_outlined),
                  label: Text(
                    config.applicationName.isEmpty
                        ? 'Account Manager'
                        : config.applicationName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

@immutable
class ServerWorkspaceDestination {
  const ServerWorkspaceDestination({
    required this.label,
    required this.path,
    required this.icon,
  });

  final String label;
  final String path;
  final IconData icon;
}

List<ServerWorkspaceDestination> serverWorkspaceDestinations(String serverId) =>
    [
      ServerWorkspaceDestination(
        label: 'Console',
        icon: Icons.terminal,
        path: '/servers/$serverId/console',
      ),
      ServerWorkspaceDestination(
        label: 'Files',
        icon: Icons.folder_outlined,
        path: '/servers/$serverId/files',
      ),
      ServerWorkspaceDestination(
        label: 'Backups',
        icon: Icons.backup_outlined,
        path: '/servers/$serverId/backups',
      ),
      ServerWorkspaceDestination(
        label: 'Startup',
        icon: Icons.tune,
        path: '/servers/$serverId/startup',
      ),
      ServerWorkspaceDestination(
        label: 'Manage',
        icon: Icons.settings_outlined,
        path: '/servers/$serverId/manage',
      ),
    ];

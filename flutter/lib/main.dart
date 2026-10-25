import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'api/api_client.dart';
import 'api/peo_api.dart';
import 'api/token_store.dart';
import 'router/app_router.dart';
import 'state/session_cubit.dart';
import 'state/site_cubit.dart';
import 'theme/peo_theme.dart';

void main() {
  usePathUrlStrategy();
  runApp(const PeoApp());
}

class PeoApp extends StatefulWidget {
  const PeoApp({super.key, this.api, this.tokenStore});

  final PeoApi? api;
  final TokenStore? tokenStore;

  @override
  State<PeoApp> createState() => _PeoAppState();
}

class _PeoAppState extends State<PeoApp> {
  late final TokenStore _tokenStore;
  late final ApiClient _client;
  late final PeoApi _api;
  late final SessionCubit _session;
  late final SiteCubit _site;
  late final SessionRefresh _sessionRefresh;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _tokenStore = widget.tokenStore ?? TokenStore();
    _client =
        widget.api?.client ??
        ApiClient(
          tokenStore: _tokenStore,
          baseUrl: const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: '/api/v1',
          ),
        );
    _api = widget.api ?? PeoApi(_client);
    _session = SessionCubit(api: _api, tokenStore: _tokenStore);
    _site = SiteCubit(_api);
    _sessionRefresh = SessionRefresh(_session.stream);
    _router = buildRouter(session: _session, refresh: _sessionRefresh);
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    await _session.bootstrap();
    if (!mounted) return;
    await _site.load();
  }

  @override
  void dispose() {
    _router.dispose();
    _sessionRefresh.dispose();
    unawaited(_session.close());
    unawaited(_site.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      RepositoryProvider<PeoApi>.value(value: _api),
      BlocProvider<SessionCubit>.value(value: _session),
      BlocProvider<SiteCubit>.value(value: _site),
    ],
    child: MaterialApp.router(
      title: 'Peo',
      theme: PeoTheme.light,
      routerConfig: _router,
    ),
  );
}

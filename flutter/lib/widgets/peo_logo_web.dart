import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../theme/peo_theme.dart';

@JS('peoMountLogo')
external void _mountPeoLogo(web.HTMLDivElement element);

const _viewType = 'peo-echarts-wordmark-v1';
const _logoWidth = 68.0;
const _logoHeight = 36.0;

bool _viewFactoryRegistered = false;

void _registerViewFactory() {
  if (_viewFactoryRegistered) return;
  _viewFactoryRegistered = true;
  ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
    final element = web.HTMLDivElement()
      ..style.width = '${_logoWidth}px'
      ..style.height = '${_logoHeight}px'
      ..style.display = 'block'
      ..style.overflow = 'hidden'
      ..style.pointerEvents = 'none';
    _mountPeoLogo(element);
    return element;
  });
}

/// PEO's animated ECharts wordmark, with a static reduced-motion fallback.
class AnimatedPeoLogo extends StatelessWidget {
  const AnimatedPeoLogo({super.key});

  Widget _staticMark() => SizedBox(
    width: _logoWidth,
    height: _logoHeight,
    child: Center(
      child: Text(
        'PEO',
        style: TextStyle(
          color: PeoTokens.navText,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Semantics(label: 'PEO', image: true, child: _staticMark());
    }

    _registerViewFactory();
    return Semantics(
      label: 'PEO',
      image: true,
      child: SizedBox(
        width: _logoWidth,
        height: _logoHeight,
        child: IgnorePointer(child: HtmlElementView(viewType: _viewType)),
      ),
    );
  }
}

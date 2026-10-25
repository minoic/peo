import 'package:flutter/material.dart';

import '../theme/peo_theme.dart';

/// Static fallback for platforms without browser support.
class AnimatedPeoLogo extends StatelessWidget {
  const AnimatedPeoLogo({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'PEO',
    image: true,
    child: SizedBox(
      width: 68,
      height: 36,
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
    ),
  );
}

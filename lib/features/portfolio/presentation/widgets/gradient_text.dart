import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class GradientText extends StatelessWidget {
  const GradientText({super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? Theme.of(context).textTheme.displayMedium;
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [AppTheme.surface, AppTheme.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: effectiveStyle?.copyWith(color: Colors.white, height: 1.2),
      ),
    );
  }
}

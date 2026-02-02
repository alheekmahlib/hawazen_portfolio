import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blurSigma = 18,
    this.tint,
    this.tintAlpha,
    this.borderAlpha = 26,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double blurSigma;
  final Color? tint;
  final int? tintAlpha;
  final int borderAlpha;

  @override
  Widget build(BuildContext context) {
    final baseTint = tint ?? Colors.white;
    final resolvedTintAlpha = tintAlpha ?? 15;
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: baseTint.withAlpha(resolvedTintAlpha),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withAlpha(borderAlpha)),
          ),
          child: child,
        ),
      ),
    );
  }
}

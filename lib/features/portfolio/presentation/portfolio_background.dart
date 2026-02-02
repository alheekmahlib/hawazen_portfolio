import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PortfolioBackground extends StatelessWidget {
  const PortfolioBackground({
    super.key,
    required this.child,
    required this.scrollOffset,
  });

  final Widget child;
  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportHeight = constraints.maxHeight;
        final shift = viewportHeight <= 0 ? 0.0 : scrollOffset % viewportHeight;
        final paintHeight = viewportHeight <= 0
            ? constraints.maxHeight
            : viewportHeight * 2;

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: -shift,
              height: paintHeight,
              child: CustomPaint(painter: const _BackgroundPainter()),
            ),
            child,
          ],
        );
      },
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.6),
        radius: 1.2,
        colors: [AppTheme.bg, Color(0xFF07080B)],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    _paintOrbs(canvas, size);
    _paintGrid(canvas, size);
  }

  void _paintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(10)
      ..strokeWidth = 1;

    const step = 56.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintOrbs(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..color = Colors.white.withAlpha(16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    _drawRing(
      canvas: canvas,
      center: Offset(size.width - 80, 80),
      radius: 260,
      paint: ringPaint,
    );
    _drawRing(
      canvas: canvas,
      center: const Offset(100, 580),
      radius: 320,
      paint: ringPaint,
    );
    _drawRing(
      canvas: canvas,
      center: Offset(size.width - 120, size.height - 160),
      radius: 380,
      paint: ringPaint,
    );

    _drawGlow(
      canvas: canvas,
      center: const Offset(170, 250),
      radius: 130,
      color: AppTheme.surface.withAlpha(36),
    );
    _drawGlow(
      canvas: canvas,
      center: Offset(size.width - 220, size.height - 280),
      radius: 160,
      color: AppTheme.surface.withAlpha(28),
    );
  }

  void _drawRing({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required Paint paint,
  }) {
    canvas.drawCircle(center, radius, paint);
  }

  void _drawGlow({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required Color color,
  }) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

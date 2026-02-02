import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PortfolioBackground extends StatelessWidget {
  const PortfolioBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _Gradient(),
        const _Orbs(),
        const _Grid(),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _Gradient extends StatelessWidget {
  const _Gradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.2, -0.6),
          radius: 1.2,
          colors: [AppTheme.bg, Color(0xFF07080B)],
        ),
      ),
    );
  }
}

class _Orbs extends StatelessWidget {
  const _Orbs();

  @override
  Widget build(BuildContext context) {
    final ring = Colors.white.withAlpha(16);
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -180,
            right: -180,
            child: _Circle(diameter: 520, color: ring),
          ),
          Positioned(
            top: 260,
            left: -220,
            child: _Circle(diameter: 640, color: ring),
          ),
          Positioned(
            bottom: -220,
            right: -260,
            child: _Circle(diameter: 760, color: ring),
          ),
          Positioned(
            top: 120,
            left: 40,
            child: _Glow(diameter: 260, color: AppTheme.surface.withAlpha(36)),
          ),
          Positioned(
            bottom: 120,
            right: 60,
            child: _Glow(diameter: 320, color: AppTheme.surface.withAlpha(28)),
          ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Positioned.fill(child: CustomPaint(painter: _GridPainter())),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Circle extends StatelessWidget {
  const _Circle({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

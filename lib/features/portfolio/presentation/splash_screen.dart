import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          child: AnimatedDrawing.svg(
            'assets/svg/hawazen.svg',
            width: 170,
            height: 170,
            run: true,
            repeat: false,
            scaleToViewport: true,
            animationCurve: Curves.easeInOut,
            duration: const Duration(seconds: 3),
            paintMode: PaintMode.strokeOnly,
            lineAnimation: LineAnimation.oneByOne,
            animationDirection: AnimationDirection.rightToLeft,
          ),
        ),
      ),
    );
  }
}

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
            animationDirection: AnimationDirection.rightToLeft,
            run: true,
            duration: const Duration(seconds: 3),
            height: 170,
            width: 170,
            scaleToViewport: true,
            repeat: false,
            lineAnimation: LineAnimation.oneByOne,
            animationCurve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_page.dart';
import '../../features/portfolio/presentation/portfolio_page.dart';
import '../../features/portfolio/presentation/splash_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/admin', builder: (context, state) => const AdminPage()),
      ShellRoute(
        builder: (context, state, child) {
          return PortfolioPage(
            key: const ValueKey('portfolio'),
            sectionSlug: state.pathParameters['sectionSlug'],
            itemId: state.pathParameters['itemId'],
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: SizedBox.shrink());
            },
            routes: [
              GoRoute(
                path: ':sectionSlug',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: SizedBox.shrink());
                },
                routes: [
                  GoRoute(
                    path: ':itemId',
                    pageBuilder: (context, state) {
                      return const NoTransitionPage(child: SizedBox.shrink());
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text(state.error?.toString() ?? 'Not found')),
      );
    },
  );
}

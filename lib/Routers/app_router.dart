import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/screen/AuthScreen/phone_auth/otp_verify_screen.dart';
import 'package:med_connect/screen/AuthScreen/phone_auth/phone_auth_screen.dart';
import 'package:med_connect/screen/AuthScreen/roles/role_selection_screen.dart';
import 'package:med_connect/screen/onBoardingscrren/onboarding.dart';
import 'package:med_connect/screen/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const roleSelection = '/role-selection';
  static const phoneEntry = '/phone-entry';
  static const otpVerify = '/otp-verify';
  
}

CustomTransitionPage slidePage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final incoming = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      final outgoing = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.15, 0),
      ).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCubic),
      );

      return SlideTransition(
        position: outgoing,
        child: SlideTransition(position: incoming, child: child),
      );
    },
  );
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // No slide here — splash has its own pulse/zoom entrance.
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // No slide here — onboarding's own PageView swipe is the motion.
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Every route from here on uses the shared slide transition.
      GoRoute(
        path: AppRoutes.roleSelection,
        pageBuilder: (context, state) =>
            slidePage(const RoleSelectionScreen(), state),
      ),
      GoRoute(
        path: AppRoutes.phoneEntry,
        pageBuilder: (context, state) {
          final role = state.extra as UserRole;
          return slidePage(PhoneAuthScreen(role: role), state);
        },
      ),
      GoRoute(
        path: AppRoutes.otpVerify,
        pageBuilder: (context, state) {
          final (phone, role) = state.extra as (String, UserRole);
          return slidePage(OtpVerifyScreen(phone: phone, role: role), state);
        },
      ),
    ],
  );
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/Splash%20Animation/splashanimation.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/systemui.dart';
import 'package:med_connect/Theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;

      context.go(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayFor(AppColors.navy),
      child: Scaffold(
        backgroundColor: AppColors.navy,
        body: Center(
          child: SplashLogoAnimation(
            child: Image.asset(
              // Update this to match your actual asset path/filename.
              'assets/logo.png',
              width: 200,
            ),
          ),
        ),
      ),
    );
  }
}
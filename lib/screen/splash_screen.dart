import 'package:flutter/material.dart';
import 'package:med_connect/Animations/Splash%20Animation/splashanimation.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/screen/onBoardingscrren/onboarding.dart';

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
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
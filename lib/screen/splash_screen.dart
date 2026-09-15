import 'package:flutter/material.dart';
import 'package:med_connect/Animations/Splash%20Animation/splashanimation.dart';
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
      // Replace with your actual next screen, e.g.:
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Center(
        child: SplashLogoAnimation(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.monitor_heart_outlined,
                size: 72,
                color: AppColors.white,
              ),
              const SizedBox(height: 18),
              Text(
                'MedConnect',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Care within reach',
                style: AppTextStyles.bodySecondary.copyWith(
                  color: AppColors.mutedBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
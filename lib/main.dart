import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: AppColors.navy,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: child!,
        );
      },
    );
  }
}
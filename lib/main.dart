import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/systemui.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
          builder: (context, child) {
          
           
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayFor(AppColors.paleBlue),
              child: child!,
            );
          },
        );
      },
    );
  }
}
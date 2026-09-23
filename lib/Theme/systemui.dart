import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SystemUiOverlayStyle overlayFor(Color backgroundColor) {
  final isDarkBg =
      ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark;

  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: isDarkBg ? Brightness.dark : Brightness.light,
    statusBarIconBrightness: isDarkBg ? Brightness.light : Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: isDarkBg
        ? Brightness.light
        : Brightness.dark,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
  );
}

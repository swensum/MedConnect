import 'package:flutter/material.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key, required this.phone, required this.role,});
  
  final String phone;
  final UserRole role;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 30;

  String _code = '';
  bool _isVerifying = false;
  String? _errorText;

  Timer? _resendTimer;
  int _secondsLeft = _resend
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
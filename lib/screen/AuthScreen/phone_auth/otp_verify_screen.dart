import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Routers/app_router.dart';

import 'package:med_connect/Theme/systemui.dart';
import 'package:med_connect/Theme/theme.dart';

import 'package:med_connect/screen/AuthScreen/roles/role_selection_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key, required this.phone, required this.role});

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
  int _secondsLeft = _resendSeconds;

  bool get _isComplete => _code.length == _otpLength;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() => _secondsLeft = _resendSeconds);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        if (mounted) setState(() => _secondsLeft = 0);
      } else {
        if (mounted) setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _verify() async {
    if (!_isComplete || _isVerifying) return;

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    // TODO: Replace with real Firebase Auth verification. During dev, use
    // Firebase Console → Authentication → Phone → "Phone numbers for
    // testing" so no real SMS is sent and no cost is incurred.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isVerifying = false);

    // Route into the role-specific next step. Using context.go (not push)
    // since the whole auth flow — phone entry, OTP — should be popped off
    // the back stack once verification succeeds.
    if (widget.role == UserRole.patient) {
      context.go(AppRoutes.patientProfileSetup, extra: widget.phone);
    } else {
      context.go(AppRoutes.doctorKyc, extra: widget.phone);
    }
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeuBg,
      appBar: AppBar(
        backgroundColor: kNeuBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        systemOverlayStyle: overlayFor(kNeuBg),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Text('Verify your number', style: AppTextStyles.h1),
              SizedBox(height: 8.h),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodySecondary,
                  children: [
                    const TextSpan(text: 'Enter the 6-digit code sent to '),
                    TextSpan(
                      text: widget.phone,
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              _OtpInput(
                length: _otpLength,
                hasError: _errorText != null,
                onChanged: (value) {
                  setState(() {
                    _code = value;
                    _errorText = null;
                  });
                },
                onCompleted: (_) => _verify(),
              ),

              if (_errorText != null) ...[
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 14.sp,
                      color: AppColors.danger,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _errorText!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 24.h),
              _ResendRow(secondsLeft: _secondsLeft, onResend: _resend),

              const Spacer(),
              NeuPillButton(
                enabled: _isComplete && !_isVerifying,
                onTap: _verify,
                loading: _isVerifying,
                label: 'Verify',
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpInput extends StatefulWidget {
  const _OtpInput({
    required this.length,
    required this.onChanged,
    required this.onCompleted,
    this.hasError = false,
  });
  final int length;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  @override
  State<_OtpInput> createState() => __OtpInputState();
}

class __OtpInputState extends State<_OtpInput> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _controller.addListener(() {
      final value = _controller.text;
      widget.onChanged(value);
      if (value.length == widget.length) {
        _focusNode.unfocus();
        widget.onCompleted(value);
      }
      setState(() {});
    });
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: SizedBox(
              height: 1,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: widget.length,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                showCursor: false,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length, (index) {
              final text = _controller.text;
              final filled = index < text.length;
              final isCurrent = index == text.length && _focusNode.hasFocus;

              final List<BoxShadow> shadow;
              if (widget.hasError) {
                shadow = [
                  BoxShadow(
                    color: AppColors.danger.withValues(alpha: 0.35),
                    offset: const Offset(0, 0),
                    blurRadius: 10,
                    spreadRadius: 0.5,
                  ),
                ];
              } else if (filled) {
                shadow = neuShadows(distance: 3, blur: 6, inset: true);
              } else if (isCurrent) {
                shadow = neuShadows(distance: 4, blur: 9);
              } else {
                shadow = neuShadows(distance: 3, blur: 6);
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 46.w,
                height: 56.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kNeuBg,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: shadow,
                ),
                child: (isCurrent && !filled)
                    ? FadeTransition(
                        opacity: _cursorController,
                        child: Container(
                          width: 2.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: AppColors.navy,
                            borderRadius: BorderRadius.circular(1.r),
                          ),
                        ),
                      )
                    : Text(
                        filled ? text[index] : '',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 20.sp,
                          color: AppColors.navy,
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({required this.secondsLeft, required this.onResend});
  final int secondsLeft;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final canResend = secondsLeft == 0;
    return Row(
      children: [
        Text("Didn't get the code?", style: AppTextStyles.bodySecondary),
        SizedBox(width: 6.w),
        GestureDetector(
          onTap: canResend ? onResend : null,
          child: Text(
            canResend ? 'Resend' : 'Resend in ${secondsLeft}s',
            style: AppTextStyles.bodySecondary.copyWith(
              color: canResend ? AppColors.navy : AppColors.textSecondary,
              fontWeight: canResend ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
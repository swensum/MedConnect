import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/models/payment_models.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({super.key, required this.method});
  final PaymentMethod method;

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _runFakeCheckout();
  }

  Future<void> _runFakeCheckout() async {
    await Future.delayed(const Duration(seconds: 10));
    if (!mounted) return;

    setState(() => _isSuccess = true);

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    context.pop(true); // true = payment succeeded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeuBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (!_isSuccess)
                    NeuCircleButton(
                      size: 36,
                      icon: Icons.close_rounded,
                      onTap: () => context.pop(false), // false = cancelled
                    ),
                  SizedBox(width: 14.w),
                  Text('${widget.method.label} checkout', style: AppTextStyles.h2),
                ],
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isSuccess
                    ? Column(
                        key: const ValueKey('payment-success'),
                        children: [
                          const NeuSuccessCheck(),
                          SizedBox(height: 20.h),
                          Text('Payment successful', style: AppTextStyles.h2),
                        ],
                      )
                    : Column(
                        key: const ValueKey('payment-processing'),
                        children: [
                          Container(
                            width: 84.w,
                            height: 84.w,
                            decoration: BoxDecoration(
                              color: kNeuBg,
                              shape: BoxShape.circle,
                              boxShadow: neuShadows(distance: 6, blur: 14),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(24.w),
                              child: const CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(AppColors.navy),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Processing payment...',
                            style: AppTextStyles.h3,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Please wait while we confirm your '
                            '${widget.method.label} payment.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySecondary,
                          ),
                        ],
                      ),
              ),
              const Spacer(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
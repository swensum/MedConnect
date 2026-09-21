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
  bool _isProcessing = false;

  Future<void> _simulatePayment() async {
    setState(() => _isProcessing = true);

    // TODO: replace this whole method with the real provider call:
    //   eSewa -> launch esewa_flutter_sdk checkout, or a WebView loading
    //   the backend-signed payment URL.
    //   Khalti -> KhaltiPayment.pay(config: ..., onSuccess: ..., onFailure: ...)
    await Future.delayed(const Duration(seconds: 2));

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
              Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  color: kNeuBg,
                  shape: BoxShape.circle,
                  boxShadow: neuShadows(distance: 6, blur: 14),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 38.sp,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Redirecting to ${widget.method.label}...',
                style: AppTextStyles.h3,
              ),
              SizedBox(height: 8.h),
              Text(
                'This is a placeholder screen for testing the flow. Once '
                'payment is wired up, this becomes the real '
                '${widget.method.label} checkout.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const Spacer(),
              NeuPillButton(
                enabled: !_isProcessing,
                loading: _isProcessing,
                onTap: _simulatePayment,
                label: 'Simulate successful payment',
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
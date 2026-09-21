import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Providers/appointment_providers.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/models/patient_home_models.dart';
import 'package:med_connect/models/payment_models.dart';
import 'package:med_connect/providers/booking_providers.dart';

class PaymentCheckoutScreen extends ConsumerStatefulWidget {
  const PaymentCheckoutScreen({
    super.key,
    required this.method,
    required this.appointment,
  });

  final PaymentMethod method;
  final AppointmentPreview appointment;

  @override
  ConsumerState<PaymentCheckoutScreen> createState() =>
      _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState
    extends ConsumerState<PaymentCheckoutScreen> {
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

    ref.read(appointmentsProvider.notifier).add(widget.appointment);
    ref.read(bookingDraftProvider.notifier).reset();

    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    context.go(AppRoutes.patientHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeuBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Full width keeps both states centered
              SizedBox(
                width: double.infinity,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isSuccess
                      ? Column(
                          key: const ValueKey('payment-success'),
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const NeuSuccessCheck(),

                            SizedBox(height: 20.h),

                            Text(
                              'Payment successful',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.h2,
                            ),

                            SizedBox(height: 8.h),

                            Text(
                              'Taking you home...',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          key: const ValueKey('payment-processing'),
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 84.w,
                              height: 84.w,
                              decoration: BoxDecoration(
                                color: kNeuBg,
                                shape: BoxShape.circle,
                                boxShadow: neuShadows(
                                  distance: 6,
                                  blur: 14,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(24.w),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.navy,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            Text(
                              'Processing payment...',
                              textAlign: TextAlign.center,
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
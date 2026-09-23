import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Providers/appointment_providers.dart';
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/payment_widgets.dart';
import 'package:med_connect/models/patient_home_models.dart';
import 'package:med_connect/models/payment_models.dart';
import 'package:med_connect/providers/booking_providers.dart';
import 'package:med_connect/providers/doctor_providers.dart';
import 'package:med_connect/providers/payment_providers.dart';

class BookingConfirmScreen extends ConsumerStatefulWidget {
  const BookingConfirmScreen({super.key});

  @override
  ConsumerState<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  bool _isConfirming = false;
  bool _isConfirmed = false;

  AppointmentPreview? _confirmedAppointment;

  Future<void> _confirm(AppointmentPreview appointment) async {
    if (_isConfirming) return;

    final method = ref.read(selectedPaymentMethodProvider);

    if (method.requiresOnlineCheckout) {
      context.push(AppRoutes.paymentCheckout, extra: (method, appointment));
      return;
    }

    // Cash — nothing external to wait on, confirm right here.
    setState(() => _isConfirming = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    ref.read(appointmentsProvider.notifier).add(appointment);
    ref.read(bookingDraftProvider.notifier).reset();

    setState(() {
      _confirmedAppointment = appointment;
      _isConfirming = false;
      _isConfirmed = true;
    });

    // Brief success moment, then auto-navigate home — same behavior
    // requested for the payment path.
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    context.go(AppRoutes.patientHome);
  }

  @override
  Widget build(BuildContext context) {
    if (_isConfirmed && _confirmedAppointment != null) {
      return Scaffold(
        backgroundColor: kNeuBg,
        body: SafeArea(
          child: _SuccessView(appointment: _confirmedAppointment!),
        ),
      );
    }

    final doctor = ref.watch(selectedDoctorProvider);
    final draft = ref.watch(bookingDraftProvider);

    if (doctor == null || !draft.isComplete) {
      return Scaffold(
        backgroundColor: kNeuBg,
        body: SafeArea(
          child: Center(
            child: Text(
              'Nothing to confirm.',
              style: AppTextStyles.bodySecondary,
            ),
          ),
        ),
      );
    }

    final appointment = AppointmentPreview.fromBooking(
      doctorName: doctor.name,
      specialization: doctor.specialization,
      date: draft.date!,
      time: draft.slot!,
      consultationMode: draft.consultationMode!,
    );

    return Scaffold(
      backgroundColor: kNeuBg,
      body: SafeArea(child: _summaryView(doctor, draft, appointment)),
    );
  }

  Widget _summaryView(doctor, draft, AppointmentPreview appointment) {
    return Column(
      key: const ValueKey('booking-summary'),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
          child: Row(
            children: [
              NeuCircleButton(
                size: 36,
                icon: Icons.arrow_back_rounded,
                onTap: () => context.pop(),
              ),
              SizedBox(width: 14.w),
              Text('Confirm booking', style: AppTextStyles.h2),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: kNeuBg,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: neuShadows(distance: 4, blur: 10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46.w,
                            height: 46.w,
                            decoration: BoxDecoration(
                              color: kNeuBg,
                              shape: BoxShape.circle,
                              boxShadow: neuShadows(
                                distance: 3,
                                blur: 7,
                                inset: true,
                              ),
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              size: 21.sp,
                              color: AppColors.navy,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  doctor.specialization,
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Divider(
                          height: 1,
                          color: AppColors.mutedBlue.withValues(alpha: 0.4),
                        ),
                      ),
                      _summaryRow(
                        Icons.videocam_outlined,
                        'Mode',
                        draft.consultationMode!,
                      ),
                      SizedBox(height: 12.h),
                      _summaryRow(
                        Icons.calendar_today_outlined,
                        'Date',
                        '${appointment.weekday}, ${appointment.dayNumber} '
                            '${appointment.monthYear}',
                      ),
                      SizedBox(height: 12.h),
                      _summaryRow(
                        Icons.access_time_rounded,
                        'Time',
                        draft.slot!,
                      ),
                      if (draft.note.trim().isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        _summaryRow(
                          Icons.notes_rounded,
                          'Note',
                          draft.note.trim(),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 26.h),

                Text('Payment method', style: AppTextStyles.h3),
                SizedBox(height: 12.h),
                Consumer(
                  builder: (context, ref, _) {
                    final selectedMethod = ref.watch(
                      selectedPaymentMethodProvider,
                    );
                    return PaymentMethodSelector(
                      selected: selectedMethod,
                      onSelect: (m) =>
                          ref
                                  .read(selectedPaymentMethodProvider.notifier)
                                  .state =
                              m,
                    );
                  },
                ),
                SizedBox(height: 8.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: kNeuBg,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: neuShadows(distance: 4, blur: 9, inset: true),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Consultation fee',
                        style: AppTextStyles.bodySecondary,
                      ),
                      Text(
                        'Rs. ${doctor.fee}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
          child: Consumer(
            builder: (context, ref, _) {
              final method = ref.watch(selectedPaymentMethodProvider);
              return NeuPillButton(
                enabled: !_isConfirming,
                loading: _isConfirming,
                onTap: () => _confirm(appointment),
                label: method.requiresOnlineCheckout
                    ? 'Pay with ${method.label}'
                    : 'Confirm booking',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: AppColors.textSecondary),
        SizedBox(width: 10.w),
        SizedBox(
          width: 70.w,
          child: Text(label, style: AppTextStyles.caption),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.appointment});
  final AppointmentPreview appointment;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('booking-success'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NeuSuccessCheck(),
            SizedBox(height: 20.h),
            Text('Appointment booked!', style: AppTextStyles.h2),
            SizedBox(height: 6.h),
            Text(
              '${appointment.doctorName} · ${appointment.weekday}, '
              '${appointment.time}',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              'Taking you home...',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

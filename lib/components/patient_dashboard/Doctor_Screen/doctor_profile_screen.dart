import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/providers/booking_providers.dart'; // lowercase — must match book_appointment_screen.dart
import 'package:med_connect/Routers/app_router.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/doctor_profile_widgets.dart';
import 'package:med_connect/models/patient_home_models.dart';
import 'package:med_connect/providers/doctor_providers.dart';

class DoctorProfileScreen extends ConsumerWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = ref.watch(selectedDoctorProvider);

    if (doctor == null) {
      return Scaffold(
        backgroundColor: kNeuBg,
        body: SafeArea(
          child: Center(
            child: Text('No doctor selected.', style: AppTextStyles.bodySecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kNeuBg,
      body: SafeArea(
        child: Column(
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
                  const Spacer(),
                  NeuCircleButton(
                    size: 36,
                    icon: Icons.share_outlined,
                    onTap: () {
                     
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 96.w,
                            height: 96.w,
                            decoration: BoxDecoration(
                              color: kNeuBg,
                              shape: BoxShape.circle,
                              boxShadow: neuShadows(distance: 6, blur: 14),
                            ),
                            child: Icon(Icons.person_rounded,
                                size: 46.sp, color: AppColors.navy),
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(doctor.name, style: AppTextStyles.h2),
                              SizedBox(width: 6.w),
                              Icon(Icons.verified_rounded,
                                  size: 18.sp, color: AppColors.navy),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(doctor.specialization,
                              style: AppTextStyles.bodySecondary),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),

                    _statsRow(doctor),
                    SizedBox(height: 26.h),

                    Text('Consultation options', style: AppTextStyles.h3),
                    SizedBox(height: 12.h),
                    ConsultationModeRow(modes: doctor.consultationModes),
                    SizedBox(height: 26.h),

                    Text("Today's availability", style: AppTextStyles.h3),
                    SizedBox(height: 12.h),
                    TodaySlotsRow(
                      slots: doctor.todaySlots,
                     onTapSlot: (slot) {
  ref.read(bookingDraftProvider.notifier)
    ..selectMode('Video call')
    ..selectDate(DateTime.now())
    ..selectSlot(slot);
  context.push(AppRoutes.bookAppointment);
},
                    ),
                    SizedBox(height: 26.h),

                    if (doctor.workplaceName != null) ...[
                      Text('Works at', style: AppTextStyles.h3),
                      SizedBox(height: 12.h),
                      WorkplaceCard(
                        name: doctor.workplaceName!,
                        address: doctor.workplaceAddress ?? '',
                        onTap: () {
                         
                        },
                      ),
                      SizedBox(height: 26.h),
                    ],

                    Text('About', style: AppTextStyles.h3),
                    SizedBox(height: 10.h),
                    Text(
                      doctor.bio ??
                          '${doctor.name} is a ${doctor.specialization.toLowerCase()} '
                              'with ${doctor.experienceYears} years of clinical '
                              'experience, dedicated to providing thorough, '
                              'compassionate care.',
                      style: AppTextStyles.body.copyWith(height: 1.5),
                    ),
                    SizedBox(height: 26.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Patient reviews (${doctor.reviewCount})',
                          style: AppTextStyles.h3,
                        ),
                        if (doctor.reviews.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                             
                            },
                            child: Text(
                              'See all',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    if (doctor.reviews.isEmpty)
                      Text(
                        'No reviews yet.',
                        style: AppTextStyles.bodySecondary,
                      )
                    else
                      ...doctor.reviews.take(2).map(
                            (r) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: ReviewCard(review: r),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
              child: NeuPillButton(
                enabled: true,
                onTap: () {
                  ref.read(bookingDraftProvider.notifier)
                    ..reset()
                    ..selectDate(DateTime.now());
                  context.push(AppRoutes.bookAppointment);
                },
                label: 'Book appointment',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsRow(DoctorPreview doctor) {
    Widget stat(IconData icon, String value, String label) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: kNeuBg,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: neuShadows(distance: 3, blur: 8),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18.sp, color: AppColors.navy),
              SizedBox(height: 6.h),
              Text(value,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
              SizedBox(height: 2.h),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        stat(Icons.star_rounded, doctor.rating.toStringAsFixed(1), 'Rating'),
        SizedBox(width: 10.w),
        stat(Icons.work_history_outlined, '${doctor.experienceYears} yrs', 'Experience'),
        SizedBox(width: 10.w),
        stat(Icons.payments_outlined, 'Rs. ${doctor.fee}', 'Fee'),
      ],
    );
  }
}
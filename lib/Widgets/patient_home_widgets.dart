import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/models/patient_home_models.dart';

class LocationRow extends StatelessWidget {
  const LocationRow({
    super.key,
    required this.location,
    this.onTap,
  });

  final String location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 16.sp, color: AppColors.navy),
          SizedBox(width: 4.w),
          Text(
            location,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 2.w),
          Icon(Icons.keyboard_arrow_down_rounded,
              size: 16.sp, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

/// The navy "today's appointment" hero card — big date, name,
/// specialization, time, and a decorative illustration on the right.
class TodayAppointmentCard extends StatelessWidget {
  const TodayAppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  /// Null shows the empty state instead.
  final AppointmentPreview? appointment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appt = appointment;

    if (appt == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: neuShadows(distance: 4, blur: 10, inset: true),
        ),
        child: Text(
          'No upcoming appointments — book one with a doctor near you.',
          style: AppTextStyles.bodySecondary,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        // Keeps the image from spilling past the card's rounded corners
        // even if it overflows the card's edges elsewhere.
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: neuShadows(distance: 6, blur: 14),
          ),
          child: Stack(
            clipBehavior: Clip.none, // let the image bleed past the card edge if you position it there
            children: [
              // Main content, padded as before.
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Your next appointment',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 30.h),

                  
                    

                    
                    Text(
                      appt.dayNumber,
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 40.sp,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '${appt.monthYear} • ${appt.weekday}',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      appt.time,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Stethoscope image — positioned and sized independently
              // of the text column. Tune right/bottom/width to taste.
              Positioned(
                right: 10.w,
                bottom: -6.h,
                child: Image.asset(
                  'assets/stethoscope.png',
                  width: 140.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// Horizontal scrollable row of specialization shortcuts.
class SpecializationRow extends StatelessWidget {
  const SpecializationRow({
    super.key,
    required this.shortcuts,
    this.onTapShortcut,
  });

  final List<SpecializationShortcut> shortcuts;
  final void Function(SpecializationShortcut shortcut)? onTapShortcut;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shortcuts.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, i) {
          final s = shortcuts[i];
          return GestureDetector(
            onTap: () => onTapShortcut?.call(s),
            child: Container(
              width: 72.w,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: kNeuBg,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: neuShadows(distance: 4, blur: 9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(s.icon, size: 22.sp, color: AppColors.navy),
                  SizedBox(height: 6.h),
                  Text(
                    s.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A single doctor row for the "Top doctors" list.
class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor, this.onTap});

  final DoctorPreview doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: neuShadows(distance: 4, blur: 10),
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
              ),
              child: Icon(Icons.person_rounded, color: AppColors.navy, size: 26.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${doctor.specialization} · ${doctor.experienceYears} yrs exp',
                    style: AppTextStyles.caption,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 14.sp, color: Colors.amber.shade700),
                      SizedBox(width: 3.w),
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Rs. ${doctor.fee}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18.sp, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
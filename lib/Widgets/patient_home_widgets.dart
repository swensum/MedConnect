import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';

import 'package:med_connect/models/patient_home_models.dart';

// TODO: move these into AppColors in Theme/theme.dart so the rest of the
// app can reuse the same emergency/tip accents.
const kEmergencyColor = Color(0xFFD2484A);
const kEmergencyTint = Color(0xFFFBE7E7);
const kTipColor = Color(0xFF2E9E6E);
const kTipTint = Color(0xFFE4F5ED);

class LocationRow extends StatelessWidget {
  const LocationRow({super.key, required this.location, this.onTap});

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
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16.sp,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

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
        // Keeps the image and glow from spilling past the card's rounded
        // corners even if they overflow the card's edges elsewhere.
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.navy,
                Color.lerp(AppColors.navy, Colors.black, 0.9)!,
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: neuShadows(distance: 2, blur: 2),
          ),
          child: Stack(
            clipBehavior: Clip.none, // let the image bleed past the card edge if you position it there
            children: [
              // Soft radial "shine" glow sitting behind the image.
              Positioned(
                right: -30.w,
                bottom: -30.h,
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.18),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),

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
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    Text(
                      appt.dayNumber,
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 40.sp,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '${appt.monthYear} • ${appt.weekday}',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
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
                bottom: 10.h,
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

/// Horizontal row of shortcut tiles for "What do you need today?".
/// Replaces the old SpecializationRow — same shape, but drives the icon
/// and label to `kEmergencyColor` when [QuickAction.isEmergency] is true.
class QuickActionRow extends StatelessWidget {
  const QuickActionRow({super.key, required this.actions, this.onTapAction});

  final List<QuickAction> actions;
  final void Function(QuickAction action)? onTapAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Extra height gives the boxShadow room to render fully instead
      // of being clipped at the top/bottom edge of the ListView viewport.
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // Default is Clip.hardEdge, which slices off anything (like
        // shadows) that extends past the viewport bounds. Clip.none
        // lets shadows render in full.
        clipBehavior: Clip.none,
        // Padding here (instead of on a parent) keeps the first and
        // last tile's shadow from being flush against — and cut off
        // by — the edge of whatever container this sits inside.
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        itemCount: actions.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, i) {
          final a = actions[i];
          final iconColor = a.isEmergency ? kEmergencyColor : AppColors.navy;
          return GestureDetector(
            onTap: () => onTapAction?.call(a),
            child: Container(
              width: 76.w,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
              decoration: BoxDecoration(
                color: kNeuBg,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: neuShadows(distance: 4, blur: 9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(a.icon, size: 22.sp, color: iconColor),
                  SizedBox(height: 8.h),
                  Text(
                    a.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: a.isEmergency ? kEmergencyColor : null,
                    ),
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

/// A single hospital/clinic card for the "Hospitals near you" row.
class HospitalCard extends StatelessWidget {
  const HospitalCard({super.key, required this.hospital, this.onTap});

  final HospitalPreview hospital;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190.w,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: neuShadows(distance: 4, blur: 10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hospital.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13.5.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 13.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4.w),
                Text(hospital.distanceLabel, style: AppTextStyles.caption),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: hospital.isOpen
                        ? kTipColor
                        : AppColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  hospital.isOpen ? 'Open now' : 'Closed',
                  style: AppTextStyles.caption.copyWith(
                    color: hospital.isOpen
                        ? kTipColor
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scroll row of [HospitalCard]s for "Hospitals near you".
class HospitalRow extends StatelessWidget {
  const HospitalRow({super.key, required this.hospitals, this.onTapHospital});

  final List<HospitalPreview> hospitals;
  final void Function(HospitalPreview hospital)? onTapHospital;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        itemCount: hospitals.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, i) => HospitalCard(
          hospital: hospitals[i],
          onTap: () => onTapHospital?.call(hospitals[i]),
        ),
      ),
    );
  }
}

/// The single "today's health tip" card.
class HealthTipCard extends StatelessWidget {
  const HealthTipCard({super.key, required this.tip});

  final HealthTip tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: kTipTint,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: kTipColor,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(Icons.eco_outlined, size: 18.sp, color: Colors.white),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.label,
                  style: AppTextStyles.caption.copyWith(
                    color: kTipColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  tip.text,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13.5.sp,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single row for the "Exercises from your doctor" list — same shape as
/// the old DoctorCard row.
class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({super.key, required this.exercise, this.onTap});

  final ExercisePreview exercise;
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
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
              ),
              child: Icon(exercise.icon, color: AppColors.navy, size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(exercise.note, style: AppTextStyles.caption),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        exercise.durationLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: kTipColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text('·', style: AppTextStyles.caption),
                      SizedBox(width: 8.w),
                      Text(
                        exercise.doctorName,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// A single doctor row — kept for reuse on the doctor discovery/list
/// screens, even though it's no longer shown on the home tab.
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
              child: Icon(
                Icons.person_rounded,
                color: AppColors.navy,
                size: 26.sp,
              ),
            ),
            SizedBox(width: 14.w),
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
                  SizedBox(height: 2.h),
                  Text(
                    '${doctor.specialization} · ${doctor.experienceYears} yrs exp',
                    style: AppTextStyles.caption,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 14.sp,
                        color: Colors.amber.shade700,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
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
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
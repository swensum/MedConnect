import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/models/patient_home_models.dart';

/// Row of consultation-mode pills (In-clinic / Video call) — informational,
/// not tappable on their own; the actual choice happens inside booking.
class ConsultationModeRow extends StatelessWidget {
  const ConsultationModeRow({super.key, required this.modes});
  final List<String> modes;

  IconData _iconFor(String mode) {
    switch (mode) {
      case 'Video call':
        return Icons.videocam_outlined;
      case 'In-clinic':
      default:
        return Icons.local_hospital_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: modes.map((m) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: kNeuBg,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: neuShadows(distance: 3, blur: 7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_iconFor(m), size: 15.sp, color: AppColors.navy),
              SizedBox(width: 6.w),
              Text(
                m,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Horizontal row of today's open time slots. Tapping one jumps straight
/// into booking pre-filled with that slot — tapping "Book appointment"
/// at the bottom instead opens the full date/time picker.
class TodaySlotsRow extends StatelessWidget {
  const TodaySlotsRow({super.key, required this.slots, this.onTapSlot});

  final List<String> slots;
  final void Function(String slot)? onTapSlot;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: neuShadows(distance: 3, blur: 8, inset: true),
        ),
        child: Text(
          'No slots open today — check upcoming dates when booking.',
          style: AppTextStyles.bodySecondary,
        ),
      );
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: slots.map((s) {
        return GestureDetector(
          onTap: () => onTapSlot?.call(s),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: kNeuBg,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: neuShadows(distance: 3, blur: 7),
            ),
            child: Text(
              s,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                color: AppColors.navy,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Workplace/clinic info card with a location icon — tapping could open
/// maps later.
class WorkplaceCard extends StatelessWidget {
  const WorkplaceCard({
    super.key,
    required this.name,
    required this.address,
    this.onTap,
  });

  final String name;
  final String address;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: neuShadows(distance: 4, blur: 9),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
              ),
              child: Icon(Icons.local_hospital_rounded,
                  size: 20.sp, color: AppColors.navy),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(address, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18.sp, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// A single patient review card.
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});
  final DoctorReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: kNeuBg,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: neuShadows(distance: 3, blur: 8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: kNeuBg,
                  shape: BoxShape.circle,
                  boxShadow: neuShadows(distance: 2, blur: 4, inset: true),
                ),
                child: Icon(Icons.person_rounded,
                    size: 16.sp, color: AppColors.navy),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  review.patientName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Icon(Icons.star_rounded, size: 14.sp, color: Colors.amber.shade700),
              SizedBox(width: 3.w),
              Text(
                review.rating.toStringAsFixed(1),
                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review.comment,
            style: AppTextStyles.body.copyWith(fontSize: 13.sp, height: 1.4),
          ),
          SizedBox(height: 8.h),
          Text(review.timeAgo, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
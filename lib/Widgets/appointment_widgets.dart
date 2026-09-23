import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/models/patient_home_models.dart';

class AppointmentListCard extends StatelessWidget {
  const AppointmentListCard({
    super.key,
    required this.appointment,
    this.onTap,
    this.onCancel,
    this.onBookAgain,
  });

  final AppointmentPreview appointment;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onBookAgain;

  @override
  Widget build(BuildContext context) {
    final isVideo = appointment.consultationMode == 'Video call';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
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
                    boxShadow: neuShadows(distance: 3, blur: 7, inset: true),
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
                        appointment.doctorName,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        appointment.specialization,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                if (appointment.consultationMode != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: kNeuBg,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isVideo
                              ? Icons.videocam_outlined
                              : Icons.local_hospital_outlined,
                          size: 12.sp,
                          color: AppColors.navy,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          appointment.consultationMode!,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(
                height: 1,
                color: AppColors.mutedBlue.withValues(alpha: 0.4),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  '${appointment.weekday}, ${appointment.dayNumber} ${appointment.monthYear}',
                  style: AppTextStyles.caption,
                ),
                SizedBox(width: 14.w),
                Icon(
                  Icons.access_time_rounded,
                  size: 14.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(appointment.time, style: AppTextStyles.caption),
              ],
            ),
            if (onCancel != null || onBookAgain != null) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (onCancel != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onCancel,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: kNeuBg,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: neuShadows(
                              distance: 2,
                              blur: 5,
                              inset: true,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (onBookAgain != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onBookAgain,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.navy,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Book again',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

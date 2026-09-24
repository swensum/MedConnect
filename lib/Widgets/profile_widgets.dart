import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_connect/Animations/neumorphic.dart';
import 'package:med_connect/Theme/theme.dart';
import 'package:med_connect/Widgets/patient_home_widgets.dart';
import 'package:med_connect/models/health_metric_model.dart';
import 'package:med_connect/models/patient_home_models.dart';

/// One stat pill in the profile header (Age / Blood type / City, etc.)
class ProfileStatChip extends StatelessWidget {
  const ProfileStatChip({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: neuShadows(distance: 3, blur: 8, inset: true),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 2.h),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

/// One tappable row in the profile menu (Payment methods, Help, etc.)
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.danger : AppColors.navy;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: kNeuBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: neuShadows(distance: 3, blur: 8),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: kNeuBg,
                shape: BoxShape.circle,
                boxShadow: neuShadows(distance: 2, blur: 5, inset: true),
              ),
              child: Icon(icon, size: 17.sp, color: color),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5.sp,
                  color: isDestructive ? AppColors.danger : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18.sp, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
class HealthMetricsRow extends StatelessWidget {
  const HealthMetricsRow({super.key, required this.metrics});
  final List<HealthMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        itemCount: metrics.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, i) {
          final m = metrics[i];
          return Container(
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
                Icon(m.icon, size: 22.sp, color: m.accentColor),
                SizedBox(height: 8.h),
                Text(
                  m.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  m.value,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  final AppointmentPreview appointment;
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
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: neuShadows(distance: 4, blur: 10),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar — stretches to roughly match the row's full height
              // via IntrinsicHeight + CrossAxisAlignment.stretch above.
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: kNeuBg,
                    shape: BoxShape.circle,
                    boxShadow: neuShadows(distance: 3, blur: 7, inset: true),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 26.sp,
                    color: AppColors.navy,
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // Name / specialization (top) + date / time (bottom).
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          appointment.specialization,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 12.sp, color: AppColors.textSecondary),
                        SizedBox(width: 4.w),
                        Text(
                          '${appointment.dayNumber} ${appointment.monthYear}',
                          style: AppTextStyles.caption.copyWith(fontSize: 10.5.sp),
                        ),
                        SizedBox(width: 10.w),
                        Icon(Icons.access_time_rounded,
                            size: 12.sp, color: AppColors.textSecondary),
                        SizedBox(width: 4.w),
                        Text(
                          appointment.time,
                          style: AppTextStyles.caption.copyWith(fontSize: 10.5.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Status tag, pinned to the far right.
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: kTipTint,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Confirmed',
                    style: AppTextStyles.caption.copyWith(
                      color: kTipColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}